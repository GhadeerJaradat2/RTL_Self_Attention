`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//output is 18 bit: 2 integers, 16 fractions
//input is 10.0, 10 nits for intger. 0 bits for fraction.
// 
//////////////////////////////////////////////////////////////////////////////////


module Reciprocal_Integer#(
		parameter integer BITWIDTH1 = 10,
		parameter integer BITWIDTH2 = 18		)       // bit width )
		(enb,x1,y);
input signed [BITWIDTH1-1:0] x1; // 10.0 ==>  10 int
input enb;


output reg signed [BITWIDTH2-1:0] y; // 8.8

reg signed  [17:0] c0,c1,c00,c01,c10,c11,c20,c21,c30,c31,c40,c41,c50,c51; // 16 bit freq 2.16

reg signed [27:0] y_temp,y_temp2;
reg signed [17:0] y_temp3; // 2.16
reg x1_or;
always@* begin
    if(enb) begin
    
// -743	14055
// -364	9798
// -177	6853
// -88	4813
// -31	2917
// -1	687
    
    
c01= -743;	   //// 1:2
c00= 14055;

c11=-364	;   /// 2:4
c10= 9798;

c21=-177	;    // 4:8
c20=6853;

c31=-88	;  /// 8:16
c30=4813;

c41=-31	;   /// 16 to end
c40=2917;


c51=-1	;   /// 16 to end
c50=687;


casex (x1[9:2])

8'b00000010: begin c0=c00;
               c1=c01;
         end
8'b00000011: begin c0=c10;
               c1=c11;
         end
8'b0000010X: begin c0=c20;
               c1=c21;
         end
8'b0000011X: begin c0=c30;
               c1=c31;
         end
8'b00001XXX: begin c0=c40;
               c1=c41;
         end         
         
default: begin c0=c50;
               c1=c51;
         end
endcase 
      
y_temp=c1*x1; // 2.16 *10.0=12.16

y_temp2=y_temp+{{10{c0[9]}},c0}; // 2.16+12.16

case (x1[2:0])
// 65536	32768	21845	16384	13107	10923	9362
3'b001:y_temp3=65536; 
3'b010: y_temp3=32768; 
3'b011:y_temp3=21845; 
3'b100: y_temp3=16384; 
3'b101:y_temp3=13107; 
3'b110:y_temp3=10923; 
3'b111:y_temp3=9362; 
endcase 
  x1_or=x1[9]|x1[8]| x1[7]|x1[6]|x1[5]|x1[4]|x1[3];
case (x1_or)
1'b0:y=y_temp3[17:0]; 
1'b1:y=y_temp2[15:0]; 
endcase
     
    end
    else begin
    y=0;
    end

end


endmodule
