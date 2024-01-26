`timescale 1ns/1ps
`define width 8
module Exponent_TB ();

reg clk,_reset;

reg signed [2*`width-1:0] number;
wire  [4*`width-1:0] result;



Exponent DUT(.clk(clk),._reset(_reset), .number(number),.result(result));

initial 
begin
	 clk=0;
	_reset=0;
	#5 _reset =1;
	number = 16'shff00;//-1
 	#10
	number = 16'h0a10;//10.0625
	#10
	number = 16'shf5f0;//-A10
	#10
	number = 16'h0100;
	#10
	number = 16'h7a23;
	#10
	number = 16'h14a4; 	
	#10
	number = 16'she162;
	
end


always
#1 clk=~clk;






endmodule
