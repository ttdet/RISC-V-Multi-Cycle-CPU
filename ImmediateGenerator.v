module ImmediateGenerator (
    input signed [10:0] cin,
	input[4:0] sin,
    input Select,
    output reg[15:0] imm
);

always @(sin or cin or Select) begin
    if (Select == 0) begin
        imm = sin;
    end else begin
        imm = cin;

    end
end

endmodule