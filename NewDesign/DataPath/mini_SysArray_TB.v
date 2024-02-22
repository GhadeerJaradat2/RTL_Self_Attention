`timescale 1ns/1ns
`define width 8

module mini_SysArray_TB();
//input 

reg clk,_reset,enable,intMul;
reg signed [`width-1:0] a00,a01,a02,a03;
reg signed [`width-1:0] a10,a11,a12,a13;
reg signed [`width-1:0] b1_00,b1_10,b1_20,b1_30;
reg signed [`width-1:0] b1_01,b1_11,b1_21,b1_31;
wire signed  [2*`width-1:0] result0 ,result1,result2,result3, importance;
wire  done;

//DUT
mini_SysArray DUT(clk,_reset,enable,intMul,a00,a01,a02,a03,a10,a11,a12,a13,b1_00,b1_10,b1_20,
					b1_30, b1_01,b1_11,b1_21,b1_31,result0 ,result1,result2,result3,importance,done);
					
initial begin
	clk=1'b0;
	forever begin
		#5 clk=~clk;
	end
end


initial begin
_reset <=0;
#5
_reset <=1;
intMul<=1;
enable<=1;
a00 <= 8'h01;
a01 <= 8'h00;
a02 <= 8'h01;
a03 <= 8'h00;

a10 <= 8'h00;
a11 <= 8'h00;
a12 <= 8'h00;
a13 <= 8'h00;

b1_00 <= 8'h01;
b1_10 <= 8'h01;
b1_20 <= 8'h01;
b1_30  <= 8'h01;

b1_01  <= 8'h01;
b1_11  <= 8'h01;
b1_21  <= 8'h01;
b1_31  <= 8'h01;
#100 _reset <= 0;
#5 _reset <= 1;

a00 <= 8'h01;
a01 <= 8'h00;
a02 <= 8'h01;
a03 <= 8'h00;

a10 <= 8'h01;
a11 <= 8'h01;
a12 <= 8'h01;
a13 <= 8'h01;

b1_00 <= 8'h01;
b1_10 <= 8'h01;
b1_20 <= 8'h01;
b1_30  <= 8'h01;

b1_01  <= 8'h01;
b1_11  <= 8'h01;
b1_21  <= 8'h01;
b1_31  <= 8'h01;
//#20 enable<=0;
end




endmodule
