/////////////////////////////////////////////////////////////////////////////////////////////
//File Name : switch.v                                                                     //
//Description : Bufferless router following XY routing                                     //
/////////////////////////////////////////////////////////////////////////////////////////////


module switch #(parameter x_coord ='d0,parameter y_coord='d0,X=2,Y=2,data_width=32, x_size=1, y_size=1,total_width=(x_size+y_size+data_width),sw_no=X*Y)
(
input wire clk,
input wire rstn,
input wire i_ready_r,
input wire i_ready_t,
input wire i_ready_pe,
input wire i_valid_l,
input wire i_valid_b,
input wire i_valid_pe,
output wire o_ready_l,
output wire o_ready_b,
output reg  o_ready_pe,
output reg o_valid_r,
output reg o_valid_t,
output reg o_valid_pe,
input wire [total_width-1:0] i_data_l,
input wire [total_width-1:0] i_data_b,
input wire [total_width-1:0] i_data_pe,
output reg [total_width-1:0] o_data_r,
output reg [total_width-1:0] o_data_t,
output reg [total_width-1:0] o_data_pe

);
wire leftToPe;
wire bottomToPe;
wire peTope;
wire leftToRight;
wire leftToTop;
wire bottomToRight;
wire bottomToTop;
wire peToTop;
wire peToRight;

assign  o_ready_l = 1'b1;
assign  o_ready_b = 1'b1;

assign leftToPe = ((i_data_l[x_size-1:0]==x_coord) & (i_data_l[x_size+y_size-1:x_size]==y_coord) & i_valid_l);
assign leftToRight = ((i_data_l[x_size-1:0]!=x_coord) & i_valid_l);
assign leftToTop = (i_data_l[x_size-1:0]==x_coord) & (i_data_l[x_size+y_size-1:x_size]!=y_coord) & i_valid_l;
assign bottomToPe = (i_data_b[x_size-1:0]==x_coord) & (i_data_b[x_size+y_size-1:x_size]==y_coord) & i_valid_b;
assign bottomToRight = (i_data_b[x_size+y_size-1:x_size]==y_coord) & (i_data_b[x_size-1:0]!=x_coord) & i_valid_b;// ? 1'b1 : 1'b0;
assign bottomToTop = (i_data_b[x_size+y_size-1:x_size]!=y_coord ) & i_valid_b;

assign peTope = ((i_data_pe[x_size-1:0]==x_coord) & (i_data_pe[x_size+y_size-1:x_size]==y_coord) & i_valid_pe & o_ready_pe);
assign peToRight = ((i_data_pe[x_size-1:0]!=x_coord) & i_valid_pe & o_ready_pe);
assign peToTop = (~peToRight & (i_data_pe[x_size+y_size-1:x_size]!=y_coord) & i_valid_pe & o_ready_pe);


always @(*)
begin
	//If there are no packets to either right or top, we can accept data from PE
	//If packets have to be sent to both out ports, will have to back pressure the PE
	if((~leftToRight & ~leftToTop & ~leftToPe) | (~bottomToTop & ~bottomToRight & ~bottomToPe))
	begin
		o_ready_pe = 1'b1;
	end
	else
	begin
		o_ready_pe = 1'b0;
	end
end

always @(posedge clk)
begin
	if(!rstn)
		o_valid_r <=1'b0;
	//Whenever data from left wants to go right, it will be given preference
	if(bottomToRight) 
	begin
		o_data_r  <= i_data_b;
		o_valid_r <= 1'b1;
	end
	else if(leftToTop)
	begin
		if(bottomToTop)
		begin
			o_data_r <= i_data_b;
			o_valid_r <= 1'b1;
		end
		else if(peToTop|peToRight)
		begin
			o_data_r <= i_data_pe;
			o_valid_r <= 1'b1;
		end
		else if(bottomToPe & !i_ready_pe)
		begin
			o_data_r <= i_data_b;
			o_valid_r <= 1'b1;
		end
		else if(peTope & !i_ready_pe)
		begin
			o_data_r <= i_data_b;
			o_valid_r <= 1'b1;
		end
		else
			o_valid_r <= 1'b0;
	end
	else if(peToTop)
	begin
		if(bottomToTop)
		begin
			o_data_r  <= i_data_b;
			o_valid_r <= 1'b1;
		end
		else if(leftToRight)
		begin
			o_data_r  <= i_data_l;
			o_valid_r <= 1'b1;
		end
		else if(leftToPe & ~i_ready_pe)
		begin
			o_data_r  <= i_data_l;
			o_valid_r <= 1'b1;
		end
		else if(bottomToPe & ~i_ready_pe)
		begin
			o_data_r  <= i_data_b;
			o_valid_r <= 1'b1;
		end
		else
			o_valid_r <= 1'b0;
	end
	else if(leftToPe)
	begin
		if(peTope)
		begin
			o_data_r <= i_data_l;
			o_valid_r <= 1'b1;
		end
		else if(peToRight)
		begin
			o_data_r <= i_data_pe;
			o_valid_r <= 1'b1;
		end
		else if(bottomToPe)
		begin
			o_data_r <= i_data_l;
			o_valid_r <= 1'b1;
		end
		else if(~i_ready_pe)
		begin
			o_data_r  <= i_data_l;
			o_valid_r <= 1'b1;
		end
		else
			o_valid_r <= 1'b0;
	end
	else if(leftToRight)
	begin
		o_data_r  <= i_data_l;
		o_valid_r <= 1'b1;
	end
	else if(peToRight)
	begin
		o_data_r <=i_data_pe;
		o_valid_r <=1'b1;
	end
	else if(bottomToTop)
	begin
		if(peTope & !i_ready_pe)
		begin
			o_data_r <= i_data_pe;
			o_valid_r <= 1'b1;
		end
		else
			o_valid_r <= 1'b0;
	end
	else if(bottomToPe)
	begin
		if(peTope & !i_ready_pe)
		begin
			o_data_r <= i_data_pe;
			o_valid_r <= 1'b1;
		end
		else
			o_valid_r <= 1'b0;
	end
	else if(peTope & !i_ready_pe)
	begin
		o_data_r <= i_data_pe;
		o_valid_r <= 1'b1;
	end
	else
	begin
		o_valid_r <=1'b0;
	end
