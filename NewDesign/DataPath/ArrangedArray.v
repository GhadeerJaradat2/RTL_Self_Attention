module ArrangeArray #(parameter width=8, FRACTIONAL_BITS=8)(
	input clk,_resetPE,_resetRow,_resetHead,
	input [7:0] enables,
	input addFlag,// flag to indicate if an adition is placed or not
	input lastTileFlag,//flag to indicate the one row one col input finished.
	input endOfRowFlag,//flag to indicate one row and all cols to generate one row output
	input endOfHeadFlag,//Finish the hole array
	input [2*width-1:0] headThreshold,
	input [2:0] blockPruningRatio,
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
	input signed [width-1:0] b2_03,b2_13,b2_23,b2_33 ,
	
	input signed [width-1:0] c1_00,c1_10,c1_20,c1_30,
	input signed [width-1:0] c1_01,c1_11,c1_21,c1_31,
	input signed [width-1:0] c1_02,c1_12,c1_22,c1_32,
	input signed [width-1:0] c1_03,c1_13,c1_23,c1_33,//cols of the input matrix C1
	
	input signed [width-1:0] c2_00,c2_10,c2_20,c2_30,
	input signed [width-1:0] c2_01,c2_11,c2_21,c2_31,
	input signed [width-1:0] c2_02,c2_12,c2_22,c2_32,
	input signed [width-1:0] c2_03,c2_13,c2_23,c2_33,//cols of the input matrix C2
	
	input signed [2*width-1:0] integerRes0,integerRes1,integerRes2,integerRes3,
	input signed [2*width-1:0] integerRes4,integerRes5,integerRes6,integerRes7,
	input signed [2*width-1:0] integerRes8,integerRes9,integerRes10,integerRes11,
	input signed [2*width-1:0] integerRes12,integerRes13,integerRes14,integerRes15,
	
	
	
	output reg signed [2*width-1:0] result0 ,result1,result2,result3 ,
	output reg signed [2*width-1:0] result4,result5,result6,result7,
	output reg signed [2*width-1:0] result8,result9,result10,result11,
	output reg signed [2*width-1:0] result12,result13,result14,result15,
	
	output reg signed [2*width-1:0] result2_0 ,result2_1,result2_2,result2_3,
	output reg signed [2*width-1:0] result2_4,result2_5,result2_6,result2_7,
	output reg signed [2*width-1:0] result2_8,result2_9,result2_10,result2_11,
	output reg signed [2*width-1:0] result2_12,result2_13,result2_14,result2_15, 
	
	output reg [511:0] Mask0,Mask1,
	
	output reg pruneHead,
	output  done

);
reg ThresholdCalcFlag=0;
wire calcImportanceFlag;

wire [7:0] doneFlags;
reg [2*width-1:0] sumRow0=0,sumRow1=0, sumHead=0;
reg [2*width-1:0] row_0_Min=1000, row_0_Max=0, row_1_Min=1000, row_1_Max=0;
wire [2*width-1:0] importance0,importance1,importance2,importance3,importance4,importance5,importance6,importance7;
integer i,TN=0;
reg [2*width-1:0] noOfTiles=0,s1=0,s2=0;
localparam [9:0] storageLength=512;
reg [2*width-1:0] ImportanceStorage0 [0:storageLength-1];
reg [2*width-1:0] ImportanceStorage1 [0:storageLength-1];
reg startMaskClaculate=0;


assign done = |doneFlags;
assign calcImportanceFlag = !addFlag & lastTileFlag;


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------
//always block to determine the verical inputs and the outputs to the mini SysArray DUTS, it depends on the addFlag

