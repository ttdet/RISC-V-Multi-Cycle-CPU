`timescale 1ns / 1ps

module Register (
    input[15:0] D,
    input CLK,
	input RST,
    input WRT,
    output reg[15:0] Q
);

always @(posedge CLK) begin
    if (RST == 1) begin
        Q = 0;
    end else begin
        if (WRT == 1) begin
            Q = D;
        end
    end
end

endmodule