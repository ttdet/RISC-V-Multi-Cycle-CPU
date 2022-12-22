module Mux_4Input_tb();

//Inputs
reg[15:0] first;
reg[15:0] second;
reg[15:0] third;
reg[15:0] fourth;

reg[1:0] control;

//Outputs
wire [15:0] muxOut;

//Instantiate the mux
Mux_4Input UUT(
	.a(first),
	.b(second),
	.c(third),
	.d(fourth),
	.ctrl(control),
	.out(muxOut)
);

initial begin
	first = 1;
	second = 0;
	third = 4;
	fourth = 17;
	control = 0;
	
	#100;
	
	//first input
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
		third = third + 3;
		fourth = fourth + 4;
	end

	first = 1;
	second = 0;
	third = 4;
	fourth = 17;
	control = 1;
	
	#100;
	
	//second input
	repeat(16) begin
		#50
		if(muxOut == second) begin
			$display("input 2: PASS");
		end
		else begin
			$display("input 2: FAIL");
		end
		first = first * 2;
		second = second + 1;
		third = third + 3;
		fourth = fourth + 4;
	end

	first = 1;
	second = 0;
	third = 4;
	fourth = 17;
	control = 2;
	
	#100;
	
	//third checks
	repeat(16) begin
		#50
		if(muxOut == third) begin
			$display("input 3: PASS");
		end
		else begin
			$display("input 3: FAIL");
		end
		first = first * 2;
		second = second + 1;
		third = third + 3;
		fourth = fourth + 4;
	end

	first = 1;
	second = 0;
	third = 4;
	fourth = 17;
	control = 3;
	
	#100;
	
	//fourth checks
	repeat(16) begin
		#50
		if(muxOut == fourth) begin
			$display("input 4: PASS");
		end
		else begin
			$display("input 4: FAIL");
		end
		first = first * 2;
		second = second + 1;
		third = third + 3;
		fourth = fourth + 4;
	end
	
end

endmodule