end

always @(posedge clk)
begin
	if(!rstn)
		o_valid_t <= 1'b0;
		
	else if(bottomToRight) 
	begin
		if(leftToRight|leftToTop)
		begin
			o_data_t <= i_data_l;
			o_valid_t <= 1'b1;
		end
		else if(peToRight|peToTop) //This and prev case mutually exclusive
		begin
			o_data_t <= i_data_pe;
			o_valid_t <= 1'b1;
		end
		else if(leftToPe & ~i_ready_pe)
		begin
			o_data_t <= i_data_l;
			o_valid_t <= 1'b1;
		end
		else if(peTope & ~i_ready_pe)
		begin
			o_data_t <= i_data_pe;
			o_valid_t <= 1'b1;
		end
		else
			o_valid_t <= 1'b0;
	end
	else if(leftToTop)
	begin
		o_data_t <= i_data_l;
		o_valid_t <= 1'b1;
	end
	else if(peToTop)
	begin
		o_data_t  <= i_data_pe;
		o_valid_t <= 1'b1;
	end
	else if(leftToPe)
	begin
		if(bottomToTop)
		begin
			o_data_t <= i_data_b;
			o_valid_t <= 1'b1;
		end
		else if(bottomToPe & ~i_ready_pe)
		begin
			o_data_t <= i_data_b;
			o_valid_t <= 1'b1;
		end
		else if(peTope & ~i_ready_pe)
		begin
			o_data_t <= i_data_pe;
			o_valid_t <= 1'b1;
		end
		else if(peToRight & ~i_ready_pe)
		begin
			o_data_t <= i_data_l;
			o_valid_t <= 1'b1;
		end
		else
			o_valid_t <= 1'b0;
	end
	else if(leftToRight)
	begin
		if(bottomToTop)
		begin
			o_data_t <= i_data_b;
			o_valid_t <= 1'b1;
		end
		else if(peToRight)
		begin
			o_data_t <= i_data_pe;
			o_valid_t <= 1'b1;
		end
		else if(bottomToPe & ~i_ready_pe)
		begin
			o_data_t <= i_data_b;
			o_valid_t <= 1'b1;
		end
		else if(peTope & ~i_ready_pe)
		begin
			o_data_t <= i_data_b;
			o_valid_t <= 1'b1;
		end
		else
			o_valid_t <= 1'b0;
	end
	else if(peToRight)
	begin
		if(bottomToTop)
		begin
			o_data_t <=i_data_b;
			o_valid_t <=1'b1;
		end
		else if(bottomToPe & ~i_ready_pe)
		begin
			o_data_t <= i_data_b;
			o_valid_t <= 1'b1;
		end
		else
			o_valid_t <= 1'b0;
	end
	else if(bottomToTop)
	begin
		o_data_t <=i_data_b;
		o_valid_t <=1'b1;
	end
	else if(bottomToPe)
	begin
		if(peTope|~i_ready_pe)
		begin
			o_data_t <= i_data_b;
			o_valid_t <= 1'b1;
		end
		else
			o_valid_t <= 1'b0;
	end
	else
		o_valid_t <= 1'b0;
end

always @(posedge clk)
begin
	if(!rstn)
		o_valid_pe <= 1'b0; 
		
	else if(peTope & i_ready_pe)
	begin
		o_data_pe <= i_data_pe;
		o_valid_pe <=1'b1;
	end
	else if(bottomToPe & i_ready_pe)
	begin
		o_data_pe  <= i_data_b;
		o_valid_pe <= 1'b1;
	end
	else if(leftToPe & i_ready_pe)
	begin
		o_data_pe <= i_data_l;
		o_valid_pe <= 1'b1;
	end
	else if(o_valid_pe & ~i_ready_pe)
		o_valid_pe <=1'b1;
	else
		o_valid_pe <=1'b0;
end


endmodule