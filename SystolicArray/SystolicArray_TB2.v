`timescale 1ns/1ns
`define width 8

module SystolicArray_TB2;

reg clk,_reset;
reg  signed [`width-1:0] a_INT [0:3][0:3];//matrix for intger parts
reg	 signed [`width-1:0] a_Frac [0:3][0:3]; //matrix for Fractions parts

reg	 signed [`width-1:0] b_INT [0:3][0:3];
reg	 signed [`width-1:0] b_Frac [0:3][0:3];

reg	 signed [`width-1:0] c_INT [0:3][0:3];
reg	 signed [`width-1:0] c_Frac [0:3][0:3];

wire signed [2*`width-1:0] result1_INT [0:3][0:3];
wire signed [2*`width-1:0] result1_Frac1 [0:3][0:3];
wire signed [2*`width-1:0] result1_Frac2 [0:3][0:3];

wire signed [2*`width-1:0] result2_INT [0:3][0:3];
wire signed [2*`width-1:0] result2_Frac1 [0:3][0:3];
wire signed [2*`width-1:0] result2_Frac2 [0:3][0:3];
wire signed [2*`width-1:0] AdditionResult1 [0:3][0:3];
wire signed [2*`width-1:0] AdditionResult2 [0:3][0:3];

wire   headPrune;
//------------------------------------------------------------------------------
integer fd1,fd2,fd3,fd4,fd5,fd6,temp1,temp2,temp3,temp4,temp5,temp6,i,j,m,n,fd_out1,fd_out2,m1,n1;
reg signed [`width-1:0]  Matrix1_INT[0:3][0:3];
reg signed [`width-1:0]  Matrix1_Frac[0:3][0:3];
reg signed [`width-1:0]  Matrix2_INT[0:3][0:3];
reg signed [`width-1:0]  Matrix2_Frac[0:3][0:3];
reg signed [`width-1:0]  Matrix3_INT[0:3][0:3];
reg signed [`width-1:0]  Matrix3_Frac[0:3][0:3];

