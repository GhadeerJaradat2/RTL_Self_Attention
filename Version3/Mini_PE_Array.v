/*
This is mini Array Multiplier,
INPUTS: a00,a01,a02,a03,a10,a11,a12,a13 --> represent the rows
b1_00,b1_10,b1_20,b1_30, b1_01,b1_11,b1_21,b1_31--> represent the coloumns.
_reset --> to reset this mini array multiplier, the DUT Will be reseted
enable --> if 0, No change , if 1 it will work as expected

CalImportanceFlag-->if 1, we calculate the Importance. this is only in case of INT x INT


*/


module Mini_PE_Array #(parameter width=8)(
	input clk,_reset,enable,CalImportanceFlag,//intMul if we are doing int multiplication
	input signed [width-1:0] a00,a01,a02,a03,
	input signed [width-1:0] a10,a11,a12,a13,
	input signed [width-1:0] b1_00,b1_10,b1_20,b1_30,
	input signed [width-1:0] b1_01,b1_11,b1_21,b1_31,
	output signed  [2*width-1:0] result0 ,result1,result2,result3,
	output [2*width-1:0] Importance,
	output reg done
	);
	
	//define regs
	reg signed [width-1:0] inp0_north0,inp0_north1;
	wire [width-1:0] out0,out1, out2, out4, out5, out6;
	reg signed [width-1:0] inp_west0, inp_west1;
	reg enable0, enable1, importanceEnable;
	reg [2:0] count;
	reg _PE_reset;// if 0, reset the PE
	//instantiate the DUTs
	PE DUT0(clk,_reset,enable0,inp_west0,inp0_north0,inp0_north1,out0,out1,out2,result0, result1);
	PE DUT1(clk,_reset,enable1,inp_west1,inp0_north0,inp0_north1,out4,out5,out6,result2, result3);
	Importance DUT2(importanceEnable,result0 ,result1,result2,result3,Importance);
	always @(posedge clk or negedge _reset )
	begin
		if(! _reset )
		begin
			count <=0;
			done <=0;
			_PE_reset <= 0;
			importanceEnable<=0;
		end
		
		else if(enable)
		begin
			if(count == 4)
			begin
				done <= 1;
				count <= 0;
				//_PE_reset <= 1;
				if (CalImportanceFlag)
					importanceEnable <=1;
				else
					importanceEnable <=0;
			end
			else
			begin
				done <= 0;
				count <= count + 1;
				//_PE_reset <= 1;
				importanceEnable<=0;
			end
		end
		else
		begin
			count <= 0;
			done <= 0;
			//_PE_reset <= 1;
			importanceEnable<=0;
		end
	end
	
	//--------------------------------------------
	always@ (count)
	begin
		case (count)
		3'b001:
		begin
			enable0 = 1;
			enable1 = 1;
			//-------------------
			inp_west0 = a00;
			inp_west1 = a10;
			//-------------------------
			inp0_north0 = b1_00;
			inp0_north1 = b1_01;
			
		end
		3'b010:
		begin
			enable0 = 1;
			enable1 = 1;
			//--------------
			inp_west0 = a01;
			inp_west1 = a11;
			//-------------------------
			inp0_north0 = b1_10;
			inp0_north1 = b1_11;
			
		end
		3'b011:
		begin
			enable0 = 1;
			enable1 = 1;
			//--------------
			inp_west0 = a02;
			inp_west1 = a12;
			//-------------------------
			inp0_north0 = b1_20;
			inp0_north1 = b1_21;
			
		end
		4'b0100:
		begin
			enable0 = 1;
			enable1 = 1;
			//--------------
			inp_west0 = a03;
			inp_west1 = a13;
			//-------------------------
			inp0_north0 = b1_30;
			inp0_north1 = b1_31;
			
		end
		default:
		begin
			enable0 = 0;
			enable1 = 0;
		end
		endcase
		
	end
endmodule