reg [width-1:0] Dut2_col0 [0:3];
reg [width-1:0] Dut2_col1 [0:3];
reg [width-1:0] Dut3_col0 [0:3];
reg [width-1:0] Dut3_col1 [0:3];
reg [width-1:0] Dut6_col0 [0:3];
reg [width-1:0] Dut6_col1 [0:3];
reg [width-1:0] Dut7_col0 [0:3];
reg [width-1:0] Dut7_col1 [0:3];
wire [2*width-1:0] intermidiateRes0 [0:15];
wire [2*width-1:0] intermidiateRes1 [0:15];
wire [2*width-1:0] additionResult [0:15];
always@(addFlag)
begin
	if (!addFlag)
	begin
		
		Dut2_col0[0] =  b1_00; Dut2_col0[1] =  b1_10; Dut2_col0[2] =  b1_20; Dut2_col0[3] =  b1_30;
		Dut2_col1[0] =  b1_01; Dut2_col1[1] =  b1_11; Dut2_col1[2] =  b1_21; Dut2_col1[3] =  b1_31;
		Dut3_col0[0] =  b1_02; Dut3_col0[1] =  b1_12; Dut3_col0[2] =  b1_22; Dut3_col0[3] =  b1_32;   
		Dut3_col1[0] =  b1_03; Dut3_col1[1] =  b1_13; Dut3_col1[2] =  b1_23; Dut3_col1[3] =  b1_33;
		
		Dut6_col0[0] =  b2_00; Dut6_col0[1] =  b2_10; Dut6_col0[2] =  b2_20; Dut6_col0[3] =  b2_30;
		Dut6_col1[0] =  b2_01; Dut6_col1[1] =  b2_11; Dut6_col1[2] =  b2_21; Dut6_col1[3] =  b2_31;
		Dut7_col0[0] =  b2_02; Dut7_col0[1] =  b2_12; Dut7_col0[2] =  b2_22; Dut7_col0[3] =  b2_32;
		Dut7_col1[0] =  b2_03; Dut7_col1[1] =  b2_13; Dut7_col1[2] =  b2_23; Dut7_col1[3] =  b2_33;
		
	end
	else
	begin
		
		Dut2_col0[0] =  c1_00; Dut2_col0[1] =  c1_10; Dut2_col0[2] =  c1_20; Dut2_col0[3] =  c1_30;
		Dut2_col1[0] =  c1_01; Dut2_col1[1] =  c1_11; Dut2_col1[2] =  c1_21; Dut2_col1[3] =  c1_31;
		Dut3_col0[0] =  c1_02; Dut3_col0[1] =  c1_12; Dut3_col0[2] =  c1_22; Dut3_col0[3] =  c1_32;
		Dut3_col1[0] =  c1_03; Dut3_col1[1] =  c1_13; Dut3_col1[2] =  c1_23; Dut3_col1[3] =  c1_33;
		 
		Dut6_col0[0] =  c2_00; Dut6_col0[1] =  c2_10; Dut6_col0[2] =  c2_20; Dut6_col0[3] =  c2_30;
		Dut6_col1[0] =  c2_01; Dut6_col1[1] =  c2_11; Dut6_col1[2] =  c2_21; Dut6_col1[3] =  c2_31;
		Dut7_col0[0] =  c2_02; Dut7_col0[1] =  c2_12; Dut7_col0[2] =  c2_22; Dut7_col0[3] =  c2_32;
		Dut7_col1[0] =  c2_03; Dut7_col1[1] =  c2_13; Dut7_col1[2] =  c2_23; Dut7_col1[3] =  c2_33;
	end

end
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
//always to set the output result
always@(intermidiateRes0,intermidiateRes1,additionResult)
begin
		//if add flag then the result equals the output of the adder, otherwise it will equal the output of the miniArray DUTS
		if (addFlag)
		begin
			 result0 <= additionResult[0] ;
			 result1 <= additionResult[1] ;
			 result2 <= additionResult[2] ;
			 result3 <= additionResult[3] ;
			 result4 <= additionResult[4] ;
			 result5 <= additionResult[5] ;
			 result6 <= additionResult[6] ;
			 result7 <= additionResult[7] ;
			 result8 <= additionResult[8] ;
			 result9 <= additionResult[9] ;
			 result10 <= additionResult[10] ;
			 result11 <= additionResult[11] ;
			 result12 <= additionResult[12] ;
			 result13 <= additionResult[13] ;
			 result14 <= additionResult[14] ;
			 result15 <= additionResult[15] ;
			
			 result2_0 <= 'b0;
			 result2_1 <= 'b0;
			 result2_2 <= 'b0;
			 result2_3 <= 'b0;
			 result2_4 <= 'b0;
			 result2_5 <= 'b0;
			 result2_6 <= 'b0;
			 result2_7 <= 'b0;
			 result2_8 <= 'b0;
			 result2_9 <= 'b0;
			 result2_10 <= 'b0;
			 result2_11 <= 'b0;
			 result2_12 <= 'b0;
			 result2_13 <= 'b0;
			 result2_14 <= 'b0;
			 result2_15 <= 'b0;
		end
		else
		begin
		 
			 result0 <= intermidiateRes0[0] ;
			 result1 <= intermidiateRes0[1] ;
			 result2 <= intermidiateRes0[2] ;
			 result3 <= intermidiateRes0[3] ;
			 result4 <= intermidiateRes0[4] ;
			 result5 <= intermidiateRes0[5] ;
			 result6 <= intermidiateRes0[6] ;
			 result7 <= intermidiateRes0[7] ;
			 result8 <= intermidiateRes0[8] ;
			 result9 <= intermidiateRes0[9] ;
			 result10 <= intermidiateRes0[10] ;
			 result11 <= intermidiateRes0[11] ;
			 result12 <= intermidiateRes0[12] ;
			 result13 <= intermidiateRes0[13] ;
			 result14 <= intermidiateRes0[14] ;
			 result15 <= intermidiateRes0[15] ;
			
			 result2_0 <= intermidiateRes1[0];
			 result2_1 <= intermidiateRes1[1];
			 result2_2 <= intermidiateRes1[2];
			 result2_3 <= intermidiateRes1[3];
			 result2_4 <= intermidiateRes1[4];
			 result2_5 <= intermidiateRes1[5];
			 result2_6 <= intermidiateRes1[6];
			 result2_7 <= intermidiateRes1[7];
			 result2_8 <= intermidiateRes1[8];
			 result2_9 <= intermidiateRes1[9];
			 result2_10 <= intermidiateRes1[10];
			 result2_11 <= intermidiateRes1[11];
			 result2_12 <= intermidiateRes1[12];
			 result2_13 <= intermidiateRes1[13];
			 result2_14 <= intermidiateRes1[14];
			 result2_15 <= intermidiateRes1[15];
		end
