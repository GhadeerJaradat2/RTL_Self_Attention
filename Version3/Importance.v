module Importance #(parameter width=8)(
	input  Enable,
	input signed  [2*width-1:0] result0 ,result1,result2,result3,
	output reg [2*width-1:0] importance

);
reg [2*width-1:0] result0_abs ,result1_abs,result2_abs,result3_abs;
always @(Enable,result0 ,result1,result2,result3)
begin
	if(Enable)
	begin
	result0_abs = result0[2*width-1] ? -result0 : result0; // absolute
	result1_abs = result1[2*width-1] ? -result1 : result1;
	result2_abs = result2[2*width-1] ? -result2 : result2;
	result3_abs = result3[2*width-1] ? -result3 : result3;
	importance = result0_abs + result1_abs + result2_abs + result3_abs;
	end


end





endmodule

