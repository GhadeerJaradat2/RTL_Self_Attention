 module SoftMax #(parameter width=8, FRACTIONAL_BITS=8) (
				input clk, _reset,endOfInputFlag,
				input signed [2*width-1:0] Number,
				output reg [2*width-1:0] softmaxResult
				);
	localparam  w=2*width;
	localparam  Frac=2*FRACTIONAL_BITS;
	
	integer i=0,j=0;
	wire [4*width-1:0] reciprocal;
	reg [4*width-1:0] inputNumbers [0:63]; //Max number of input=64
	reg [4*width-1:0] sum=0;
	wire [4*width-1:0] 	result=0;
	reg [2*width-1:0] inputExponent;
	reg EnableDivflag=0;
	reg endDivFlag=0;
	
	Exponent DUT(.clk(clk),._reset(_reset), .number(inputExponent),.result(result));
	
	//This Division unit works with 32 bit, the result is also 32 bit, decimal point at index 16
	DivisionUnsigned #(w, Frac) uut (
	.flag(EnableDivflag),
	.A(32'h00010000),
	.B(sum),
	.Result(reciprocal)
	);
	
	always@(posedge clk or negedge _reset)
	begin
		if(!_reset)
		begin
			softmaxResult <= 0;
		end
		else
			if(!endOfInputFlag & !EnableDivflag &!endDivFlag)
			begin
				inputExponent <= Number;//>>>3;
			end
			else if(endOfInputFlag & !EnableDivflag &!endDivFlag)
			begin
				EnableDivflag <= 1;
				
			end
			else if (endOfInputFlag & EnableDivflag &!endDivFlag)
			begin
				EnableDivflag <= 0;
				endDivFlag <= 1;
			end
			else
			begin
				
					inputNumbers[j] <= (inputNumbers[j]*reciprocal)>>>16;
					j=j+1;
					softmaxResult <= inputNumbers[j];
			end
		
		
	end
	
	always@(result)
	begin
		sum = sum + result;
		inputNumbers[i] = result;
		i=i+1;
	end


endmodule
				
