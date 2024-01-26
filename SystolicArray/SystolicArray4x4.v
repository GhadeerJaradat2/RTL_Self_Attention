/*
--------------------------------------------------
A is the row matrix
B1,B1 are column matricies
clk
_reset_counter is to reset this matrix multiplier
_flush_acc if 1, the result of this multiplication is added to previous result
Result1, Result2 are the results matrices
done, =1 for one clock cycle if the multiplication is done.
--------------------------------------------------
*/
module SystolicArray4x4 #(parameter width=8)(
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
		
	input clk,_reset_counter,_flush_acc,
	//_reset_counter to reset the done and the counter
	//_flush_acc is to reset the old accumulaters of the PEs then perform this MM
	
	/*output reg [3:0] result1_0 ,result1_4,result1_8,result1_12 [2*width-1:0];
	output reg  [3:0] result2_0 ,result2_4,result2_8,result2_12 [2*width-1:0] ;
	*/
	output signed  [2*width-1:0] result0 ,result1,result2,result3 ,
	output signed [2*width-1:0] result4,result5,result6,result7,
	output signed [2*width-1:0] result8,result9,result10,result11,
	output signed [2*width-1:0] result12,result13,result14,result15,
	
	output signed [2*width-1:0] result2_0 ,result2_1,result2_2,result2_3,
	output signed [2*width-1:0] result2_4,result2_5,result2_6,result2_7,
	output signed [2*width-1:0] result2_8,result2_9,result2_10,result2_11,
	output signed [2*width-1:0] result2_12,result2_13,result2_14,result2_15, 
	
	output reg done //done =1 iff the systolicArray finishes
	);

	
	



	reg signed [width-1:0] inp_north0, inp_north1, inp_north2, inp_north3;
	reg signed [width-1:0] inp2_north0, inp2_north1, inp2_north2, inp2_north3;
	
	reg signed [width-1:0] inp_west0, inp_west4, inp_west8, inp_west12;
	

	
	
	wire signed [width-1:0] outp_south0, outp_south1, outp_south2, outp_south3, outp_south4, outp_south5, outp_south6, outp_south7, outp_south8, outp_south9, outp_south10, outp_south11, outp_south12, outp_south13, outp_south14, outp_south15;
	wire signed [width-1:0] outp2_south0, outp2_south1, outp2_south2, outp2_south3, outp2_south4, outp2_south5, outp2_south6, outp2_south7, outp2_south8, outp2_south9, outp2_south10, outp2_south11, outp2_south12, outp2_south13, outp2_south14, outp2_south15;
	
	reg enable0 =0, enable1=0, enable2=0, enable3=0, enable4=0, enable5=0, enable6=0, enable7=0, enable8=0, enable9=0, enable10=0, enable11=0, enable12=0, enable13=0, enable14=0, enable15=0;
	
	wire signed [width-1:0] outp_east0, outp_east1, outp_east2, outp_east3, outp_east4, outp_east5, outp_east6, outp_east7, outp_east8, outp_east9, outp_east10, outp_east11, outp_east12, outp_east13, outp_east14, outp_east15;
	/* wire [2*width-1:0] result0, result1, result2, result3, result4, result5, result6, result7, result8, result9, result10, result11, result12, result13, result14, result15;
	wire [2*width-1:0] result2_0, result2_1, result2_2, result2_3, result2_4, result2_5, result2_6, result2_7, result2_8, result2_9, result2_10, result2_11, result2_12, result2_13, result2_14, result2_15;

 */

	reg _PE_reset;// if 0, reset the PE
	reg [3:0] count = 4'b0000;
	
