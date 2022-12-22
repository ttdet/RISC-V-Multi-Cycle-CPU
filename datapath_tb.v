`timescale 1ns / 1ps

module datapath_tb();

reg clk;
reg rst;
wire EOP;


parameter HALF_PERIOD = 8.2;
integer half_cycle = 0;

initial begin
    clk = 0;
    forever begin
        #(HALF_PERIOD);
        clk = ~clk;
		  half_cycle = half_cycle + 1;
	if (EOP == 1) begin
		$display("Finished. Cycles taken: %d", half_cycle / 2);
		$stop;
	end	

    end
end

initial begin
	rst = 1;
	 #(HALF_PERIOD + 20);
	 rst = 0;
	 #(HALF_PERIOD - 20);
	#(HALF_PERIOD * 100000000);
	$stop;
end

Aristotle UUT (
    .CLK(clk),
	 .RST(rst),
	.EOP(EOP)
);


endmodule