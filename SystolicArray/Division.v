module DivisionUnsigned #(parameter WIDTH=8, FRACTIONAL_BITS=8)(
    // Input and output ports.
    input flag,
    input [2*WIDTH-1:0] A,
    input [2*WIDTH-1:0] B,
    output  [2*WIDTH-1:0] Result//8 bits for the int result, 8 bits for the frcation
   
    
);
	
    // Internal variables
    reg [2*WIDTH-1:0] a1, b1;
    reg [2*WIDTH:0] p1;
    integer i;
	reg [WIDTH-1:0] Res;
	reg [WIDTH-1:0] Reminder;
	reg [FRACTIONAL_BITS-1:0] FractionalPart;
    always @ (A or B or flag)
    begin
        if (flag)
        begin
            // Initialize the variables.
            a1 = A;
            b1 = B;
            p1 = 0;

            for (i = 0; i < (WIDTH + FRACTIONAL_BITS); i = i + 1)
            begin
                p1 = {p1[2*WIDTH-2:0], a1[2*WIDTH-1]};
                a1[2*WIDTH-1:1] = a1[2*WIDTH-2:0];
                p1 = p1 - b1;

                if (p1[2*WIDTH-1] == 1)
                begin
                    a1[0] = 0;
                    p1 = p1 + b1;
                    
                end
                else
                    a1[0] = 1;
            end

            Res = a1;

            // Extract the integer and fractional parts
            Reminder = p1[WIDTH-1:0];
            
            // Calculate the fractional part
            FractionalPart = 0;
            for (i = 0; i < FRACTIONAL_BITS; i = i + 1)
            begin
				$display("**********i*****",i);
				$display("p1 before shifting  %b", p1);
                p1 = p1 << 1; // Shift the remainder left
				$display("p1 after shifting %b", p1);
                if (p1 >= b1)
                begin
                    p1 = p1 - b1;
                    FractionalPart[FRACTIONAL_BITS-1-i] = 1;
					$display(" P1>=b1 FractionalPart %b,   p1 %b             ",FractionalPart,p1);
                end
				else
					begin
					FractionalPart[FRACTIONAL_BITS-1-i] = 0;
					$display("P1<b1 FractionalPart %b,   p1 %b             ",FractionalPart,p1);
					end
				
            end
        end
        else
        begin
            Res = 0;
            Reminder = 0;
            FractionalPart = 0;
        end
    end
	assign Result={Res,FractionalPart};
endmodule