end

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
wire [7:0] dutEnable;
genvar j;
//The PE will work if the are enabled and we don't want to calculate the MASK

generate
for (j=0;j<8;j=j+1)
begin
	assign dutEnable[j] = enables[j] & (!(ThresholdCalcFlag|startMaskClaculate));
end
endgenerate
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Initialize the memory to 0
initial 
begin
	for (i = 0; i <= storageLength-1; i = i+1)
	begin
	
		ImportanceStorage0[i] =	0 ;
		ImportanceStorage1[i] = 0 ;
	
	end
end
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
wire AdditionFlag;

assign AdditionFlag = done & addFlag ;
//Adder DUT
Adder #( width) add( clk,_resetPE, AdditionFlag,
					integerRes0,integerRes1,integerRes2,integerRes3,integerRes4,integerRes5,integerRes6,integerRes7,
					integerRes8,integerRes9,integerRes10,integerRes11,integerRes12,integerRes13,integerRes14,integerRes15,
					
					intermidiateRes0[0],intermidiateRes0[1],intermidiateRes0[2],intermidiateRes0[3],
					intermidiateRes0[4],intermidiateRes0[5],intermidiateRes0[6],intermidiateRes0[7],
					intermidiateRes1[0],intermidiateRes1[1],intermidiateRes1[2],intermidiateRes1[3],
					intermidiateRes1[4],intermidiateRes1[5],intermidiateRes1[6],intermidiateRes1[7],
					
					intermidiateRes0[8],intermidiateRes0[9],intermidiateRes0[10],intermidiateRes0[11],
					intermidiateRes0[12],intermidiateRes0[13],intermidiateRes0[14],intermidiateRes0[15],
					intermidiateRes1[8],intermidiateRes1[9],intermidiateRes1[10],intermidiateRes1[11],
					intermidiateRes1[12],intermidiateRes1[13],intermidiateRes1[14],intermidiateRes1[15],
					
					additionResult[0],additionResult[1],additionResult[2],additionResult[3],
					additionResult[4],additionResult[5],additionResult[6],additionResult[7],
					additionResult[8],additionResult[9],additionResult[10],additionResult[11],
					additionResult[12],additionResult[13],additionResult[14],additionResult[15]	
	);
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
//DUTS 
mini_SysArray DUT0(clk,_resetPE,dutEnable[0],calcImportanceFlag,a00,a01,a02,a03,a10,a11,a12,a13,
					b1_00,b1_10,b1_20,b1_30, b1_01,b1_11,b1_21,b1_31,intermidiateRes0[0] ,intermidiateRes0[1],intermidiateRes0[4],intermidiateRes0[5],importance0,doneFlags[0]);


