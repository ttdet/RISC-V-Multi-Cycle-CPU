module ALU(
	input signed[15:0] A,
	input signed[15:0] B,
	input[2:0] OP,
	output reg signed[15:0] ALUOut,
	output reg ZERODETECT
);

always @(A, B, OP) begin
	if (OP == 0)
		ALUOut = A + B;
	else if (OP == 1)
		ALUOut = A - B;
	else if (OP == 2)
		ALUOut = A << B;
	else if (OP == 3)
		ALUOut = A >> B;
	else if (OP == 4)
		ALUOut = A | B;
	else if (OP == 5)
		ALUOut = A & B;
		
	if (ALUOut == 0)
		ZERODETECT = 1;
	else
		ZERODETECT = 0;
end

endmodule