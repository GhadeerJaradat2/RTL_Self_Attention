
`timescale 1ns/1ns
`define width 8


module ArrangedArray_TB();
parameter FRACTIONAL_BITS = 8;
parameter WIDTH = 8;
	reg clk,_reset;
	reg [7:0] enables;
	reg lastTileFlag;
	reg signed [`width-1:0] a00,a01,a02,a03;
	reg signed [`width-1:0] a10,a11,a12,a13 ;
	reg signed [`width-1:0] a20,a21,a22,a23;
	reg signed [`width-1:0] a30,a31,a32,a33 ;//rows of the input matrix
	
	reg signed [`width-1:0] b1_00,b1_10,b1_20,b1_30 ;
	reg signed [`width-1:0] b1_01,b1_11,b1_21,b1_31 ;
	reg signed [`width-1:0] b1_02,b1_12,b1_22,b1_32 ;
	reg signed [`width-1:0] b1_03,b1_13,b1_23,b1_33  ;//cols of the input matrix
	
	reg signed [`width-1:0] b2_00,b2_10,b2_20,b2_30 ;
	reg signed [`width-1:0] b2_01,b2_11,b2_21,b2_31 ;
	reg signed [`width-1:0] b2_02,b2_12,b2_22,b2_32 ;
	reg signed [`width-1:0] b2_03,b2_13,b2_23,b2_33 ;
	
	reg signed [`width-1:0] c1_00,c1_10,c1_20,c1_30;
	reg signed [`width-1:0] c1_01,c1_11,c1_21,c1_31;
	reg signed [`width-1:0] c1_02,c1_12,c1_22,c1_32;
	reg signed [`width-1:0] c1_03,c1_13,c1_23,c1_33;//cols of the input matrix C1
	
	reg signed [`width-1:0] c2_00,c2_10,c2_20,c2_30;
	reg signed [`width-1:0] c2_01,c2_11,c2_21,c2_31;
	reg signed [`width-1:0] c2_02,c2_12,c2_22,c2_32;
	reg signed [`width-1:0] c2_03,c2_13,c2_23,c2_33;//cols of the input matrix C2
	
	
	wire signed  [2*`width-1:0] result0 ,result1,result2,result3 ;
	wire signed [2*`width-1:0] result4,result5,result6,result7;
	wire signed [2*`width-1:0] result8,result9,result10,result11;
	wire signed [2*`width-1:0] result12,result13,result14,result15;
	
	wire signed [2*`width-1:0] result2_0 ,result2_1,result2_2,result2_3;
	wire signed [2*`width-1:0] result2_4,result2_5,result2_6,result2_7;
	wire signed [2*`width-1:0] result2_8,result2_9,result2_10,result2_11;
	wire signed [2*`width-1:0] result2_12,result2_13,result2_14,result2_15; 
	
	reg signed [2*`width-1:0] integerRes0,integerRes1,integerRes2,integerRes3;
	reg signed [2*`width-1:0] integerRes4,integerRes5,integerRes6,integerRes7;
	reg signed [2*`width-1:0] integerRes8,integerRes9,integerRes10,integerRes11;
	reg signed [2*`width-1:0] integerRes12,integerRes13,integerRes14,integerRes15;
	
	reg endOfRowFlag;
	reg endOfHeadFlag;
	reg [2*`width-1:0] headThreshold;
	
	wire [511:0] Mask0,Mask1;
	wire [2*`width-1:0] sumHead;
	wire  done;
	wire headprune;
	
	reg _resetPE,_resetRow,_resetHead;
	reg MulFractionsFlag,MulIntegerFlag,MulValueFlag;
	////////////////////

	wire [2:0] blockPruningRatio=3'b000;

	ArrangeArray #( WIDTH, FRACTIONAL_BITS) DUT(
	clk,_resetPE,_resetRow,_resetHead,enables,MulIntegerFlag,MulFractionsFlag,MulValueFlag,lastTileFlag,endOfRowFlag,endOfHeadFlag,headThreshold,blockPruningRatio,
	a00,a01,a02,a03,a10,a11,a12,a13 ,a20,a21,a22,a23, a30,a31,a32,a33 ,
	b1_00,b1_10,b1_20,b1_30 , b1_01,b1_11,b1_21,b1_31 , b1_02,b1_12,b1_22,b1_32 , b1_03,b1_13,b1_23,b1_33  ,//cols of the input matrix
	b2_00,b2_10,b2_20,b2_30 , b2_01,b2_11,b2_21,b2_31 , b2_02,b2_12,b2_22,b2_32 , b2_03,b2_13,b2_23,b2_33 ,
	c1_00,c1_10,c1_20,c1_30,c1_01,c1_11,c1_21,c1_31,c1_02,c1_12,c1_22,c1_32,c1_03,c1_13,c1_23,c1_33,
	c2_00,c2_10,c2_20,c2_30,c2_01,c2_11,c2_21,c2_31,c2_02,c2_12,c2_22,c2_32,c2_03,c2_13,c2_23,c2_33,
	
	integerRes0,integerRes1, integerRes2,integerRes3,integerRes4,integerRes5,integerRes6,integerRes7,integerRes8,integerRes9,
	integerRes10,  integerRes11,integerRes12,integerRes13,integerRes14,integerRes15,
	
	result0 ,result1,result2,result3 , result4,result5,result6,result7,
	result8,result9,result10,result11,	result12,result13,result14,result15,
	result2_0 ,result2_1,result2_2,result2_3,	result2_4,result2_5,result2_6,result2_7,
	result2_8,result2_9,result2_10,result2_11,	result2_12,result2_13,result2_14,result2_15, 
	Mask0,Mask1,headprune,sumHead,done
	);