mini_SysArray DUT1(clk,_resetPE,dutEnable[1],calcImportanceFlag,a00,a01,a02,a03,a10,a11,a12,a13,b1_02,b1_12,b1_22,
					b1_32, b1_03,b1_13,b1_23,b1_33,intermidiateRes0[2] ,intermidiateRes0[3],intermidiateRes0[6],intermidiateRes0[7],importance1,doneFlags[1]);


mini_SysArray DUT2(clk,_resetPE,dutEnable[2],calcImportanceFlag,a20,a21,a22,a23,a30,a31,a32,a33,Dut2_col0[0],Dut2_col0[1],Dut2_col0[2],
					Dut2_col0[3], Dut2_col1[0],Dut2_col1[1],Dut2_col1[2],Dut2_col1[3],intermidiateRes0[8] ,intermidiateRes0[9],intermidiateRes0[12],intermidiateRes0[13],importance4,doneFlags[2]);


mini_SysArray DUT3(clk,_resetPE,dutEnable[3],calcImportanceFlag,a20,a21,a22,a23,a30,a31,a32,a33,Dut3_col0[0],Dut3_col0[1],Dut3_col0[2],
					Dut3_col0[3],Dut3_col1[0],Dut3_col1[1],Dut3_col1[2],Dut3_col1[3],intermidiateRes0[10] ,intermidiateRes0[11],intermidiateRes0[14],intermidiateRes0[15],importance5,doneFlags[3]);

//----------------------------------------------------------------------


mini_SysArray DUT4(clk,_resetPE,dutEnable[4],calcImportanceFlag, a00,a01,a02,a03,a10,a11,a12,a13,b2_00,b2_10,b2_20,
					b2_30, b2_01,b2_11,b2_21,b2_31,intermidiateRes1[0] ,intermidiateRes1[1],intermidiateRes1[4],intermidiateRes1[5],importance2,doneFlags[4]);


mini_SysArray DUT5(clk,_resetPE,dutEnable[5],calcImportanceFlag, a00,a01,a02,a03,a10,a11,a12,a13,b2_02,b2_12,b2_22,
					b2_32, b2_03,b2_13,b2_23,b2_33,intermidiateRes1[2] ,intermidiateRes1[3],intermidiateRes1[6],intermidiateRes1[7],importance3,doneFlags[5]);

mini_SysArray DUT6(clk,_resetPE,dutEnable[6],calcImportanceFlag, a20,a21,a22,a23,a30,a31,a32,a33,Dut6_col0[0],Dut6_col0[1],Dut6_col0[2],
					Dut6_col0[3], Dut6_col1[0],Dut6_col1[1],Dut6_col1[2],Dut6_col1[3],intermidiateRes1[8] ,intermidiateRes1[9],intermidiateRes1[12],intermidiateRes1[13],importance6,doneFlags[6]);


mini_SysArray DUT7(clk,_resetPE,dutEnable[7],calcImportanceFlag, a20,a21,a22,a23,a30,a31,a32,a33,Dut7_col0[0],Dut7_col0[1],Dut7_col0[2],
					Dut7_col0[3], Dut7_col1[0],Dut7_col1[1],Dut7_col1[2],Dut7_col1[3],intermidiateRes1[10] ,intermidiateRes1[11],intermidiateRes1[14],intermidiateRes1[15],importance7,doneFlags[7]);

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
//always block to do the reset and store the importance.
always @(posedge clk or negedge _resetRow or negedge _resetHead)
begin
	if (! _resetHead)
	begin
		sumHead <= 0;
		
	end
	if(!_resetRow)
	begin
		sumRow0 <= 0;
		sumRow1 <= 0;
		for (i = 0; i <= storageLength-1; i = i+1)
		begin
				ImportanceStorage0[i] <= 0	;
				ImportanceStorage1[i] <= 0	;
				
		end

		row_0_Min <= 99;
		row_0_Max <= 0;
		row_1_Min <= 99;
		row_1_Max <= 0;
		noOfTiles <= 0;
		ThresholdCalcFlag<=0;
		TN <=0;
		Mask0<=1;
		Mask1<=1;
	end
	
	else
	begin

		
		if(done & calcImportanceFlag)
		begin
			s1 <=  importance0 + importance1 + importance2 + importance3;
			s2 <=  importance4 + importance5 + importance6 + importance7;
			ImportanceStorage0[noOfTiles] <= importance0;
			ImportanceStorage1[noOfTiles] <= importance4;
			
			ImportanceStorage0[noOfTiles+1] <= importance1;
			ImportanceStorage1[noOfTiles+1] <= importance5;
			
			ImportanceStorage0[noOfTiles+2] <= importance2;
			ImportanceStorage1[noOfTiles+2] <= importance6;
			
			ImportanceStorage0[noOfTiles+3] <= importance3;			
			ImportanceStorage1[noOfTiles+3] <= importance7;
			
			noOfTiles <= noOfTiles + 4;
			TN <=TN+4;
			if(endOfRowFlag)
			begin
				
				ThresholdCalcFlag <= 1;
			end
			else
				ThresholdCalcFlag <= 0;
		
		end
		else
			ThresholdCalcFlag <= 0;
		
	
	
	end

