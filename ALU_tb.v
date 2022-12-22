`timescale 1ns / 1ps

module ALU_tb();

reg signed[15:0] a;
reg signed[15:0] b;
reg [2:0] s;
reg clk;
reg rst;

wire signed[15:0] out;
wire zOut;

parameter HALF_PERIOD = 50;
integer cycle = 0;

initial begin
    clk = 0;
    forever begin
        #(HALF_PERIOD);
        clk = ~clk;
    end
end

ALU UUT (
	.A(a),
	.B(b),
	.OP(s),
	.CLK(clk),
	.RST(rst),
	.ALUOut(out),
	.ZERODETECT(zOut)
);

initial begin
	// Testing reset
    #100;
    rst = 1;
    a = 0;
	 b = 0;
	 s = 0;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 0) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	// Testing s=0 ADD
    rst = 0;
    a = 1;
	 b = 1;
	 s = 0;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 2) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = 5;
	 b = 10;
	 s = 0;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 15) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = -3;
	 b = -5;
	 s = 0;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != -8) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	// Testing s=1 SUB
	 rst = 0;
    a = 1;
	 b = 1;
	 s = 1;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 0) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = 5;
	 b = 10;
	 s = 1;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != -5) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = -3;
	 b = -5;
	 s = 1;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 2) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
    
	 // Testing s=2 Shift Left
	 rst = 0;
    a = 1;
	 b = 1;
	 s = 2;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 2) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = 5;
	 b = 3;
	 s = 2;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 40) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = -3;
	 b = 2;
	 s = 2;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != -12) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 // Testing s=3 Shift Right
	 rst = 0;
    a = 20;
	 b = 1;
	 s = 3;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 10) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = 11;
	 b = 2;
	 s = 3;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 2) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = -12;
	 b = 3;
	 s = 3;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != -3) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 // Testing s=4 or
	 rst = 0;
    a = 1;
	 b = 2;
	 s = 4;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 3) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = 8;
	 b = 5;
	 s = 4;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 2) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = -1;
	 b = 0;
	 s = 4;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != -1) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
    $stop;
	 
	 // Testing s=5 and
	 rst = 0;
    a = 1;
	 b = 1;
	 s = 5;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 1) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = 8;
	 b = 5;
	 s = 5;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 0) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
	 
	 rst = 0;
    a = -1;
	 b = 0;
	 s = 5;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 0) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
    $stop;
end

endmodule