////instantiate the systolic array structure
//////////////////////First Row instantiation////////////////////
PE DUT0(clk,_PE_reset,enable0,inp_west0,inp_north0,inp2_north0,outp_south0,outp2_south0,outp_east0,result0, result2_0);
PE DUT1(clk,_PE_reset,enable1,outp_east0,inp_north1,inp2_north1,outp_south1,outp2_south1,outp_east1,result1, result2_1);
PE DUT2(clk,_PE_reset,enable2,outp_east1,inp_north2,inp2_north2,outp_south2,outp2_south2,outp_east2,result2, result2_2);
PE DUT3(clk,_PE_reset,enable3,outp_east2,inp_north3,inp2_north3,outp_south3,outp2_south3,outp_east3,result3, result2_3);
//////////////////////Second Row instantiation////////////////////
PE DUT4(clk,_PE_reset,enable4,inp_west4,outp_south0,outp2_south0,outp_south4,outp2_south4,outp_east4,result4, result2_4);
PE DUT5(clk,_PE_reset,enable5,outp_east4,outp_south1,outp2_south1,outp_south5,outp2_south5,outp_east5,result5, result2_5);
PE DUT6(clk,_PE_reset,enable6,outp_east5,outp_south2,outp2_south2,outp_south6,outp2_south6,outp_east6,result6, result2_6);
PE DUT7(clk,_PE_reset,enable7,outp_east6,outp_south3,outp2_south3,outp_south7,outp2_south7,outp_east7,result7, result2_7);
//////////////////////Third Row instantiation///////////////////
PE DUT8(clk,_PE_reset,enable8,inp_west8,outp_south4,outp2_south4,outp_south8,outp2_south8,outp_east8,result8, result2_8);
PE DUT9(clk,_PE_reset,enable9,outp_east8,outp_south5,outp2_south5,outp_south9,outp2_south9,outp_east9,result9, result2_9);
PE DUT10(clk,_PE_reset,enable10,outp_east9,outp_south6,outp2_south6,outp_south10,outp2_south10,outp_east10,result10, result2_10);
PE DUT11(clk,_PE_reset,enable11,outp_east10,outp_south7,outp2_south7,outp_south11,outp2_south11,outp_east11,result11, result2_11);
//////////////////////Fourth Row instantiation///////////////////
PE DUT12(clk,_PE_reset,enable12,inp_west12,outp_south8,outp2_south8,outp_south12,outp2_south12,outp_east12,result12, result2_12);
PE DUT13(clk,_PE_reset,enable13,outp_east12,outp_south9,outp2_south9,outp_south13,outp2_south13,outp_east13,result13, result2_13);
PE DUT14(clk,_PE_reset,enable14,outp_east13,outp_south10,outp2_south10,outp_south14,outp2_south14,outp_east14,result14, result2_14);
PE DUT15(clk,_PE_reset,enable15,outp_east14,outp_south11,outp2_south11,outp_south15,outp2_south15,outp_east15,result15, result2_15);

///////////////////////////////////////////////

always @(posedge clk or negedge _reset_counter or negedge _flush_acc)
begin
	done<=0;
	if(!_reset_counter) 
	begin
		
		count<= 0;
		done<=0;
		_PE_reset<=1;
		
	end
	else if (!_flush_acc)
	begin
		_PE_reset <= 0;
		done <= 0;
		count<=0;
	end
	else 
	begin
		_PE_reset<=1;
		if(count==10)
		begin
			done<=1;
			count<=0;
		end
		else
		begin
			done <= 0;
			count <= count + 1;
		end
	end
	
end
	
always @(count) 

begin
	
	case(count)