integer fd1,fd2,fd3,fd4,fd5,temp1,temp2,temp3,temp4,temp5,i,j,fd_out1,fd_out2,flag=0;
reg signed [`width-1:0]  Matrix1[0:3][0:3];
reg signed [`width-1:0]  Matrix2[0:3][0:3];
reg signed [`width-1:0]  Matrix3[0:3][0:3];
reg signed [`width-1:0]  Matrix4[0:3][0:3];
reg signed [`width-1:0]  Matrix5[0:3][0:3];
reg signed [`width-1:0]  Result1[0:3][0:3];
reg signed [2*`width-1:0]  Result2[0:3][0:3];

initial begin
$display("HELLO");
	
	_reset<=0;
	_resetPE<=0;
	_resetRow<=0;
	_resetHead<=0;
	MulIntegerFlag<=0;
	endOfHeadFlag<=0;
	endOfRowFlag<=0;
	#12
	_reset<=1;
	_resetPE<=1;
	_resetRow<=1;
	_resetHead<=1;
	MulIntegerFlag<=1;
	MulFractionsFlag<=0;
	MulValueFlag<=0;
	endOfHeadFlag<=1;
	lastTileFlag<=1;
	endOfRowFlag<=1;
	enables<=8'hff;
	headThreshold<=16'h0001;
	integerRes0<=1;integerRes1<=2;integerRes2<=3;integerRes3<=4;integerRes4<=5;integerRes5<=6;integerRes6<=7;integerRes7<=8; 
	integerRes8<=9;integerRes9<=10;integerRes10<=11;integerRes11<=12;integerRes12<=13;integerRes13<=14;integerRes14<=15;integerRes15<=16;
	$display("Initial begin");
	fd1=$fopen("Ones.txt","r");
	fd2=$fopen("tows.txt","r");
	fd3=$fopen("three.txt","r");
	fd4=$fopen("four.txt","r");
	fd5=$fopen("five.txt","r");

	for( i=0; i<4; i=i+1)
		for( j=0; j<4; j=j+1)
			begin
				temp1=$fscanf(fd1, "%h\n",Matrix1[i][j]);
				temp2=$fscanf(fd2, "%h\n",Matrix2[i][j]);
				temp3=$fscanf(fd3, "%h\n",Matrix3[i][j]);
				temp4=$fscanf(fd4, "%h\n",Matrix4[i][j]);
				temp5=$fscanf(fd5, "%h\n",Matrix5[i][j]);
						
			end
	for( i=0; i<4; i=i+1)
		for( j=0; j<4; j=j+1)
			begin
			$display(Matrix1[i][j],Matrix2[i][j],Matrix3[i][j],Matrix4[i][j],Matrix5[i][j]);
			
			end
	$fclose(fd1);
	$fclose(fd2);
	$fclose(fd3);
	$fclose(fd4);
	$fclose(fd5);

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
	//--------------------------------------------------
	c1_00<=Matrix4[0][0];
	c1_10<=Matrix4[1][0];
	c1_20<=Matrix4[2][0];
	c1_30<=Matrix4[3][0];
	c1_01<=Matrix4[0][1];
	c1_11<=Matrix4[1][1];
	c1_21<=Matrix4[2][1];
	c1_31<=Matrix4[3][1];
	c1_02<=Matrix4[0][2];
	c1_12<=Matrix4[1][2];
	c1_22<=Matrix4[2][2];
	c1_32<=Matrix4[3][2];
	c1_33<=Matrix4[0][3];
	c1_23<=Matrix4[1][3];
	c1_13<=Matrix4[2][3];
	c1_03<=Matrix4[3][3];
//--------------------------------------------------
	c2_00<=Matrix5[0][0];
	c2_10<=Matrix5[1][0];
	c2_20<=Matrix5[2][0];
	c2_30<=Matrix5[3][0];
	c2_01<=Matrix5[0][1];
	c2_11<=Matrix5[1][1];
	c2_21<=Matrix5[2][1];
	c2_31<=Matrix5[3][1];
	c2_02<=Matrix5[0][2];
	c2_12<=Matrix5[1][2];
	c2_22<=Matrix5[2][2];
	c2_32<=Matrix5[3][2];
	c2_33<=Matrix5[0][3];
	c2_23<=Matrix5[1][3];
	c2_13<=Matrix5[2][3];
	c2_03<=Matrix5[3][3];
	//--------------------------------------------------
	/////////////////////////////
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
	end
end




/* initial begin
	//$monitor(" Time %t clk=%b a00=%h reset=%b result1_0=%h",$time,clk,a00,reset,result1_0);
	//#120 $stop;
end */


endmodule

