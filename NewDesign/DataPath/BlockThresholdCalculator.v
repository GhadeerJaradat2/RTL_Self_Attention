module BlockThresholdCalculator #(parameter width=8, FRACTIONAL_BITS=8)(
	input enable,
	input [2*width-1:0] noOfTiles,
	input [2*width-1:0] min0,max0,sum0,
	input [2*width-1:0] min1,max1,sum1,
	input [2:0] blockPruningRatio, 
	output reg [2*width-1:0] threshold0, threshold1


	);
//for simplicity now i only take 0,.25,.5,.75,100
/*
0-->0%
1-->25%
2-->50%
3-->75%
4-->100%
*/
wire [2*width-1:0] reciprocal;
wire [2*width-1:0] A=1;
DivisionUnsigned #(width, FRACTIONAL_BITS) div (
	.flag(enable),
	.A(A),
	.B(noOfTiles),
	.Result(reciprocal)
);
reg [2*width-1:0] mean0, mean1;
always @(reciprocal)

begin
	if(enable)
	begin
		mean0 = reciprocal * sum0;
		mean1 = reciprocal * sum1;
		case(blockPruningRatio)
		3'b000://0% pruning
		begin
			threshold0 = min0;
			threshold1 = min1;
			
		end
		3'b001://25% pruning
		begin
			threshold0 = (min0 + mean0[2*width-1:width]) >>1;
			threshold1 = (min1 + mean1[2*width-1:width]) >>1;
			
		end
		3'b010://50% pruning
		begin
			threshold0 = mean0[2*width-1:width];
			threshold1 = mean1[2*width-1:width];
			
		end
		3'b011://75% pruning
		begin
			threshold0 = (max0 + mean0[2*width-1:width]) >>1;
			threshold1 = (max1 + mean1[2*width-1:width]) >>1;
			
			
		end
		3'b100://100% pruning
		begin
			threshold0 = max0;
			threshold1 = max1;
			
		end
		
		endcase
	end
end

endmodule