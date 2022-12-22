`timescale 1ns / 1ps

module BJudge_tb();

reg signed[15:0] imm;
reg[1:0] BType;
wire out;

parameter WAIT_TIME = 10;
integer trial = 0;

BranchingJudge UUT (
    .imm(imm),
    .BType(BType),
    .out(out)
);

initial begin 
    #100;

    imm = 0;

    BType = 0;
    #(WAIT_TIME);
    if (out != 1) begin
        $display("Error at trial %d, output = %d, expected = 1", trial, out);
    end

    BType = 1;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 1) begin
        $display("Error at trial %d, output = %d, expected = 1", trial, out);
    end

    BType = 2;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 0) begin
        $display("Error at trial %d, output = %d, expected = 0", trial, out);
    end

    BType = 3;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 0) begin
        $display("Error at trial %d, output = %d, expected = 0", trial, out);
    end

    imm = 3;

    BType = 0;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 0) begin
        $display("Error at trial %d, output = %d, expected = 0", trial, out);
    end

    BType = 1;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 1) begin
        $display("Error at trial %d, output = %d, expected = 1", trial, out);
    end

    BType = 2;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 1) begin
        $display("Error at trial %d, output = %d, expected = 1", trial, out);
    end

    BType = 3;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 1) begin
        $display("Error at trial %d, output = %d, expected = 1", trial, out);
    end

    imm = -99;

    BType = 0;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 0) begin
        $display("Error at trial %d, output = %d, expected = 0", trial, out);
    end

    BType = 1;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 0) begin
        $display("Error at trial %d, output = %d, expected = 0", trial, out);
    end

    BType = 2;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 0) begin
        $display("Error at trial %d, output = %d, expected = 0", trial, out);
    end

    BType = 3;
    trial = trial + 1;
    #(WAIT_TIME);
    if (out != 1) begin
        $display("Error at trial %d, output = %d, expected = 1", trial, out);
    end




end

endmodule