reg signed [2*`width-1:0]  Result1[0:3][0:3];
reg signed [2*`width-1:0]  Result2[0:3][0:3];
reg signed [2*`width-1:0]  Result3[0:3][0:3];

wire done1,done2,done3,donr ;
reg _flush_acc;
wire div_start;
reg endofINT_INT_Mat;
wire [11:0]numberofInput=12'h003;
wire f=1;
assign done=done1 & done2 & done3;
arrayMean dut_mean(  done,
					 endofINT_INT_Mat,
					 result1_INT[ 0 ][ 0 ],result1_INT[ 0 ][ 1 ],result1_INT[ 0 ][ 2 ],result1_INT[ 0 ][ 3 ],
					 result1_INT[ 1 ][ 0 ],result1_INT[ 1 ][ 1 ],result1_INT[ 1 ][ 2 ],result1_INT[ 1 ][ 3 ],
					 result1_INT[ 2 ][ 0 ],result1_INT[ 2 ][ 1 ],result1_INT[ 2 ][ 2 ],result1_INT[ 2 ][ 3 ],
					 result1_INT[ 3 ][ 0 ],result1_INT[ 3 ][ 1 ],result1_INT[ 3 ][ 2 ],result1_INT[ 3 ][ 3 ],
					 
					 result2_INT[ 0 ][ 0 ],result2_INT[ 0 ][ 1 ],result2_INT[ 0 ][ 2 ],result2_INT[ 0 ][ 3 ],
					 result2_INT[ 1 ][ 0 ],result2_INT[ 1 ][ 1 ],result2_INT[ 1 ][ 2 ],result2_INT[ 1 ][ 3 ],
					 result2_INT[ 2 ][ 0 ],result2_INT[ 2 ][ 1 ],result2_INT[ 2 ][ 2 ],result2_INT[ 2 ][ 3 ],
					 result2_INT[ 3 ][ 0 ],result2_INT[ 3 ][ 1 ],result2_INT[ 3 ][ 2 ],result2_INT[ 3 ][ 3 ],
					 clk,_reset,
					 headPrune					 
				   );

				   //to add int+frac1+frac2
/* Adder DUT_Adder(	done,
					 result1_INT[ 0 ][ 0 ],result1_INT[ 0 ][ 1 ],result1_INT[ 0 ][ 2 ],result1_INT[ 0 ][ 3 ],
					 result1_INT[ 1 ][ 0 ],result1_INT[ 1 ][ 1 ],result1_INT[ 1 ][ 2 ],result1_INT[ 1 ][ 3 ],
					 result1_INT[ 2 ][ 0 ],result1_INT[ 2 ][ 1 ],result1_INT[ 2 ][ 2 ],result1_INT[ 2 ][ 3 ],
					 result1_INT[ 3 ][ 0 ],result1_INT[ 3 ][ 1 ],result1_INT[ 3 ][ 2 ],result1_INT[ 3 ][ 3 ],
					 
					 result1_Frac1[ 0 ][ 0 ],result1_Frac1[ 0 ][ 1 ],result1_Frac1[ 0 ][ 2 ],result1_Frac1[ 0 ][ 3 ],
					 result1_Frac1[ 1 ][ 0 ],result1_Frac1[ 1 ][ 1 ],result1_Frac1[ 1 ][ 2 ],result1_Frac1[ 1 ][ 3 ],
					 result1_Frac1[ 2 ][ 0 ],result1_Frac1[ 2 ][ 1 ],result1_Frac1[ 2 ][ 2 ],result1_Frac1[ 2 ][ 3 ],
					 result1_Frac1[ 3 ][ 0 ],result1_Frac1[ 3 ][ 1 ],result1_Frac1[ 3 ][ 2 ],result1_Frac1[ 3 ][ 3 ],
					 
					 result1_Frac2[ 0 ][ 0 ],result1_Frac2[ 0 ][ 1 ],result1_Frac2[ 0 ][ 2 ],result1_Frac2[ 0 ][ 3 ],
					 result1_Frac2[ 1 ][ 0 ],result1_Frac2[ 1 ][ 1 ],result1_Frac2[ 1 ][ 2 ],result1_Frac2[ 1 ][ 3 ],
					 result1_Frac2[ 2 ][ 0 ],result1_Frac2[ 2 ][ 1 ],result1_Frac2[ 2 ][ 2 ],result1_Frac2[ 2 ][ 3 ],
					 result1_Frac2[ 3 ][ 0 ],result1_Frac2[ 3 ][ 1 ],result1_Frac2[ 3 ][ 2 ],result1_Frac2[ 3 ][ 3 ],
					 clk,_reset,
					 AdditionResult1[ 0 ][ 0 ],AdditionResult1[ 0 ][ 1 ],AdditionResult1[ 0 ][ 2 ],AdditionResult1[ 0 ][ 3 ],
					 AdditionResult1[ 1 ][ 0 ],AdditionResult1[ 1 ][ 1 ],AdditionResult1[ 1 ][ 2 ],AdditionResult1[ 1 ][ 3 ],
					 AdditionResult1[ 2 ][ 0 ],AdditionResult1[ 2 ][ 1 ],AdditionResult1[ 2 ][ 2 ],AdditionResult1[ 2 ][ 3 ],
					 AdditionResult1[ 3 ][ 0 ],AdditionResult1[ 3 ][ 1 ],AdditionResult1[ 3 ][ 2 ],AdditionResult1[ 3 ][ 3 ]
					 ); */
					 
				 
					 
SystolicArray4x4 DUT(a_INT[ 0 ][ 0 ],a_INT[ 0 ][ 1 ],a_INT[ 0 ][ 2 ],a_INT[ 0 ][ 3 ],
					 a_INT[ 1 ][ 0 ],a_INT[ 1 ][ 1 ],a_INT[ 1 ][ 2 ],a_INT[ 1 ][ 3 ],
					 a_INT[ 2 ][ 0 ],a_INT[ 2 ][ 1 ],a_INT[ 2 ][ 2 ],a_INT[ 2 ][ 3 ],
					 a_INT[ 3 ][ 0 ],a_INT[ 3 ][ 1 ],a_INT[ 3 ][ 2 ],a_INT[ 3 ][ 3 ],
					 b_INT[ 0 ][ 0 ],b_INT[ 1 ][ 0 ],b_INT[ 2 ][ 0 ],b_INT[ 3 ][ 0 ],
					 b_INT[ 0 ][ 1 ],b_INT[ 1 ][ 1 ],b_INT[ 2 ][ 1 ],b_INT[ 3 ][ 1 ],
					 b_INT[ 0 ][ 2 ],b_INT[ 1 ][ 2 ],b_INT[ 2 ][ 2 ],b_INT[ 3 ][ 2 ],
					 b_INT[ 0 ][ 3 ],b_INT[ 1 ][ 3 ],b_INT[ 2 ][ 3 ],b_INT[ 3 ][ 3 ],
					 c_INT[ 0 ][ 0 ],c_INT[ 1 ][ 0 ],c_INT[ 2 ][ 0 ],c_INT[ 3 ][ 0 ],
					 c_INT[ 0 ][ 1 ],c_INT[ 1 ][ 1 ],c_INT[ 2 ][ 1 ],c_INT[ 3 ][ 1 ],
					 c_INT[ 0 ][ 2 ],c_INT[ 1 ][ 2 ],c_INT[ 2 ][ 2 ],c_INT[ 3 ][ 2 ],
					 c_INT[ 0 ][ 3 ],c_INT[ 1 ][ 3 ],c_INT[ 2 ][ 3 ],c_INT[ 3 ][ 3 ],					 
					 clk,_reset,_flush_acc,
					 result1_INT[ 0 ][ 0 ],result1_INT[ 0 ][ 1 ],result1_INT[ 0 ][ 2 ],result1_INT[ 0 ][ 3 ],
					 result1_INT[ 1 ][ 0 ],result1_INT[ 1 ][ 1 ],result1_INT[ 1 ][ 2 ],result1_INT[ 1 ][ 3 ],
					 result1_INT[ 2 ][ 0 ],result1_INT[ 2 ][ 1 ],result1_INT[ 2 ][ 2 ],result1_INT[ 2 ][ 3 ],
					 result1_INT[ 3 ][ 0 ],result1_INT[ 3 ][ 1 ],result1_INT[ 3 ][ 2 ],result1_INT[ 3 ][ 3 ],
					 result2_INT[ 0 ][ 0 ],result2_INT[ 0 ][ 1 ],result2_INT[ 0 ][ 2 ],result2_INT[ 0 ][ 3 ],
					 result2_INT[ 1 ][ 0 ],result2_INT[ 1 ][ 1 ],result2_INT[ 1 ][ 2 ],result2_INT[ 1 ][ 3 ],
					 result2_INT[ 2 ][ 0 ],result2_INT[ 2 ][ 1 ],result2_INT[ 2 ][ 2 ],result2_INT[ 2 ][ 3 ],
					 result2_INT[ 3 ][ 0 ],result2_INT[ 3 ][ 1 ],result2_INT[ 3 ][ 2 ],result2_INT[ 3 ][ 3 ],
					 done1);
					 
SystolicArray4x4 DUT1(a_INT[ 0 ][ 0 ],a_INT[ 0 ][ 1 ],a_INT[ 0 ][ 2 ],a_INT[ 0 ][ 3 ],
					 a_INT[ 1 ][ 0 ],a_INT[ 1 ][ 1 ],a_INT[ 1 ][ 2 ],a_INT[ 1 ][ 3 ],
					 a_INT[ 2 ][ 0 ],a_INT[ 2 ][ 1 ],a_INT[ 2 ][ 2 ],a_INT[ 2 ][ 3 ],
					 a_INT[ 3 ][ 0 ],a_INT[ 3 ][ 1 ],a_INT[ 3 ][ 2 ],a_INT[ 3 ][ 3 ],
					 
					 b_Frac[ 0 ][ 0 ],b_Frac[ 1 ][ 0 ],b_Frac[ 2 ][ 0 ],b_Frac[ 3 ][ 0 ],
					 b_Frac[ 0 ][ 1 ],b_Frac[ 1 ][ 1 ],b_Frac[ 2 ][ 1 ],b_Frac[ 3 ][ 1 ],
					 b_Frac[ 0 ][ 2 ],b_Frac[ 1 ][ 2 ],b_Frac[ 2 ][ 2 ],b_Frac[ 3 ][ 2 ],
					 b_Frac[ 0 ][ 3 ],b_Frac[ 1 ][ 3 ],b_Frac[ 2 ][ 3 ],b_Frac[ 3 ][ 3 ],
					 c_Frac[ 0 ][ 0 ],c_Frac[ 1 ][ 0 ],c_Frac[ 2 ][ 0 ],c_Frac[ 3 ][ 0 ],
					 c_Frac[ 0 ][ 1 ],c_Frac[ 1 ][ 1 ],c_Frac[ 2 ][ 1 ],c_Frac[ 3 ][ 1 ],
					 c_Frac[ 0 ][ 2 ],c_Frac[ 1 ][ 2 ],c_Frac[ 2 ][ 2 ],c_Frac[ 3 ][ 2 ],
					 c_Frac[ 0 ][ 3 ],c_Frac[ 1 ][ 3 ],c_Frac[ 2 ][ 3 ],c_Frac[ 3 ][ 3 ],					 
					 clk,_reset,_flush_acc,
					 result1_Frac1[ 0 ][ 0 ],result1_Frac1[ 0 ][ 1 ],result1_Frac1[ 0 ][ 2 ],result1_Frac1[ 0 ][ 3 ],
					 result1_Frac1[ 1 ][ 0 ],result1_Frac1[ 1 ][ 1 ],result1_Frac1[ 1 ][ 2 ],result1_Frac1[ 1 ][ 3 ],
					 result1_Frac1[ 2 ][ 0 ],result1_Frac1[ 2 ][ 1 ],result1_Frac1[ 2 ][ 2 ],result1_Frac1[ 2 ][ 3 ],
					 result1_Frac1[ 3 ][ 0 ],result1_Frac1[ 3 ][ 1 ],result1_Frac1[ 3 ][ 2 ],result1_Frac1[ 3 ][ 3 ],
					 
					 result2_Frac1[ 0 ][ 0 ],result2_Frac1[ 0 ][ 1 ],result2_Frac1[ 0 ][ 2 ],result2_Frac1[ 0 ][ 3 ],
					 result2_Frac1[ 1 ][ 0 ],result2_Frac1[ 1 ][ 1 ],result2_Frac1[ 1 ][ 2 ],result2_Frac1[ 1 ][ 3 ],
					 result2_Frac1[ 2 ][ 0 ],result2_Frac1[ 2 ][ 1 ],result2_Frac1[ 2 ][ 2 ],result2_Frac1[ 2 ][ 3 ],
					 result2_Frac1[ 3 ][ 0 ],result2_Frac1[ 3 ][ 1 ],result2_Frac1[ 3 ][ 2 ],result2_Frac1[ 3 ][ 3 ],
					 done2);

SystolicArray4x4 DUT2(a_Frac[ 0 ][ 0 ],a_Frac[ 0 ][ 1 ],a_Frac[ 0 ][ 2 ],a_Frac[ 0 ][ 3 ],
					 a_Frac[ 1 ][ 0 ],a_Frac[ 1 ][ 1 ],a_Frac[ 1 ][ 2 ],a_Frac[ 1 ][ 3 ],
					 a_Frac[ 2 ][ 0 ],a_Frac[ 2 ][ 1 ],a_Frac[ 2 ][ 2 ],a_Frac[ 2 ][ 3 ],
					 a_Frac[ 3 ][ 0 ],a_Frac[ 3 ][ 1 ],a_Frac[ 3 ][ 2 ],a_Frac[ 3 ][ 3 ],
					 
					 b_INT[ 0 ][ 0 ],b_INT[ 1 ][ 0 ],b_INT[ 2 ][ 0 ],b_INT[ 3 ][ 0 ],
					 b_INT[ 0 ][ 1 ],b_INT[ 1 ][ 1 ],b_INT[ 2 ][ 1 ],b_INT[ 3 ][ 1 ],
					 b_INT[ 0 ][ 2 ],b_INT[ 1 ][ 2 ],b_INT[ 2 ][ 2 ],b_INT[ 3 ][ 2 ],
					 b_INT[ 0 ][ 3 ],b_INT[ 1 ][ 3 ],b_INT[ 2 ][ 3 ],b_INT[ 3 ][ 3 ],
					 
					 c_INT[ 0 ][ 0 ],c_INT[ 1 ][ 0 ],c_INT[ 2 ][ 0 ],c_INT[ 3 ][ 0 ],
					 c_INT[ 0 ][ 1 ],c_INT[ 1 ][ 1 ],c_INT[ 2 ][ 1 ],c_INT[ 3 ][ 1 ],
					 c_INT[ 0 ][ 2 ],c_INT[ 1 ][ 2 ],c_INT[ 2 ][ 2 ],c_INT[ 3 ][ 2 ],
					 c_INT[ 0 ][ 3 ],c_INT[ 1 ][ 3 ],c_INT[ 2 ][ 3 ],c_INT[ 3 ][ 3 ],					 
					 clk,_reset,_flush_acc,
					 result1_Frac2[ 0 ][ 0 ],result1_Frac2[ 0 ][ 1 ],result1_Frac2[ 0 ][ 2 ],result1_Frac2[ 0 ][ 3 ],
					 result1_Frac2[ 1 ][ 0 ],result1_Frac2[ 1 ][ 1 ],result1_Frac2[ 1 ][ 2 ],result1_Frac2[ 1 ][ 3 ],
					 result1_Frac2[ 2 ][ 0 ],result1_Frac2[ 2 ][ 1 ],result1_Frac2[ 2 ][ 2 ],result1_Frac2[ 2 ][ 3 ],
					 result1_Frac2[ 3 ][ 0 ],result1_Frac2[ 3 ][ 1 ],result1_Frac2[ 3 ][ 2 ],result1_Frac2[ 3 ][ 3 ],
					 
					 result2_Frac2[ 0 ][ 0 ],result2_Frac2[ 0 ][ 1 ],result2_Frac2[ 0 ][ 2 ],result2_Frac2[ 0 ][ 3 ],
					 result2_Frac2[ 1 ][ 0 ],result2_Frac2[ 1 ][ 1 ],result2_Frac2[ 1 ][ 2 ],result2_Frac2[ 1 ][ 3 ],
					 result2_Frac2[ 2 ][ 0 ],result2_Frac2[ 2 ][ 1 ],result2_Frac2[ 2 ][ 2 ],result2_Frac2[ 2 ][ 3 ],
					 result2_Frac2[ 3 ][ 0 ],result2_Frac2[ 3 ][ 1 ],result2_Frac2[ 3 ][ 2 ],result2_Frac2[ 3 ][ 3 ],
					 done3);

initial begin
$display("HELLO");
	
	_reset<=1;
	_flush_acc<=1;
	
	$display("Initial begin");
	fd1=$fopen("Matrix1_INT_hex.txt","r");
	fd2=$fopen("Matrix2_INT_hex.txt","r");
	fd3=$fopen("Matrix3_INT_hex.txt","r");
	fd4=$fopen("Matrix1_Frac_hex.txt","r");
	fd5=$fopen("Matrix2_Frac_hex.txt","r");
	fd6=$fopen("Matrix3_Frac_hex.txt","r");
	
	for( i=0; i<4; i=i+1)
	begin
		for( j=0; j<4; j=j+1)
			begin
				temp1=$fscanf(fd1, "%h\n",Matrix1_INT[i][j]);
				temp2=$fscanf(fd2, "%h\n",Matrix2_INT[i][j]);
				temp3=$fscanf(fd3, "%h\n",Matrix3_INT[i][j]);
				temp4=$fscanf(fd4, "%h\n",Matrix1_Frac[i][j]);
				temp5=$fscanf(fd5, "%h\n",Matrix2_Frac[i][j]);
				temp6=$fscanf(fd6, "%h\n",Matrix3_Frac[i][j]);
						
			end
	end
	
	for( m=0; m<4; m=m+1)
	begin
		for( n=0; n<4; n=n+1)
			begin
			a_INT[m][n]=Matrix1_INT[m][n];
			b_INT[m][n]=Matrix2_INT[m][n];
			c_INT[m][n]=Matrix3_INT[m][n];
			a_Frac[m][n]=Matrix1_Frac[m][n];
			b_Frac[m][n]=Matrix2_Frac[m][n];
			c_Frac[m][n]=Matrix3_Frac[m][n];
			
			end
	end
	$fclose(fd1);
	$fclose(fd2);
	$fclose(fd3);
	$fclose(fd4);
	$fclose(fd5);
	$fclose(fd6);
	endofINT_INT_Mat=1;

	
end

initial begin
	clk<=0'b0;
	
	forever begin
		
	#5 clk=~clk;
	end
end

endmodule
