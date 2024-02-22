module DivisionUnsigned_TB;
    parameter WIDTH = 8;
    parameter FRACTIONAL_BITS = 8;

    // Inputs
    reg [2*WIDTH-1:0] A;
    reg [2*WIDTH-1:0] B;
    reg f = 1; // Corrected to reg

    // Outputs
    wire [2*WIDTH-1:0] Result;
    wire [WIDTH-1:0] Rem;
	wire [WIDTH-1:0] frac;
    // Instantiate the division module (UUT)
    DivisionUnsigned #(WIDTH, FRACTIONAL_BITS) uut (
        .flag(f),
        .A(A),
        .B(B),
        .Result(Result)
    );

    initial begin
        // Initialize Inputs and wait for 100 ns
       // A = 0; B = 0; #100; // Undefined inputs
        // Apply each set of inputs and wait for 100 ns.
        A = 119; B = 10; #50;
        A = 211; B = 40; #50;
        A = 91; B = 9; #50;
        A = 71; B = 10; #100;
        A = 16; B = 3; #100;
        A = 255; B = 11; #100;
		A = 1; B = 4; #2;
    end
endmodule
