`timescale 1ns/1ps
`define width 8
module Softmax_TB();
reg clk,_reset, endOfInputFlag;
reg signed[2*`width-1:0] Number;
wire [2*`width-1:0] softmaxResult;

SoftMax DUT (		clk, _reset,endOfInputFlag,
				Number,
				softmaxResult
		);
//z = [4.5, 1 ,-5.2, -1 , 3 ,7.2 , 5]
//res= [000E,0,0,0003,00D6,0017]
initial begin
	clk <= 0;
	_reset <= 0;
	#5 _reset <= 1;
	endOfInputFlag <= 0;
	#10 Number <= 16'h0480;
	#10 Number <= 16'h0100; 
	#10 Number <= 16'hFACD;
	#10 Number <= 16'hFF00;
	#10 Number <= 16'h0300; 
	#10 Number <= 16'h0733;
	#10 Number <= 16'h0500;
	#10 endOfInputFlag <= 1;


end

always
#1 clk=~clk;

endmodule