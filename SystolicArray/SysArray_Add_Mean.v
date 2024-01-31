module SysArray_ADD_Mean #(parameter width=8)(
	input AddFlag, // flag to indicate if an adition is placed or not
	input IntFlag, //flag to indicate if an integer addition will occure(one operand is integer)
	input clk,_reset,_flush_acc,
	
	input signed [width-1:0] a00,a01,a02,a03,
	input signed [width-1:0] a10,a11,a12,a13 ,
	input signed [width-1:0] a20,a21,a22,a23,
	input signed [width-1:0] a30,a31,a32,a33 ,//rows of the input matrix
	
	input signed [width-1:0] b1_00,b1_10,b1_20,b1_30 ,
	input signed [width-1:0] b1_01,b1_11,b1_21,b1_31 ,
	input signed [width-1:0] b1_02,b1_12,b1_22,b1_32 ,
	input signed [width-1:0] b1_03,b1_13,b1_23,b1_33  ,//cols of the input matrix
	
	input signed [width-1:0] b2_00,b2_10,b2_20,b2_30 ,
	input signed [width-1:0] b2_01,b2_11,b2_21,b2_31 ,
	input signed [width-1:0] b2_02,b2_12,b2_22,b2_32 ,
	input signed [width-1:0] b2_03,b2_13,b2_23,b2_33 ,//cols of the second input matrix
		
	
	//_reset_counter to reset the done and the counter
	//_flush_acc is to reset the old accumulaters of the PEs then perform this MM

	input signed [2*width-1:0] c1_00,c1_01,c1_02,c1_03,
	input signed [2*width-1:0] c1_10,c1_11,c1_12,c1_13 ,
	input signed [2*width-1:0] c1_20,c1_21,c1_22,c1_23,
	input signed [2*width-1:0] c1_30,c1_31,c1_32,c1_33 ,//rows of the input matrix C1
	
	input signed [2*width-1:0] c2_00,c2_01,c2_02,c2_03,
	input signed [2*width-1:0] c2_10,c2_11,c2_12,c2_13 ,
	input signed [2*width-1:0] c2_20,c2_21,c2_22,c2_23,
	input signed [2*width-1:0] c2_30,c2_31,c2_32,c2_33 ,//rows of the input matrix C2
	
	output  signed [2*width-1:0] result1_0 ,result1_1,result1_2,result1_3 ,
	output  signed [2*width-1:0] result1_4,result1_5,result1_6,result1_7,
	output  signed [2*width-1:0] result1_8,result1_9,result1_10,result1_11,
	output  signed [2*width-1:0] result1_12,result1_13,result1_14,result1_15,
	
	output  signed [2*width-1:0] result2_0 ,result2_1,result2_2,result2_3,
	output  signed [2*width-1:0] result2_4,result2_5,result2_6,result2_7,
	output  signed [2*width-1:0] result2_8,result2_9,result2_10,result2_11,
	output  signed [2*width-1:0] result2_12,result2_13,result2_14,result2_15,
	
	input enable,//to add elements
	input comapre_flag,//indicate that int*int matrices ended, to comape with threshold
	output reg   PruneHead
	);

SystolicArray_ADD DUT(	AddFlag,IntFlag,clk,_reset,_flush_acc,
						a00,a01,a02,a03,a10,a11,a12,a13,a20,a21,a22,a23,a30,a31,a32,a33,
						b1_00,b1_10,b1_20,b1_30,b1_01,b1_11,b1_21,b1_31,b1_02,b1_12,b1_22,b1_32,b1_03,b1_13,b1_23,b1_33,
						b2_00,b2_10,b2_20,b2_30,b2_01,b2_11,b2_21,b2_31,b2_02,b2_12,b2_22,b2_32,b2_03,b2_13,b2_23,b2_33,
						c1_00,c1_01,c1_02,c1_03,c1_10,c1_11,c1_12,c1_13,c1_20,c1_21,c1_22,c1_23,c1_30,c1_31,c1_32,c1_33,
						c2_00,c2_01,c2_02,c2_03,c2_10,c2_11,c2_12,c2_13,c2_20,c2_21,c2_22,c2_23,c2_30,c2_31,c2_32,c2_33,
						 
						 result1_0 ,result1_1,result1_2,result1_3,
						 result1_4,result1_5,result1_6,result1_7,
						 result1_8,result1_9,result1_10,result1_11,
						 result1_12,result1_13,result1_14,result1_15,
						 
						 result2_0 ,result2_1,result2_2,result2_3,
						 result2_4,result2_5,result2_6,result2_7,
						 result2_8,result2_9,result2_10,result2_11,
						 result2_12,result2_13,result2_14,result2_15
						);
						
arrayMean dut_mean( enable,
					comapre_flag,
					result1_0 ,result1_1,result1_2,result1_3,
					result1_4,result1_5,result1_6,result1_7,
					result1_8,result1_9,result1_10,result1_11,
					result1_12,result1_13,result1_14,result1_15,
	
					result2_0 ,result2_1,result2_2,result2_3,
					result2_4,result2_5,result2_6,result2_7,
					result2_8,result2_9,result2_10,result2_11,
					result2_12,result2_13,result2_14,result2_15,
					clk,_reset,
					headPrune					 
				   );
				   
endmodule
