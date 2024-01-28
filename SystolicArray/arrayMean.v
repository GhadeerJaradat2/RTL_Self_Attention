/*
This code is to find the absolute summation of the Q*K matrix, and determines if this head will be pruned or not.
it will reveive the sub results, the sub results are in most cases 32 results.
the summation is for the absolute values.

*/
module arrayMean #(parameter width=8)(
	input enable,//to add elements
	input comapre_flag,//indicate that int*int matrices ended, to comape with threshold
	input signed [2*width-1:0] result1_INT_00,result1_INT_01 ,result1_INT_02 ,result1_INT_03,
	input signed [2*width-1:0] result1_INT_10,result1_INT_11 ,result1_INT_12 ,result1_INT_13,
	input signed [2*width-1:0] result1_INT_20,result1_INT_21 ,result1_INT_22 ,result1_INT_23,
	input signed [2*width-1:0] result1_INT_30,result1_INT_31 ,result1_INT_32 ,result1_INT_33,
	
	input signed [2*width-1:0] result2_INT_00,result2_INT_01 ,result2_INT_02 ,result2_INT_03,
	input signed [2*width-1:0] result2_INT_10,result2_INT_11 ,result2_INT_12 ,result2_INT_13,
	input signed [2*width-1:0] result2_INT_20,result2_INT_21 ,result2_INT_22 ,result2_INT_23,
	input signed [2*width-1:0] result2_INT_30,result2_INT_31 ,result2_INT_32 ,result2_INT_33 ,
	input clk,_reset,
		
	output  PruneHead
	);
	
		//define reg
	reg  [2*width-1:0] intermediateRes=0;
	
	reg  [2*width-1:0] result1_abs_INT_00 =0,result1_abs_INT_01=0 ,result1_abs_INT_02=0 ,result1_abs_INT_03=0;
	reg  [2*width-1:0] result1_abs_INT_10=0,result1_abs_INT_11=0 ,result1_abs_INT_12 =0,result1_abs_INT_13=0;
	reg  [2*width-1:0] result1_abs_INT_20=0,result1_abs_INT_21=0 ,result1_abs_INT_22 =0,result1_abs_INT_23=0;
	reg  [2*width-1:0] result1_abs_INT_30=0,result1_abs_INT_31=0 ,result1_abs_INT_32=0 ,result1_abs_INT_33=0;

	reg  [2*width-1:0] result2_abs_INT_00=0,result2_abs_INT_01=0 ,result2_abs_INT_02=0 ,result2_abs_INT_03=0;
	reg  [2*width-1:0] result2_abs_INT_10=0,result2_abs_INT_11=0 ,result2_abs_INT_12=0 ,result2_abs_INT_13=0;
	reg  [2*width-1:0] result2_abs_INT_20=0,result2_abs_INT_21=0 ,result2_abs_INT_22=0 ,result2_abs_INT_23=0;
	reg  [2*width-1:0] result2_abs_INT_30=0,result2_abs_INT_31=0 ,result2_abs_INT_32=0 ,result2_abs_INT_33=0;	

	wire[7:0] threshold = 220;
	reg headPruneReset=0;
	reg headFlag=0;
	assign PruneHead = headPruneReset &  headFlag;
	always@(posedge clk or negedge _reset)
	
	begin
		if(!_reset) 
		begin
		
			intermediateRes <= 0;
			headPruneReset<=0;
			
		end
		else
		begin
			headPruneReset<=1;
			if(enable)
			begin
			
			result1_abs_INT_00 <= result1_INT_00[2*width-1] ? -result1_INT_00 : result1_INT_00; // absolute
			result1_abs_INT_01 <= result1_INT_01[2*width-1] ? -result1_INT_01 : result1_INT_01; // absolute
			result1_abs_INT_02 <= result1_INT_02[2*width-1] ? -result1_INT_02 : result1_INT_02; // absolute
			result1_abs_INT_03 <= result1_INT_03[2*width-1] ? -result1_INT_03 : result1_INT_03; // absolute
			result1_abs_INT_10 <= result1_INT_10[2*width-1] ? -result1_INT_10 : result1_INT_10; // absolute
			result1_abs_INT_11 <= result1_INT_11[2*width-1] ? -result1_INT_11 : result1_INT_11; // absolute
			result1_abs_INT_12 <= result1_INT_12[2*width-1] ? -result1_INT_12 : result1_INT_12; // absolute
			result1_abs_INT_13 <= result1_INT_13[2*width-1] ? -result1_INT_13 : result1_INT_13; // absolute
			result1_abs_INT_20 <= result1_INT_20[2*width-1] ? -result1_INT_20 : result1_INT_20; // absolute
			result1_abs_INT_21 <= result1_INT_21[2*width-1] ? -result1_INT_21 : result1_INT_21; // absolute
			result1_abs_INT_22 <= result1_INT_22[2*width-1] ? -result1_INT_22 : result1_INT_22; // absolute
			result1_abs_INT_23 <= result1_INT_23[2*width-1] ? -result1_INT_23 : result1_INT_23; // absolute
			result1_abs_INT_30 <= result1_INT_30[2*width-1] ? -result1_INT_30 : result1_INT_30; // absolute
			result1_abs_INT_31 <= result1_INT_31[2*width-1] ? -result1_INT_31 : result1_INT_31; // absolute
			result1_abs_INT_32 <= result1_INT_32[2*width-1] ? -result1_INT_32 : result1_INT_32; // absolute
			result1_abs_INT_33 <= result1_INT_33[2*width-1] ? -result1_INT_33 : result1_INT_33; // absolute
			
			result2_abs_INT_00 <= result2_INT_00[2*width-1] ? -result2_INT_00 : result2_INT_00; // absolute
			result2_abs_INT_01 <= result2_INT_01[2*width-1] ? -result2_INT_01 : result2_INT_01; // absolute
			result2_abs_INT_02 <= result2_INT_02[2*width-1] ? -result2_INT_02 : result2_INT_02; // absolute
			result2_abs_INT_03 <= result2_INT_03[2*width-1] ? -result2_INT_03 : result2_INT_03; // absolute
			result2_abs_INT_10 <= result2_INT_10[2*width-1] ? -result2_INT_10 : result2_INT_10; // absolute
			result2_abs_INT_11 <= result2_INT_11[2*width-1] ? -result2_INT_11 : result2_INT_11; // absolute
			result2_abs_INT_12 <= result2_INT_12[2*width-1] ? -result2_INT_12 : result2_INT_12; // absolute
			result2_abs_INT_13 <= result2_INT_13[2*width-1] ? -result2_INT_13 : result2_INT_13; // absolute
			result2_abs_INT_20 <= result2_INT_20[2*width-1] ? -result2_INT_20 : result2_INT_20; // absolute
			result2_abs_INT_21 <= result2_INT_21[2*width-1] ? -result2_INT_21 : result2_INT_21; // absolute
			result2_abs_INT_22 <= result2_INT_22[2*width-1] ? -result2_INT_22 : result2_INT_22; // absolute
			result2_abs_INT_23 <= result2_INT_23[2*width-1] ? -result2_INT_23 : result2_INT_23; // absolute
			result2_abs_INT_30 <= result2_INT_30[2*width-1] ? -result2_INT_30 : result2_INT_30; // absolute
			result2_abs_INT_31 <= result2_INT_31[2*width-1] ? -result2_INT_31 : result2_INT_31; // absolute
			result2_abs_INT_32 <= result2_INT_32[2*width-1] ? -result2_INT_32 : result2_INT_32; // absolute
			result2_abs_INT_33 <= result2_INT_33[2*width-1] ? -result2_INT_33 : result2_INT_33; // absolute
		
			end
			
		end
	end
