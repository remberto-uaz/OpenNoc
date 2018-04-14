`timescale 1ns/1ps
//`define DEBUG

module randomPe #(parameter xcord=0, ycord=0,data_width=240, X=4,Y=4, dest_x=2, dest_y=2,source_x=8,source_y=8,total_width=(dest_x+dest_y+source_x+source_y+data_width),num_of_pckts=3,rate=1,pat="MixedNeighbour")
(
input wire clk,
input wire rstn,
input wire [total_width-1:0] i_data,
input wire i_valid,
output  reg [total_width-1:0] o_data,
output wire o_valid,
output wire  done,
input wire i_ready,

input start,
input enableSend,

output wire [31:0] receivedPktCount

);

integer counter;
wire [31:0] payload;
integer accept_counter=0;
wire check_reg;
integer in_data_count=0;
wire [31:0] destinationPe;
wire [31:0] sourcePe;

//reg done;
reg[dest_x-1:0]dest_x_addr;
reg [dest_y-1:0]dest_y_addr;
reg valid;

reg [31:0] transmitCounters [X*Y-1:0];
reg [31:0] receiveCounters [X*Y-1:0];

integer seed = ycord*X+xcord;
integer i;

assign receivedPktCount = in_data_count;
assign payload = i_data[dest_x+dest_y+source_x+source_y+data_width-1:dest_x+dest_y+source_x+source_y];

integer               receive_log_file;
reg   [100*8:0]       receive_log_file_name = "receive_log.csv";

initial
begin
    receive_log_file = $fopen(receive_log_file_name,"a");
    for(i=0;i<X*Y;i=i+1)
    begin
	transmitCounters[i] = 0;
	receiveCounters[i] = 0;
    end
end


assign check_reg=(counter%rate==0)?0:1;
assign o_valid = valid&!done&enableSend;

always @(posedge clk)
begin
    if(!rstn)
        counter<=0;
    else
        counter <= counter + 1;
end

always @(posedge clk)
begin
	if(!rstn)
	begin
		dest_x_addr <= 0;
		dest_y_addr<=0;
		valid <= 0;
	end
    else if(check_reg==0 & !done)
    begin
	   valid<=1'b1;
	   if(pat=="RANDOM")
	   begin
	  	   dest_x_addr = $urandom(seed)%X;
	  	   dest_y_addr = $urandom(seed)%Y;
           seed = seed + $urandom();
	   end
	  	
       else if(pat == "SELF")
       begin
	       dest_x_addr = xcord;
	       dest_y_addr = ycord;
	   end
	
	   else if(pat == "RightNeighbour")
	   begin
	       if(xcord == X-1)
	           dest_x_addr = 0;
	       else
	           dest_x_addr = xcord+1;
	       dest_y_addr = ycord;  
	   end
	
	   else if(pat == "TopNeighbour")
       begin
            if(ycord == Y-1)
                dest_y_addr = 0;
            else
                dest_y_addr = ycord+1;
            dest_x_addr = xcord;  
        end
    
        else if(pat == "MixedNeighbour")
        begin
            if($urandom(seed)%2 == 0) //randomly choose between top and right 0 to right 1 to top
            begin
                if(xcord == X-1)
                    dest_x_addr = 0;
                else
                    dest_x_addr = xcord+1;
                dest_y_addr = ycord; 
            end
            else
            begin
                if(ycord == Y-1)
                    dest_y_addr = 0;
                else
                    dest_y_addr = ycord+1;
                dest_x_addr = xcord; 
            end
            seed = seed + $urandom();
        end
	    o_data[dest_x-1:0]<=dest_x_addr;
	    o_data[dest_x+dest_y-1:dest_x]<=dest_y_addr;
	    o_data[dest_x+dest_y+source_x-1:dest_x+dest_y]<=xcord;
	    o_data[dest_x+dest_y+source_x+source_y-1:dest_x+dest_y+source_x]<=ycord;
	    o_data[dest_x+dest_y+source_x+source_y+data_width-1:dest_x+dest_y+source_x+source_y]<=counter;
     end	
     else
	     valid<=0;
 end 

assign destinationPe = o_data[dest_x+dest_y-1:dest_x]*X + o_data[dest_x-1:0]; //PE number of destination
assign sourcePe = i_data[dest_x+dest_y+source_x+source_y-1:dest_x+dest_y+source_x]*X + i_data[dest_x+dest_y+source_x-1:dest_x+dest_y]; //PE number of source

always@(posedge clk)
begin
    if(i_ready & o_valid)  
    begin
	   accept_counter<=accept_counter+1;
	   transmitCounters[destinationPe] <= transmitCounters[destinationPe] + 1;
    end
end
 
 
 always@(posedge clk)
 begin
    if(i_valid)
    begin
	   in_data_count<=in_data_count+1;
	   receiveCounters[sourcePe] <= receiveCounters[sourcePe] + 1;
       $fwrite(receive_log_file,"%0d,%0d,%0d,%0d,%0d,\n",sourcePe,ycord*X+xcord, payload, counter, counter-payload);
       $fflush(receive_log_file);
    end 
 end 
  
  

 assign done = (accept_counter==num_of_pckts) ? 1'b1 : 1'b0;

initial
begin
    @(negedge start);
    #100;
    `ifdef DEBUG
    $display("PE No:\t%d",ycord*X+xcord);
    $display("Total Packets Transmitted:\t%d",accept_counter);
    $display("Total Packets Received :\t%d",in_data_count);

        for(i=0;i<X*Y;i=i+1)
        begin
            $display("Tranmitted from %4d to %4d: %4d",ycord*X+xcord,i,transmitCounters[i]); 
        end


        for(i=0;i<X*Y;i=i+1)
        begin
            $display("Received from %4d to %4d: %4d",i,ycord*X+xcord,receiveCounters[i]); 
        end
    `endif
end
   
endmodule
