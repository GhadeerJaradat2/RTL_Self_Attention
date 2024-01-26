`timescale 1ns/1ns
`define width 8
module SystolicArrayTest;
//input 
reg clk,reset;
reg  signed [`width-1:0] a00,a01,a02,a03;
reg	 signed [`width-1:0] a10,a11,a12,a13 ;
reg	 signed [`width-1:0] a20,a21,a22,a23;
reg	 signed [`width-1:0] a30,a31,a32,a33 ;//rows of the input matrix
	
reg	 signed [`width-1:0] b1_00,b1_10,b1_20,b1_30 ;
reg	 signed [`width-1:0] b1_01,b1_11,b1_21,b1_31 ;
reg	 signed [`width-1:0] b1_02,b1_12,b1_22,b1_32 ;
reg	 signed [`width-1:0] b1_03,b1_13,b1_23,b1_33 ;//cols of the input matrix
	
reg	 signed [`width-1:0] b2_00,b2_10,b2_20,b2_30 ;
reg	 signed [`width-1:0] b2_01,b2_11,b2_21,b2_31 ;
reg	 signed [`width-1:0] b2_02,b2_12,b2_22,b2_32 ;
reg	 signed [`width-1:0] b2_03,b2_13,b2_23,b2_33 ;

wire signed [2*`width-1:0] result1_0 ,result1_1,result1_2,result1_3;
wire signed [2*`width-1:0] result1_4,result1_5,result1_6,result1_7;
wire signed [2*`width-1:0] result1_8,result1_9,result1_10,result1_11;
wire signed [2*`width-1:0] result1_12,result1_13,result1_14,result1_15;
	
wire signed [2*`width-1:0] result2_0 ,result2_1,result2_2,result2_3;
wire signed [2*`width-1:0] result2_4,result2_5,result2_6,result2_7;
wire signed [2*`width-1:0] result2_8,result2_9,result2_10,result2_11;
wire signed [2*`width-1:0] result2_12,result2_13,result2_14,result2_15;
	
wire done ;
reg _flush_acc;
SystolicArray4x4 DUT(a00,a01,a02,a03,a10,a11,a12,a13,a20,a21,a22,a23,a30,a31,a32,a33,
					 b1_00,b1_10,b1_20,b1_30,b1_01,b1_11,b1_21,b1_31,b1_02,b1_12,b1_22,b1_32,b1_03,b1_13,b1_23,b1_33,
					 b2_00,b2_10,b2_20,b2_30,b2_01,b2_11,b2_21,b2_31,b2_02,b2_12,b2_22,b2_32,b2_03,b2_13,b2_23,b2_33,
					 clk,reset,_flush_acc,
					 result1_0 ,result1_1,result1_2,result1_3,
					 result1_4,result1_5,result1_6,result1_7,
					 result1_8,result1_9,result1_10,result1_11,
					 result1_12,result1_13,result1_14,result1_15,
					 result2_0 ,result2_1,result2_2,result2_3,
					 result2_4,result2_5,result2_6,result2_7,
					 result2_8,result2_9,result2_10,result2_11,
					 result2_12,result2_13,result2_14,result2_15,
					 done);
					 
