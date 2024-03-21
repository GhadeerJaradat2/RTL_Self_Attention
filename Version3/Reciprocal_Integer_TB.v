
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 11:44:09 PM
// Design Name: 
// Module Name: test_rec
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Reciprocal_Integer_TB;

reg  [9:0] x;
wire  [17:0] y;
reg enb;

 




	Reciprocal_Integer uut(enb,x,y);
	
	
	
	
	
initial begin

		enb = 1'b0;
		x=0;
		#100;
		enb = 1'b1;
		x=2;   /// 2.5 *2^16
		
				#100;
		enb = 1'b1;
		x=10'd16; /// 12 *2^16
		
		
				#100;
		enb = 1'b1;
		x=33; /// 84 *2^16
		
				#100;
		enb = 1'b1;
		x=70; /// 84 *2^16
		
				#100;
		enb = 1'b1;
		x=73; /// 84 *2^16				
		
		end
endmodule
