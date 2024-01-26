`timescale 1ns/1ns
`define width 8
module arrayMean_TB();
	reg enable;//to add elements
	reg comapre_flag;//indicate that int*int matrices ended, to comape with threshold
	reg signed [2*`width-1:0] result1_INT_00,result1_INT_01 ,result1_INT_02 ,result1_INT_03;
	reg signed [2*`width-1:0] result1_INT_10,result1_INT_11 ,result1_INT_12 ,result1_INT_13;
	reg signed [2*`width-1:0] result1_INT_20,result1_INT_21 ,result1_INT_22 ,result1_INT_23;
	reg signed [2*`width-1:0] result1_INT_30,result1_INT_31 ,result1_INT_32 ,result1_INT_33;
	
	reg signed [2*`width-1:0] result2_INT_00,result2_INT_01 ,result2_INT_02 ,result2_INT_03;
	reg signed [2*`width-1:0] result2_INT_10,result2_INT_11 ,result2_INT_12 ,result2_INT_13;
	reg signed [2*`width-1:0] result2_INT_20,result2_INT_21 ,result2_INT_22 ,result2_INT_23;
	reg signed [2*`width-1:0] result2_INT_30,result2_INT_31 ,result2_INT_32 ,result2_INT_33;
	reg clk,_reset;
		
	wire   PruneHead;
//----------------------------------------------------------
arrayMean dut_mean( enable,
					comapre_flag,
					result1_INT_00,result1_INT_01 ,result1_INT_02 ,result1_INT_03,
					result1_INT_10,result1_INT_11 ,result1_INT_12 ,result1_INT_13,
					result1_INT_20,result1_INT_21 ,result1_INT_22 ,result1_INT_23,
					result1_INT_30,result1_INT_31 ,result1_INT_32 ,result1_INT_33,
	
					result2_INT_00,result2_INT_01 ,result2_INT_02 ,result2_INT_03,
					result2_INT_10,result2_INT_11 ,result2_INT_12 ,result2_INT_13,
					result2_INT_20,result2_INT_21 ,result2_INT_22 ,result2_INT_23,
					result2_INT_30,result2_INT_31 ,result2_INT_32 ,result2_INT_33,
					clk,_reset,
					headPrune					 
				   );
integer fd1,fd2,fd3,fd4,fd5,temp1,temp2,temp3,temp4,temp5,i,j,fd_out1,fd_out2,flag=0;
reg signed [`width-1:0]  Matrix2[0:3][0:3];
reg signed [`width-1:0]  Matrix3[0:3][0:3];

initial 
begin
$display("HELLO");
	
	_reset<=0;
	enable <=0;
	comapre_flag<=0;
	#10
	_reset<=1;
	$display("Initial begin");
	
	fd2=$fopen("Matrix2_INT_hex.txt","r");
	fd3=$fopen("Matrix3_INT_hex.txt","r");
	
	
	for( i=0; i<4; i=i+1)
	begin
		for( j=0; j<4; j=j+1)
			begin
				
				temp2=$fscanf(fd2, "%h\n",Matrix2[i][j]);
				temp3=$fscanf(fd3, "%h\n",Matrix3[i][j]);
				
						
			end
	end
	$fclose(fd2);
	$fclose(fd3);

					
	result1_INT_00<=Matrix2[0][0];
	result1_INT_01<=Matrix2[1][0];
	result1_INT_02<=Matrix2[2][0];
	result1_INT_03<=Matrix2[3][0];
	//----------------
	result1_INT_10<=Matrix2[0][1];
	result1_INT_11<=Matrix2[1][1];
	result1_INT_12<=Matrix2[2][1];
	result1_INT_13<=Matrix2[3][1];
	//--------------
	result1_INT_20<=Matrix2[0][2];
	result1_INT_21<=Matrix2[1][2];
	result1_INT_22<=Matrix2[2][2];
	result1_INT_23<=Matrix2[3][2];
	//-----------------
	result1_INT_30<=Matrix2[0][3];
	result1_INT_31<=Matrix2[1][3];
	result1_INT_32<=Matrix2[2][3];
	result1_INT_33<=Matrix2[3][3];

	result2_INT_00<=Matrix3[0][0];
	result2_INT_01<=Matrix3[1][0];
	result2_INT_02<=Matrix3[2][0];
	result2_INT_03<=Matrix3[3][0];
	//-----------
	result2_INT_10<=Matrix3[0][1];
	result2_INT_11<=Matrix3[1][1];
	result2_INT_12<=Matrix3[2][1];
	result2_INT_13<=Matrix3[3][1];
	//-----------

	result2_INT_20<=Matrix3[0][2];
	result2_INT_21<=Matrix3[1][2];
	result2_INT_22<=Matrix3[2][2];
	result2_INT_23<=Matrix3[3][2];
	//---------------
	result2_INT_30<=Matrix3[0][3];
	result2_INT_31<=Matrix3[1][3];
	result2_INT_32<=Matrix3[2][3];
	result2_INT_33<=Matrix3[3][3];
	//------------------------------------
	#5 
		enable <=1;
	comapre_flag<=1;
	#20
	_reset<=0;
	enable <=0;
	comapre_flag<=0;
	#20
	_reset<=1;
		enable <=1;
	comapre_flag<=1;
	result1_INT_00<=50;
	result1_INT_01<=50;
	result1_INT_02<=50;
	result1_INT_03<=50;
	//----------------
	result1_INT_10<=50;
	result1_INT_11<=50;
	result1_INT_12<=Matrix2[2][1];
	result1_INT_13<=Matrix2[3][1];
	//--------------
	result1_INT_20<=50;
	result1_INT_21<=50;
	result1_INT_22<=Matrix2[2][2];
	result1_INT_23<=50;
	//-----------------
	result1_INT_30<=Matrix2[0][3];
	result1_INT_31<=Matrix2[1][3];
	result1_INT_32<=Matrix2[2][3];
	result1_INT_33<=Matrix2[3][3];

	result2_INT_00<=Matrix3[0][0];
	result2_INT_01<=Matrix3[1][0];
	result2_INT_02<=Matrix3[2][0];
	result2_INT_03<=Matrix3[3][0];
	//-----------
	result2_INT_10<=50;
	result2_INT_11<=50;
	result2_INT_12<=50;
	result2_INT_13<=50;
	//-----------

	result2_INT_20<=50;
	result2_INT_21<=Matrix3[1][2];
	result2_INT_22<=50;
	result2_INT_23<=Matrix3[3][2];
	//---------------
	result2_INT_30<=50;
	result2_INT_31<=Matrix3[1][3];
	result2_INT_32<=50;
	result2_INT_33<=50;
	
end
initial begin
	clk<=0'b0;
	
	forever begin
		
	#5 clk=~clk;

end
end
endmodule