/* 		4'h0:
		begin
			enable0 = 0;
			enable1 = 0;
			enable2 = 0;
			enable3 = 0;
			enable4 = 0;
			enable5 = 0;
			enable6 = 0;
			enable7 = 0;
			enable8 = 0;
			enable9 = 0;
			enable10 = 0;
			enable11 =0;
			enable12 = 0;
			enable13 = 0;
			enable14 = 0;
			enable15 =1;
			//-------------------------
			inp_west0 = 'b0;
			inp_west4 = 'b0;
			inp_west8 = 'b0;
			inp_west12 = 'b0;
			//--------------------------------
			inp_north0 = 'b0;
			inp2_north0 = 'b0; 
			inp_north1 = 'b0; 
			inp2_north1 = 'b0; 
			
			inp_north2 = 'b0;
			inp2_north2 = 'b0;
			inp_north3 = 'b0;
			inp2_north3 = 'b0; */
		//end
		4'b0001:
		begin
			enable0 = 1;
			enable1 = 0;
			enable2 = 0;
			enable3 = 0;
			enable4 = 0;
			enable5 = 0;
			enable6 = 0;
			enable7 = 0;
			enable8 = 0;
			enable9 = 0;
			enable10 = 0;
			enable11 =0;
			enable12 = 0;
			enable13 = 0;
			enable14 = 0;
			enable15 =0;
			
			inp_west0 = a00;
			//-------------------------
			inp_north0 = b1_00;
			inp2_north0 = b2_00;
		end
		4'b0010:
		begin
		
			enable0 = 1;
			enable1 = 1;
			enable2 = 0;
			enable3 = 0;
			enable4 = 1;
			enable5 = 0;
			enable6 = 0;
			enable7 = 0;
			enable8 = 0;
			enable9 = 0;
			enable10 = 0;
			enable11 =0;
			enable12 = 0;
			enable13 = 0;
			enable14 = 0;
			enable15 =0;
			
			//-------------------------------------
			inp_west0 = a01;
			inp_west4 = a10;
			//---------------------------
			inp_north0 = b1_10;
			inp2_north0 = b2_10;
			
			inp_north1 = b1_01;
			inp2_north1 = b2_01;
			
		end
		4'b0011:
		begin
		
			enable0 = 1;
			enable1 = 1;
			enable2 = 1;
			enable3 = 0;
			enable4 = 1;
			enable5 = 1;
			enable6 = 0;
			enable7 = 0;
			enable8 = 1;
			enable9 = 0;
			enable10 = 0;
			enable11 =0;
			enable12 = 0;
			enable13 = 0;
			enable14 = 0;
			enable15 =0;
		
			inp_west0 = a02;
			inp_west4 = a11;
			inp_west8 = a20;
			//----------------------------------
			inp_north0 = b1_20;
			inp2_north0 = b2_20;
			
			inp_north1 = b1_11;
			inp2_north1 = b2_11;
			
			inp_north2 = b1_02;
			inp2_north2 = b2_02;
			
		end
		4'b0100:
		begin
			
			enable0 = 1;
			enable1 = 1;
			enable2 = 1;
			enable3 = 1;
			enable4 = 1;
			enable5 = 1;
			enable6 = 1;
			enable7 = 0;
			enable8 = 1;
			enable9 = 1;
			enable10 = 0;
			enable11 =0;
			enable12 = 1;
			enable13 = 0;
			enable14 = 0;
			enable15 =0;
			
		
			//-----------------------------------
			inp_west0 = a03;
			inp_west4 = a12;
			inp_west8 = a21;
			inp_west12 = a30;
			//-----------------------------------
			inp_north0 = b1_30;
			inp2_north0 = b2_30;
			
			inp_north1 = b1_21;
			inp2_north1 = b2_21;
			
			inp_north2 = b1_12;
			inp2_north2 = b2_12;
			
			inp_north3 = b1_03;
			inp2_north3 = b2_03;
			
		end
		4'b0101:
		begin
			
			enable0 = 0;
			enable1 = 1;
			enable2 = 1;
			enable3 = 1;
			enable4 = 1;
			enable5 = 1;
			enable6 = 1;
			enable7 = 1;
			enable8 = 1;
			enable9 = 1;
			enable10 = 1;
			enable11 =0;
			enable12 = 1;
			enable13 = 1;
			enable14 = 0;
			enable15 =0;
			
	
			//-----------------------------------
			inp_west0 = 'b0;
			inp_west4 = a13;
			inp_west8 = a22;
			inp_west12 = a31;
			//-------------------------
			inp_north0 = 'b0;
			inp2_north0 = 'b0;
			inp_north1 = b1_31;
			inp2_north1 = b2_31;
			inp_north2 = b1_22;
			inp2_north2 = b2_22;
			inp_north3 = b1_13;
			inp2_north3 = b2_13;
		end
		4'b0110:
		begin
		
			enable0 = 0;
			enable1 = 0;
			enable2 = 1;
			enable3 = 1;
			enable4 = 0;
			enable5 = 1;
			enable6 = 1;
			enable7 = 1;
			enable8 = 1;
			enable9 = 1;
			enable10 = 1;
			enable11 =1;
			enable12 = 1;
			enable13 = 1;
			enable14 = 1;
			enable15 =1;
			

			//-----------------------------------
			inp_west0 = 'b0;
			inp_west4 = 'b0;
			inp_west8 = a23;
			inp_west12 = a32;
			///////////////////////
			inp_north0 = 'b0;
			inp2_north0 = 'b0; 
			inp_north1 = 'b0; 
			inp2_north1 = 'b0; 
			
			inp_north2 = b1_32;
			inp2_north2 = b2_32;
			inp_north3 = b1_23;
			inp2_north3 = b2_23;
		end
		4'b0111:
		begin
			enable0 = 0;
			enable1 = 0;
			enable2 = 0;
			enable3 = 1;
			enable4 = 0;
			enable5 = 0;
			enable6 = 1;
			enable7 = 1;
			enable8 = 0;
			enable9 = 1;
			enable10 = 1;
			enable11 =1;
			enable12 = 1;
			enable13 = 1;
			enable14 = 1;
			enable15 =1;

			//-----------------------------------
			inp_west0 = 'b0;
			inp_west4 = 'b0;
			inp_west8 = 'b0;
			inp_west12 = a33;
			//--------------------------------
			inp_north0 = 'b0;
			inp2_north0 = 'b0; 
			inp_north1 = 'b0; 
			inp2_north1 = 'b0; 
			
			inp_north2 = 'b0;
			inp2_north2 = 'b0;
			inp_north3 = b1_33;
			inp2_north3 = b2_33;
			
			
		end
		4'b1000:
		begin
		
			enable0 = 0;
			enable1 = 0;
			enable2 = 0;
			enable3 = 0;
			enable4 = 0;
			enable5 = 0;
			enable6 = 0;
			enable7 = 1;
			enable8 = 0;
			enable9 = 0;
			enable10 = 1;
			enable11 =1;
			enable12 = 0;
			enable13 = 1;
			enable14 = 1;
			enable15 =1;
			
			//-----------------------------------
			inp_west0 = 'b0;
			inp_west4 = 'b0;
			inp_west8 = 'b0;
			inp_west12 = 'b0;
			//--------------------------------
			inp_north0 = 'b0;
			inp2_north0 = 'b0; 
			inp_north1 = 'b0; 
			inp2_north1 = 'b0; 
			
			inp_north2 = 'b0;
			inp2_north2 = 'b0;
			inp_north3 = 'b0;
			inp2_north3 = 'b0;
			
		end
		4'b1001:
		begin
		
			enable0 = 0;
			enable1 = 0;
			enable2 = 0;
			enable3 = 0;
			enable4 = 0;
			enable5 = 0;
			enable6 = 0;
			enable7 = 0;
			enable8 = 0;
			enable9 = 0;
			enable10 = 0;
			enable11 =1;
			enable12 = 0;
			enable13 = 0;
			enable14 = 1;
			enable15 =1;
		
			//-----------------------------------
			inp_west0 = 'b0;
			inp_west4 = 'b0;
			inp_west8 = 'b0;
			inp_west12 = 'b0;
			//--------------------------------
			inp_north0 = 'b0;
			inp2_north0 = 'b0; 
			inp_north1 = 'b0; 
			inp2_north1 = 'b0; 
			
			inp_north2 = 'b0;
			inp2_north2 = 'b0;
			inp_north3 = 'b0;
			inp2_north3 = 'b0;
			
		end
		4'b1010:
		begin
		
			enable0 = 0;
			enable1 = 0;
			enable2 = 0;
			enable3 = 0;
			enable4 = 0;
			enable5 = 0;
			enable6 = 0;
			enable7 = 0;
			enable8 = 0;
			enable9 = 0;
			enable10 = 0;
			enable11 =0;
			enable12 = 0;
			enable13 = 0;
			enable14 = 0;
			enable15 =1;
		

			//-----------------------------------
			inp_west0 = 'b0;
			inp_west4 = 'b0;
			inp_west8 = 'b0;
			inp_west12 = 'b0;
			//--------------------------------
			inp_north0 = 'b0;
			inp2_north0 = 'b0; 
			inp_north1 = 'b0; 
			inp2_north1 = 'b0; 
			
			inp_north2 = 'b0;
			inp2_north2 = 'b0;
			inp_north3 = 'b0;
			inp2_north3 = 'b0;
			
		end
		default:
			begin
			
			enable0 = 0;
			enable1 = 0;
			enable2 = 0;
			enable3 = 0;
			enable4 = 0;
			enable5 = 0;
			enable6 = 0;
			enable7 = 0;
			enable8 = 0;
			enable9 = 0;
			enable10 = 0;
			enable11 =0;
			enable12 = 0;
			enable13 = 0;
			enable14 = 0;
			enable15 =0;
			//-----------------------------------
			inp_west0 = 'b0;
			inp_west4 = 'b0;
			inp_west8 = 'b0;
			inp_west12 = 'b0;
			//--------------------------------
			inp_north0 = 'b0;
			inp2_north0 = 'b0; 
			inp_north1 = 'b0; 
			inp2_north1 = 'b0; 
			
			inp_north2 = 'b0;
			inp2_north2 = 'b0;
			inp_north3 = 'b0;
			inp2_north3 = 'b0;
		end
	endcase
end
endmodule
