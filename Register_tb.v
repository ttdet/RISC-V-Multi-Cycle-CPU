`timescale 1ns / 1ps

module Register_tb();

reg [15:0] in;
reg clk;
reg rst;
reg wrt;

wire signed[15:0] out;

parameter HALF_PERIOD = 50;
integer cycle = 0;

initial begin
    clk = 0;
    forever begin
        #(HALF_PERIOD);
        clk = ~clk;
    end
end

Register UUT (
    .D(in),
    .RST(rst),
    .CLK(clk),
    .WRT(wrt),
    .Q(out)
);

initial  begin
    #100;
    rst = 1;
    wrt = 0;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 0) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end

    rst = 0;
    in = 5;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 0) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end

    rst = 0;
    wrt = 1;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != in) begin
        $display("Error at cycle %d, output = %d, expected = %d", cycle, out, in);
    end

    rst = 1;
    #(2 * HALF_PERIOD);
    cycle = cycle + 1;
    if (out != 0) begin
        $display("Error at cycle %d, output = %d, expected = 0", cycle, out);
    end
    
    $stop;
end

endmodule