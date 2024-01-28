/*
This function to add the multiplication results of the Q*k arrays,
it takes as an inpput 2 out of the following three
1- INT result(Q_INT*K_int)
2- Frac1 result (Q_int*K_Frac)
3- Frac2 result (Q_Frac*K_INt)
clk,_rest
enable to eneable the addition or not
IntFlag, if =1, to indicate if the second operand is integer only or [int.fraction]
and returns the summation of the 2  

*/
module Adder #(parameter width=8)(
	input enable,
	input clk,_reset,
	input IntFlag,
	
	input signed [2*width-1:0] input2_00,input2_01 ,input2_02 ,input2_03,
	input signed [2*width-1:0] input2_10,input2_11 ,input2_12 ,input2_13,
	input signed [2*width-1:0] input2_20,input2_21 ,input2_22 ,input2_23,
	input signed [2*width-1:0] input2_30,input2_31 ,input2_32 ,input2_33 ,
	
	input signed [2*width-1:0] input1_00,input1_01 ,input1_02 ,input1_03,
	input signed [2*width-1:0] input1_10,input1_11 ,input1_12 ,input1_13,
	input signed [2*width-1:0] input1_20,input1_21 ,input1_22 ,input1_23,
	input signed [2*width-1:0] input1_30,input1_31 ,input1_32 ,input1_33 ,
	
	output reg signed [2*width-1:0] TotalRes_00, TotalRes_01 , TotalRes_02 ,TotalRes_03 ,
	output reg signed [2*width-1:0] TotalRes_10, TotalRes_11 , TotalRes_12 ,TotalRes_13 ,
	output reg signed [2*width-1:0] TotalRes_20, TotalRes_21 , TotalRes_22 ,TotalRes_23 ,
	output reg signed [2*width-1:0] TotalRes_30, TotalRes_31 , TotalRes_32 ,TotalRes_33 
	
	);

	always@(posedge clk or negedge _reset)
	
	begin
		if(!_reset) 
		begin
			
				TotalRes_00<=0;
				TotalRes_01<=0;
				TotalRes_02<=0;
				TotalRes_03<=0;
				TotalRes_10<=0;
				TotalRes_11<=0;
				TotalRes_12<=0;
				TotalRes_13<=0;
				TotalRes_20<=0;
				TotalRes_21<=0;
				TotalRes_22<=0;
				TotalRes_23<=0;
				TotalRes_30<=0;
				TotalRes_31<=0;
				TotalRes_32<=0;
				TotalRes_33<=0;
					
		end
		
		else
		begin
			if(enable)
			begin
				if (IntFlag)
				begin
						TotalRes_00<=(input1_00<<<8)+input2_00;
						TotalRes_01<=(input1_01<<<8)+input2_01;
						TotalRes_02<=(input1_02<<<8)+input2_02;
						TotalRes_03<=(input1_03<<<8)+input2_03;
						TotalRes_10<=(input1_10<<<8)+input2_10;
						TotalRes_11<=(input1_11<<<8)+input2_11;
						TotalRes_12<=(input1_12<<<8)+input2_12;
						TotalRes_13<=(input1_13<<<8)+input2_13;
						TotalRes_20<=(input1_20<<<8)+input2_20;
						TotalRes_21<=(input1_21<<<8)+input2_21;
						TotalRes_22<=(input1_22<<<8)+input2_22;
						TotalRes_23<=(input1_23<<<8)+input2_23;
						TotalRes_30<=(input1_30<<<8)+input2_30;
						TotalRes_31<=(input1_31<<<8)+input2_31;
						TotalRes_32<=(input1_32<<<8)+input2_32;
						TotalRes_33<=(input1_33<<<8)+input2_33;
				end
				else
				begin
						TotalRes_00<=(input1_00)+input2_00;
						TotalRes_01<=(input1_01)+input2_01;
						TotalRes_02<=(input1_02)+input2_02;
						TotalRes_03<=(input1_03)+input2_03;
						TotalRes_10<=(input1_10)+input2_10;
						TotalRes_11<=(input1_11)+input2_11;
						TotalRes_12<=(input1_12)+input2_12;
						TotalRes_13<=(input1_13)+input2_13;
						TotalRes_20<=(input1_20)+input2_20;
						TotalRes_21<=(input1_21)+input2_21;
						TotalRes_22<=(input1_22)+input2_22;
						TotalRes_23<=(input1_23)+input2_23;
						TotalRes_30<=(input1_30)+input2_30;
						TotalRes_31<=(input1_31)+input2_31;
						TotalRes_32<=(input1_32)+input2_32;
						TotalRes_33<=(input1_33)+input2_33;
				end
				
				
			
			end
			else
			begin

				TotalRes_00 <= input2_00;
				TotalRes_01 <= input2_01;
				TotalRes_02 <= input2_02;
				TotalRes_03 <= input2_03;
				TotalRes_10 <= input2_10;
				TotalRes_11 <= input2_11;
				TotalRes_12 <= input2_12;
				TotalRes_13 <= input2_13;
				TotalRes_20 <= input2_20;
				TotalRes_21 <= input2_21;
				TotalRes_22 <= input2_22;
				TotalRes_23 <= input2_23;
				TotalRes_30 <= input2_30;
				TotalRes_31 <= input2_31;
				TotalRes_32 <= input2_32;
				TotalRes_33 <= input2_33;
			end
		end
	
	
	
	end
	
endmodule
