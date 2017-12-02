

`include "include_file.v"

module scheduler_noc(
input            clk,
// PCI - Scheduler interface 
input            i_valid_pci,
input [255:0]    i_data_pci,
output reg       o_ready_pci,
// From scheduler to PCI
output wire [255:0] o_data_pci,
output wire o_valid_pci,
input i_ready_pci,
//Scheduler-NOC interfaces
input i_ready,
output reg o_valid,
output reg [`total_width-1:0] o_data,
//from NOC to Schedler
input wea,
input [`total_width-1:0] i_data_pe
//output o_ready_pe
);

reg [`pck_num-1:0]rd_addr;
wire [`pck_num-1:0] wr_addr;
reg [`x_size-1:0] x_coord;
reg [`y_size-1:0] y_coord;
reg [`pck_num-1:0] pck_no;
//reg [4:0] counter;
//reg [4:0] addr_counter;
//reg counter_valid;
//reg [4 : 0] addra;
//reg [4 : 0] addrb;
//reg [256 : 0] dina;
//wire  [255 : 0] doutb;
wire valid_flag;
//reg enb;


reg [256:0] my_mem [`sw_no-1:0];

initial
begin
  if(`X>1)
  begin
      x_coord = 'd1;
      y_coord = 'd0;
  end
  else
  begin
      x_coord = 'd0;
      y_coord = 'd1;
  end
  pck_no = 'd0;
  //counter = 'd0;
  //addr_counter = 'd0;
  //addrb<='hz;
  rd_addr<='d0;
end

/*
always@(posedge clk)
begin
  if(reset)
    begin 
	  x_coord = 'd0;
	  y_coord = 'd1;
	  pck_no = 'd0;
	  rd_addr<='d0;
	end  
end*/

always @(posedge clk)
begin
    if(i_valid_pci & o_ready_pci )
    begin
        o_data[`total_width-1:`y_size+`x_size+`pck_num]<=i_data_pci[247:0];
	    o_data[`x_size+`y_size+`pck_num-1:`y_size+`x_size]<=pck_no;
	    o_data[`x_size+`y_size-1:`x_size]<=y_coord;
	    o_data[`x_size-1:0]<=x_coord;
	    o_valid<=1'b1;
	    if(pck_no < `sw_no-1)
             pck_no<=pck_no+1;
        else
             pck_no<= 'd0;
             
	    if(x_coord < `X-1)
	      x_coord<=x_coord+1;
	    else if(y_coord < `Y-1)
	    begin
	    	x_coord <= 'd0;
            y_coord <= y_coord+1;
        end
		else
		begin
            if(`X>1)
            begin
                x_coord = 'd1;
                y_coord = 'd0;
            end
            else
            begin
                x_coord = 'd0;
                y_coord = 'd1;
            end
		end
	end	  
    else
    begin
        o_valid<=1'b0;
    end
end

always@(posedge clk)
begin
   if(i_ready)
   begin
       o_ready_pci<=1'b1;
   end
   else
       o_ready_pci<=1'b0;
end

assign wr_addr = i_data_pe[`x_size+`y_size+`pck_num-1:`y_size+`x_size];
assign o_valid_pci = my_mem[rd_addr][256];
assign o_data_pci = my_mem[rd_addr];

always@(posedge clk)
begin
    if(wea)
    begin 
	 //wr_addr = i_data_pe[8:4];
	     my_mem[wr_addr]<=i_data_pe[`total_width-1:`y_size+`x_size+`pck_num];
	     my_mem[wr_addr][256]<=1'b1;
  end
  if(o_valid_pci & i_ready_pci )
  begin
     my_mem[rd_addr][256]<=1'b0;
  end       
 end
 


always@(posedge clk)
 begin
  if(o_valid_pci & i_ready_pci )
   begin
   if(rd_addr<`sw_no-1)
     begin
	  rd_addr<=rd_addr+1;
	 end 
   else
     begin
	  rd_addr<='d0;
     end
   end  
 end
 
/*
always@(posedge clk)
begin
 if(wea)
  begin
  addra<= i_data_pe[8:4];
  dina<= i_data_pe[264:9];
  counter<= counter +1;
  if(counter >'d15)
   begin
    counter_valid<=1'b1;
   end
   
  else
    begin
	  counter_valid<=1'b0;
	end
  end
end

always@(posedge clk)
begin
 if(counter_valid & i_ready_pci)
  begin
    o_data_pci<=doutb;
	
	enb<=1'b1;
	addrb<= addr_counter;
	counter<=counter-1;
	if(addrb == 2)
	 begin
	   o_valid_pci<=1'b1;
	 end
	if(addr_counter<31)
	addr_counter<=addr_counter+1;
	else
	addr_counter<='d0;
  end
  
 else
   o_valid_pci<=1'b0;
end
*/


/*
blk_mem_gen_0 sch_ram(
  .clka(clk),    // input wire clka
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [4 : 0] addra
  .dina(dina),    // input wire [256 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(enb),      // input wire enb
  .addrb(addrb),  // input wire [4 : 0] addrb
  .doutb(doutb)  // output wire [256 : 0] doutb
);
*/

/*sch_ram sch_ram (
  .clka(clk), // input clka
  .wea(wea), // input [0 : 0] wea
  .addra(addra), // input [4 : 0] addra
  .dina(dina), // input [255 : 0] dina
  .clkb(clk), // input clkb
  .addrb(addrb), // input [4 : 0] addrb
  .doutb(doutb) // output [255 : 0] doutb
);*/

endmodule

