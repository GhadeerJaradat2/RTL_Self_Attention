
/*
This function to add the multiplication results of the Q*k arrays,
it takes as an inpput the following 
1- MulFractionsFlag , MulValueFlag
in case of MulFractionsFlag:
	a- INT result(Q_INT*K_int)
	b- Frac1 result (Q_int*K_Frac)
	c- Frac2 result (Q_Frac*K_INt)
in case of MulValueFlag:
	a- Frac1 result (first 8 values are integer results [results of attention_prob*Value] and last 8 values are Frac1 part
	b- Frac2 result (first 8 values are Frac2 part and last 8 values are Frac3 part
clk,_rest
enable to eneable the addition or not
 

*/
module Adder #(parameter width=8)(
	
	input clk,_reset,
	input enable,
	input MulFractionsFlag,
	input MulValueFlag,
	input signed [2*width-1:0] Int0,Int1 ,Int2 ,Int3,
	input signed [2*width-1:0] Int4,Int5 ,Int6 ,Int7,
	input signed [2*width-1:0] Int8,Int9 ,Int10 ,Int11,
	input signed [2*width-1:0] Int12,Int13 ,Int14 ,Int15,
	
	
	
	input signed [2*width-1:0] Frac1_0,Frac1_1 ,Frac1_2 ,Frac1_3,
	input signed [2*width-1:0] Frac1_4,Frac1_5 ,Frac1_6 ,Frac1_7 ,
	input signed [2*width-1:0] Frac1_8,Frac1_9 ,Frac1_10 ,Frac1_11,
	input signed [2*width-1:0] Frac1_12,Frac1_13 ,Frac1_14 ,Frac1_15 ,
	
	input signed [2*width-1:0] Frac2_0,Frac2_1 ,Frac2_2 ,Frac2_3,
	input signed [2*width-1:0] Frac2_4,Frac2_5 ,Frac2_6 ,Frac2_7 ,
	input signed [2*width-1:0] Frac2_8,Frac2_9 ,Frac2_10 ,Frac2_11,
	input signed [2*width-1:0] Frac2_12,Frac2_13 ,Frac2_14 ,Frac2_15 ,

	
	output reg signed [3*width-1:0] TotalRes_0, TotalRes_1 , TotalRes_2 ,TotalRes_3 ,
	output reg signed [3*width-1:0] TotalRes_4, TotalRes_5 , TotalRes_6 ,TotalRes_7 ,
	output reg signed [3*width-1:0] TotalRes_8, TotalRes_9 , TotalRes_10 ,TotalRes_11 ,
	output reg signed [3*width-1:0] TotalRes_12, TotalRes_13 , TotalRes_14 ,TotalRes_15	

	
	);
reg [4*width-1:0] temp;
always@(posedge clk or negedge _reset)
	
begin
	if(!_reset) 
	begin
		
			TotalRes_0 <=0 ;
			TotalRes_1 <=0 ;
			TotalRes_2 <=0 ;
			TotalRes_3 <=0;
			TotalRes_4 <=0 ;
			TotalRes_5 <=0 ;
			TotalRes_6 <=0 ;
			TotalRes_7 <=0 ;
			TotalRes_8 <=0 ;
			TotalRes_9 <=0 ;
			TotalRes_10 <=0 ;
			TotalRes_11 <=0;
			TotalRes_12 <=0 ;
			TotalRes_13 <=0 ;
			TotalRes_14 <=0 ;
			TotalRes_15 <=0 ;
				
	end
	else
	begin
		if(enable)
		begin
			if(MulFractionsFlag)
			begin
						
						TotalRes_0<=(Int0<<<8) + Frac1_0 + Frac2_0;
						TotalRes_1<=(Int1<<<8) + Frac1_1 + Frac2_1;
						TotalRes_2<=(Int2<<<8) + Frac1_2 + Frac2_2;
						TotalRes_3<=(Int3<<<8) + Frac1_3 + Frac2_3;
						TotalRes_4<=(Int4<<<8) + Frac1_4 + Frac2_4;
						TotalRes_5<=(Int5<<<8) + Frac1_5 + Frac2_5;
						TotalRes_6<=(Int6<<<8) + Frac1_6 + Frac2_6;
						TotalRes_7<=(Int7<<<8) + Frac1_7 + Frac2_7;
						TotalRes_8<=(Int8<<<8) + Frac1_8 + Frac2_8;
						TotalRes_9<=(Int9<<<8) + Frac1_9 + Frac2_9;
						TotalRes_10<=(Int10<<<8) + Frac1_10 + Frac2_10;
						TotalRes_11<=(Int11<<<8) + Frac1_11 + Frac2_11;
						TotalRes_12<=(Int12<<<8) + Frac1_12 + Frac2_12;
						TotalRes_13<=(Int13<<<8) + Frac1_13 + Frac2_13;
						TotalRes_14<=(Int14<<<8) + Frac1_14 + Frac2_14;
						TotalRes_15<=(Int15<<<8) + Frac1_15 + Frac2_15;
					
						
			end
			else if (MulValueFlag)
			begin
						//Frac1_0 to Frac1_7 : represents the integer part.
						//Frac1_8 to Frac1_15:represents the Frac1 part.
						//Frac2_0 to Frac2_7 : represents the Frac2 part.
						//Frac2_8 to Frac2_15:represents the Frac3 part.
						TotalRes_0 <= ((Frac1_0<<<16) + ((Frac1_8 + Frac2_0)<<<8) + Frac2_8 )>>>8;
						TotalRes_1 <= ((Frac1_1<<<16) + ((Frac1_9 + Frac2_1)<<<8) + Frac2_9 )>>>8;
						TotalRes_2 <= ((Frac1_2<<<16) + ((Frac1_10 + Frac2_2)<<<8) + Frac2_10 )>>>8;
						TotalRes_3 <= ((Frac1_3<<<16) + ((Frac1_11 + Frac2_3)<<<8) + Frac2_11 )>>>8;
						TotalRes_4 <= ((Frac1_4<<<16) + ((Frac1_12 + Frac2_4)<<<8) + Frac2_12 )>>>8 ;
						TotalRes_5 <= ((Frac1_5<<<16) + ((Frac1_13 + Frac2_5)<<<8) + Frac2_13 )>>>8 ;
						TotalRes_6 <= ((Frac1_6<<<16) + ((Frac1_14 + Frac2_6)<<<8) + Frac2_14 )>>>8;
						TotalRes_7 <= ((Frac1_7<<<16) + ((Frac1_15 + Frac2_7)<<<8) + Frac2_15 )>>>8;
						/////////////////////////////////////////////////////////////
						TotalRes_8 <= 0;
						TotalRes_9 <= 0;
						TotalRes_10 <= 0;
						TotalRes_11 <= 0;
						TotalRes_12 <= 0;
						TotalRes_13 <= 0;
						TotalRes_14 <= 0;
						TotalRes_15 <= 0;
						
						
						
						
			end
		end

	end

end
	
endmodule