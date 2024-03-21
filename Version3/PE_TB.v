
`timescale 1ns/1ns
`define width 8
module PE_test;
//input
reg clk,reset,enable;
reg [`width-1:0] a,b,c;
wire [`width-1:0]  e,f,g;
wire [2*`width-1:0] acc1,acc2;

PE DUT(clk,reset,enable,a,b,c,e,f,g,acc1,acc2);
		
		
initial begin 
	reset=0;
	enable=1;
	
	#10 reset=1;
	a=8'h01;
	b=8'h01;
	c=8'h01;
	#10 enable=0;
	a=8'h01;
	b=8'h01;
	c=8'h01;
	#10 enable=1;

	forever begin
		  a=a+8'h01;
		  b=b-8'h01;
		  c=c+8'h02;
		  #8;
	end

end

initial begin
	clk=1'b0;
	forever begin
		#5 clk=~clk;
	end
end
endmodule