always @(result1_abs_INT_00 , result1_abs_INT_01 , result1_abs_INT_02 , result1_abs_INT_03 ,
						  result1_abs_INT_10 , result1_abs_INT_11 , result1_abs_INT_12 , result1_abs_INT_13 ,
						  result1_abs_INT_20 , result1_abs_INT_21 , result1_abs_INT_22 , result1_abs_INT_23 ,
						  result1_abs_INT_30 , result1_abs_INT_31 , result1_abs_INT_32 , result1_abs_INT_33 ,
						  result2_abs_INT_00 , result2_abs_INT_01 , result2_abs_INT_02 , result2_abs_INT_03 ,
						  result2_abs_INT_10 , result2_abs_INT_11 , result2_abs_INT_12 , result2_abs_INT_13 ,
						  result2_abs_INT_20 , result2_abs_INT_21 , result2_abs_INT_22 , result2_abs_INT_23 ,
						  result2_abs_INT_30 , result2_abs_INT_31 , result2_abs_INT_32 , result2_abs_INT_33 )
	begin
	
		intermediateRes = intermediateRes+ result1_abs_INT_00 + result1_abs_INT_01 + result1_abs_INT_02 + result1_abs_INT_03 +
						  result1_abs_INT_10 + result1_abs_INT_11 + result1_abs_INT_12 + result1_abs_INT_13 +
						  result1_abs_INT_20 + result1_abs_INT_21 + result1_abs_INT_22 + result1_abs_INT_23 +
						  result1_abs_INT_30 + result1_abs_INT_31 + result1_abs_INT_32 + result1_abs_INT_33 +
						  result2_abs_INT_00 + result2_abs_INT_01 + result2_abs_INT_02 + result2_abs_INT_03 +
						  result2_abs_INT_10 + result2_abs_INT_11 + result2_abs_INT_12 + result2_abs_INT_13 +
						  result2_abs_INT_20 + result2_abs_INT_21 + result2_abs_INT_22 + result2_abs_INT_23 +
						  result2_abs_INT_30 + result2_abs_INT_31 + result2_abs_INT_32 + result2_abs_INT_33 ;
	
	if(comapre_flag)
	begin
		if (intermediateRes[2*width-1:width] <= threshold)
				headFlag = 1;
		else
				headFlag = 0;
		
		end
	
	end
	
endmodule
