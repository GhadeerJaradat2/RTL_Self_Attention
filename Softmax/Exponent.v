
module Exponent #(parameter width=8)
				(
				input clk, _reset,
				input signed[2*width-1:0] number, //16 bit [8 integers, 8 fractions]
				output reg   [4*width-1:0] result //32 bit
				);
				
//find the exponent using taylor series expansion up to 6 terms, 
// 1+x+x^2/2+x^3/6+x^4/12+x^5/120 
// 1/2= 0.5    1/4= 0.25  1/6= 0.1666666  1/12=0.083333  1/120=0.00833333 1/720=0.001388 
//0.5-->00000000.10000000
//0.25-->00000000.01000000
//0.1666-->00000000.00101010 (002A)h
//0.083333 -->00000000.00010101 (0015)h
//0.00833333 -->00000000.00000010  (0002)h
reg signed [4*width-1:0] square=0,square2=0; //32 bits, point at bit number 16
reg signed [6*width-1:0] cube=0,cube2=0 ; //48 bits, point at bit number   24
reg signed [8*width-1:0] fourth=0,fourth2=0; //64 bits, point at bit number  32
reg signed [10*width-1:0] fifth=0,fifth2=0; //80 bits, point at bit number  40
reg signed [10*width-1:0] sixth=0,sixth2=0 ; //80 bits, point at bit number  40
reg signed [10*width-1:0] sum=0; //80 bits
always @(posedge clk or negedge _reset)
begin
	if(!_reset)
		result<='b0;
	else
	begin
	square <= (number * number)>>>1 ;// 32 bits, 16 bit after the point. shifted by 1 to represent (/2)
	cube <= number * number * number;
	
	fourth <= number * number * number * number;
	
	fifth <= (number * number * number * number * number);
	sixth <= (number * number * number * number * number * number)>>>8;//remove least 8 bits, and assign rsulting 88 bits into 80(removing 8 MS Bits)
	
	end

end

always @(square,cube,fourth,fifth,number,sixth)
begin
	cube2=(cube*16'sb00000000_00101010)>>>8;
	fourth2=(fourth* 16'sb00000000_00010101)>>>8;
	fifth2=(fifth*16'sb00000000_00000010)>>>8;
	sixth2=(sixth*16'sb00000000_00101010* 16'sb00000000_00000010)>>>16;
	
	sum =(number<<<32)+(square<<<24)+(cube2<<<16)+(fourth2<<<8)+fifth2+sixth2+80'sh0000000001_0000000000;
	result=sum>>>24;
end

endmodule
	
