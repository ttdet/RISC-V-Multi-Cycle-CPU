`timescale 1ns / 1ps
module ImmGen_tb();

reg signed[10:0] cin;
reg[4:0] sin;
reg Select;
reg Double;

parameter WAIT_TIME = 10;
wire signed[15:0] imm;

integer trial = 0;

ImmediateGenerator UUT (
    .cin(cin),
    .sin(sin),
    .Select(Select),
    .Double(Double),
    .imm(imm)
);

initial begin

    #100;
    cin = 11'sb00000011011;
	sin = 5'b11001;
    Select = 0;
    Double = 0;
    #(WAIT_TIME);
    if (imm != (2*sin)) begin
        $display("Error at trial %d, output = %d, expected = %d", trial, imm, 2*sin);
    end
	 

    
    trial = trial + 1;
    Double = 1;
    #(WAIT_TIME);
   if (imm != (2*sin)) begin
        $display("Error at trial %d, output = %d, expected = %d", trial, imm, 2*sin);
    end

    
    trial = trial + 1;
    Select = 1;
    #(WAIT_TIME);
    if (imm != (2*cin)) begin
        $display("Error at trial %d, output = %d, expected = %d", trial, imm, (2*cin));
    end

    trial = trial + 1;
    Double = 0;
    #(WAIT_TIME);
    if (imm != cin) begin
        $display("Error at trial %d, output = %d, expected = %d", trial, imm, cin);
    end

    trial = trial + 1;
    cin = 11'sb11111111101;
    Select = 1;
    Double = 1;
    #(WAIT_TIME);
    if (imm != (2*cin)) begin
        $display("Error at trial %d, output = %d, expected = %d", trial, imm, (2*cin));
    end

    trial = trial + 1;
    Double = 0;
    #(WAIT_TIME);
    if (imm != cin) begin
        $display("Error at trial %d, output = %d, expected = %d", trial, imm, cin);
    end

    $stop;
end

endmodule