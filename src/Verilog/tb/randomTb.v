//`include "include_file.v"

`define X 2
`define Y 1
`define x_size 1
`define y_size 1
`define data_width 256
`define total_width (`x_size+`y_size+`data_width)
`define numPackets 1000
`define injectRate 1

`define clkPeriod 2

`timescale 1ns/1ps

module randomTb();
reg  clk;
reg rst;
wire done;
wire [(`X*`Y)-1:0] r_valid_pe;
wire [(`total_width*`X*`Y)-1:0] r_data_pe;
wire [(`X*`Y)-1:0] r_ready_pe;
wire [(`X*`Y)-1:0] w_valid_pe;
wire [(`total_width*`X*`Y)-1:0] w_data_pe;
integer startTime;
reg  start;
reg [(`X*`Y)-1:0] enableSend;

initial
begin
 clk = 1'b0;
 forever
 begin
    clk = ~clk;
	#(`clkPeriod/2);
 end
end

initial
begin
    rst = 0;
    #10;
    rst = 1;
    enableSend = 'hFFFF;
    start = 1'b1;
	startTime = $time;
end



openNocTop #(.X(`X),.Y(`Y),.data_width(`data_width), .x_size(`x_size),.y_size(`y_size))
ON
(
.clk(clk),
.rstn(rst),
.r_valid_pe(r_valid_pe),
.r_data_pe(r_data_pe),
.r_ready_pe(r_ready_pe),
.w_valid_pe(w_valid_pe),
.w_data_pe(w_data_pe)
);

randomPeTop #(.X(`X),.Y(`Y),.data_width(`data_width), .x_size(`x_size),.y_size(`y_size),.numPackets(`numPackets),.rate(`injectRate)) 
rPeT(
.clk(clk),
.rstn(rst),
//PE interfaces
.r_valid_pe(r_valid_pe),
.r_data_pe(r_data_pe),
.r_ready_pe(r_ready_pe),
.w_valid_pe(w_valid_pe),
.w_data_pe(w_data_pe),
.done(done),
.start(start),
.enableSend(enableSend)
);

wire noReadOp;
wire noWriteOp;

assign noReadOp = ~(|r_valid_pe);
assign noWriteOp = ~(|w_valid_pe);

initial
begin
    wait(!done);
	wait(done & noReadOp & noWriteOp);
	$display("Simulation finished at",,,,$time);
	$display("Max Throughput:\t %f packets/cycle",(`X*`Y*1.0/`injectRate));
	$display("Achieved Throughput:\t %f packets/cycle",(`numPackets*`X*`Y*1.0)/(($time-startTime)/`clkPeriod));
	$display("Efficiency:\t %f",((`numPackets*`X*`Y*100.0)/(($time-startTime)/`clkPeriod))/(`X*`Y*1.0/`injectRate));
	start = 0;
	#500;
	$stop;
end
 
 
endmodule

