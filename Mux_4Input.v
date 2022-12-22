module Mux_4Input(
	input[15:0] a,
	input[15:0] b,
	input[15:0] c,
	input[15:0] d,
	input[1:0] ctrl,
	
	output reg[15:0] out
);

always @(a, b, c, d, ctrl) begin
	if (ctrl == 0) begin
		out = a;
	end 
	else if (ctrl == 1) begin
		out = b;
	end 
	else if (ctrl == 2) begin
		out = c;
	end 
	else begin
		out = d;
	end
	
end

endmodule