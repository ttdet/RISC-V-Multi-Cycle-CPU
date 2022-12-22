module Mux_2Input_tb();

//Inputs
reg[15:0] first;
reg[15:0] second;

reg control;

//Outputs
wire [15:0] muxOut;

//Instantiate the mux
Mux_2Input UUT(
	.a(first),
	.b(second),
	.ctrl(control),
	.out(muxOut)
);

initial begin
	first = 1;
	second = 0;
	control = 0;
	
	#100;
	
	//sanity checks
	repeat(16) begin
		#50
		if(muxOut == first) begin
			$display("input 1: PASS");
		end
		else begin
			$display("input 1: FAIL");
		end
		first = first * 2;
		second = second + 1;
	end

	first = 0;
	second = 1;
	control = 1;
	
	#100;
	
	//sanity checks
	repeat(16) begin
		#50
		if(muxOut == second) begin
			$display("input 2: PASS");
		end
		else begin
			$display("input 2: FAIL");
		end
		second = second * 2;
		first = first + 1;

	end
	
end

endmodule