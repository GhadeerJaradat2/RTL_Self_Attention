

/*
Prpcessing Element (PE),
clk, active low reset: outputs=0, accumulators=0
enable, active high: if 1--> outputs= inputs , accummelators works
					 if 0--> outputs=outputs, acc=acc, NO change





*/



module PE #(parameter width=8)(
	input clk,_rst,enable,
	input signed [width-1:0] in_left,in_above1,in_above2,
	output  reg signed [width-1:0] out_bottom1=0,out_bottom2=0,out_right=0,
	output  reg signed [2*width-1:0] acc1=0,acc2=0
	);
	always @(posedge clk or negedge _rst)
	begin
		if (!_rst)
			begin
				out_bottom1 <='b0;
				out_bottom2 <= 'b0;
				out_right <='b0;
				acc1 <='b0;
				acc2 <= 'b0;
			end
		else 
		begin
			if(!enable)
				begin
					out_bottom1 <= out_bottom1;
					out_bottom2 <= out_bottom2;
					out_right <= out_right;
					acc1 <= acc1;
					acc2 <= acc2;
				end
			else
				begin
					out_bottom1 <= in_above1;
					out_bottom2 <= in_above2;
					out_right <= in_left;
					
						acc1 <= acc1+ in_left*in_above1;
						acc2 <= acc2+ in_left*in_above2;
				
				
				end
		end
	end
	
endmodule
	