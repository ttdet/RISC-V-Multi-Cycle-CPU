module Mux_2Input(
	input[15:0] a,
	input[15:0] b,
	input ctrl,
	
	output reg[15:0] out
);

always @(a, b, ctrl) begin
	if (ctrl == 0) begin
		out = a;
	end 
	else begin
		out = b;
	end
	
end

endmodule