integer fd1,fd2,fd3,temp1,temp2,temp3,i,j,fd_out1,fd_out2,flag=0;
reg signed [`width-1:0]  Matrix1[0:3][0:3];
reg signed [`width-1:0]  Matrix2[0:3][0:3];
reg signed [`width-1:0]  Matrix3[0:3][0:3];
reg signed [`width-1:0]  Result1[0:3][0:3];
reg signed [2*`width-1:0]  Result2[0:3][0:3];
initial begin
$display("HELLO");
	
	reset<=1;
	_flush_acc<=1;
	
	$display("Initial begin");
	fd1=$fopen("Matrix1_INT_hex.txt","r");
	fd2=$fopen("Matrix2_INT_hex.txt","r");
	fd3=$fopen("Matrix3_INT_hex.txt","r");
	
	for( i=0; i<4; i=i+1)
		for( j=0; j<4; j=j+1)
			begin
				temp1=$fscanf(fd1, "%h\n",Matrix1[i][j]);
				temp2=$fscanf(fd2, "%h\n",Matrix2[i][j]);
				temp3=$fscanf(fd3, "%h\n",Matrix3[i][j]);
						
			end
	for( i=0; i<4; i=i+1)
		for( j=0; j<4; j=j+1)
			begin
			$display(Matrix1[i][j],Matrix2[i][j],Matrix3[i][j]);
			end
	$fclose(fd1);
	$fclose(fd2);
	$fclose(fd3);
	a00<=Matrix1[0][0];
	a01<=Matrix1[0][1];
	a02<=Matrix1[0][2];
	a03<=Matrix1[0][3];
	a10<=Matrix1[1][0];
	a11<=Matrix1[1][1];
	a12<=Matrix1[1][2];
	a13<=Matrix1[1][3];
	a20<=Matrix1[2][0];
	a21<=Matrix1[2][1];
	a22<=Matrix1[2][2];
	a23<=Matrix1[2][3];
	a30<=Matrix1[3][0];
	a31<=Matrix1[3][1];
	a32<=Matrix1[3][2];
	a33<=Matrix1[3][3];
	
	b1_00<=Matrix2[0][0];
	b1_10<=Matrix2[1][0];
	b1_20<=Matrix2[2][0];
	b1_30<=Matrix2[3][0];
	//----------------
	b1_01<=Matrix2[0][1];
	b1_11<=Matrix2[1][1];
	b1_21<=Matrix2[2][1];
	b1_31<=Matrix2[3][1];
	//--------------
	b1_02<=Matrix2[0][2];
	b1_12<=Matrix2[1][2];
	b1_22<=Matrix2[2][2];
	b1_32<=Matrix2[3][2];
	//-----------------
	b1_03<=Matrix2[0][3];
	b1_13<=Matrix2[1][3];
	b1_23<=Matrix2[2][3];
	b1_33<=Matrix2[3][3];

	b2_00<=Matrix3[0][0];
	b2_10<=Matrix3[1][0];
	b2_20<=Matrix3[2][0];
	b2_30<=Matrix3[3][0];
	//-----------
	b2_01<=Matrix3[0][1];
	b2_11<=Matrix3[1][1];
	b2_21<=Matrix3[2][1];
	b2_31<=Matrix3[3][1];
	//-----------
	b2_02<=Matrix3[0][2];
	b2_12<=Matrix3[1][2];
	b2_22<=Matrix3[2][2];
	b2_32<=Matrix3[3][2];
	//---------------
	b2_03<=Matrix3[0][3];
	b2_13<=Matrix3[1][3];
	b2_23<=Matrix3[2][3];
	b2_33<=Matrix3[3][3];
	//------------------------------------
	



	
end
initial begin
	clk<=0'b0;
	
	forever begin
		
	#5 clk=~clk;
	if(done)
		flag<=1;
	if(flag)
	begin
		Result1[0][0]<= result1_0;
		Result1[0][1]<= result1_1;
		Result1[0][2]<= result1_2;
		Result1[0][3]<= result1_3;
		Result1[1][0]<= result1_4;
		Result1[1][1]<= result1_5;
		Result1[1][2]<= result1_6;
		Result1[1][3]<= result1_7;
		Result1[2][0]<= result1_8;
		Result1[2][1]<= result1_9;
		Result1[2][2]<= result1_10;
		Result1[2][3]<= result1_11;
		Result1[3][0]<= result1_12;
		Result1[3][1]<= result1_13;
		Result1[3][2]<= result1_14;
		Result1[3][3]<= result1_15;
		//---------------------------------------
		Result2[0][0]<= result2_0;
		Result2[0][1]<= result2_1;
		Result2[0][2]<= result2_2;
		Result2[0][3]<= result2_3;
		Result2[1][0]<= result2_4;
		Result2[1][1]<= result2_5;
		Result2[1][2]<= result2_6;
		Result2[1][3]<= result2_7;
		Result2[2][0]<= result2_8;
		Result2[2][1]<= result2_9;
		Result2[2][2]<= result2_10;
		Result2[2][3]<= result2_11;
		Result2[3][0]<= result2_12;
		Result2[3][1]<= result2_13;
		Result2[3][2]<= result2_14;
		Result2[3][3]<= result2_15;
		flag=2;
		end
		
	if(flag==2)
	begin
		fd_out1 = $fopen("OutputMatrix1.txt", "w");
		fd_out2 = $fopen("OutputMatrix2.txt", "w");	
		$display("print Result");		
		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				$fdisplay(fd_out1, "%h", Result1[i][j]);
				$fdisplay(fd_out2, "%h", Result2[i][j]);
			end
		end
		flag=0;
	end
// Close the output file
$fclose(fd_out1);
$fclose(fd_out2);

	end
end




initial begin
	//$monitor(" Time %t clk=%b a00=%h reset=%b result1_0=%h",$time,clk,a00,reset,result1_0);
	#120 $stop;
end
endmodule