end

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------

wire [2*width-1:0] threshold0, threshold1;


//at the end of the row find the thresholds 

BlockThresholdCalculator #(width) uut( ThresholdCalcFlag, noOfTiles,row_0_Min,row_0_Max,sumRow0,row_1_Min,row_1_Max,sumRow1, blockPruningRatio, threshold0, threshold1);

integer iterator0=0,iterator1=0;
reg  [2*width-1:0] temp0 [0:15];
reg  [2*width-1:0] temp1 [0:15];
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
//2- always block to find the MASK
always @(posedge clk)
begin
	if(ThresholdCalcFlag|startMaskClaculate)
	begin
		
		startMaskClaculate <= 1;
		for (i=0;i<=15;i=i+1)
		begin
			temp0[i] <= ImportanceStorage0[iterator0+i] - threshold0	;
			temp1[i] <= ImportanceStorage1[iterator0+i] - threshold1	;
			
		end
		iterator0 <= iterator0+16;
		if(iterator0 >= storageLength-1) 
		begin
			iterator0<=0;
			startMaskClaculate <= 0;
			
		end	
		
	end
end
always @(posedge clk)
begin
	
	if(startMaskClaculate)
	begin
		
		for (i=0;i<=15;i=i+1)
		begin
			
			if (temp0[i][2*width-1]==1)
				Mask0[iterator1+i] <= 0;
			else
				Mask0[iterator1+i] <= 1;
			//----------------------------
			if (temp1[i][2*width-1]==1)
				Mask1[iterator1+i] <= 0;
			else
				Mask1[iterator1+i] <= 1;
			
		end
		iterator1 <= iterator1+16;
		if(iterator1 >= storageLength-1) 
		begin
			iterator1 <= 0;
			
			
		end			
		
		
	end
end
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
//always block to sum for each row, head sum and if we will prune this head or not.
always @(s1,s2)
begin
	sumHead =  sumHead + s1 + s2;
	sumRow0 =  sumRow0 + s1;
	sumRow1 = sumRow1 + s2;
	if(endOfHeadFlag)
	begin
		if(sumHead <= headThreshold)
			pruneHead = 1;
		else
			pruneHead = 0;
	end
	else
		pruneHead = 0;
end
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
//always block to find Min,Max for the row
always @(done)
begin
	
	if(calcImportanceFlag) // if int x int multiplication happen
	begin
		
		
		// find min, max for row0 and row 1
		if(row_0_Min > importance0)
			row_0_Min = importance0;
		if ( row_0_Min > importance1 )
			row_0_Min = importance1 ;
		if ( row_0_Min > importance2 )
			row_0_Min = importance2 ;
		if ( row_0_Min > importance3 )
			row_0_Min = importance3 ;
		//---------------------------------	
		if(row_0_Max < importance0)
			row_0_Max = importance0;
		if ( row_0_Max < importance1 )
			row_0_Max = importance1 ;
		if ( row_0_Max < importance2 )
			row_0_Max = importance2 ;
		if ( row_0_Max < importance3 )
			row_0_Max = importance3 ;	
		//-----------------------------
		if(row_1_Min > importance4)
			row_1_Min = importance4;
		if ( row_1_Min > importance5 )
			row_1_Min = importance5 ;
		if ( row_1_Min > importance6 )
			row_1_Min = importance6 ;
		if ( row_1_Min > importance7 )
			row_1_Min = importance7 ;
		//---------------------------------	
		if(row_1_Max < importance4)
			row_1_Max = importance4;
		if ( row_1_Max < importance5 )
			row_1_Max = importance5 ;
		if ( row_1_Max < importance6 )
			row_1_Max = importance6 ;
		if ( row_1_Max < importance7 )
			row_1_Max = importance7 ;		
	//-----------------------------------------------
		
	
		
		
	end
end
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
//always block to find the ADDition if addFlag is 1
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------
endmodule
