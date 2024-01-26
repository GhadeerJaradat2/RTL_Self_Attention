`timescale 1ns/1ns

module PE_test;
//input
reg clk,reset,enable;
reg [7:0] a,b,c;
wire [7:0]  e,f,g;
wire [7:0] acc1,acc2;

PE DUT(clk,reset,enable,a,b,c,e,f,g,acc1,acc2);
		
		
initial begin
	reset=0;
	enable=1;
	
	#10 reset=1;
	a=8'h3d;
	b=8'h2a;
	c=8'h1f;
	#10 enable=0;
	a=8'h00;
	b=8'h0;
	c=8'h0;
	forever begin
		 #1 a=a+8'h03;
		 #1 b=b-8'h01;
		 #1 c=c+8'h01;
	end

end

initial begin
	clk=1'b0;
	forever begin
		#5 clk=~clk;
	end
end
endmodule
