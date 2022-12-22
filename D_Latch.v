module D_Latch (
   input[15:0] D,
   input CLK,
	input RST,
   input WRT,
	output reg[15:0] Q
);

always @(CLK, D, RST) begin
    if (RST) begin
		Q <= 0; 
	 end else begin
		if (CLK && WRT) 
			Q <= D; 
	 end
end

endmodule