`timescale 1ns / 1ps

module Fetch_tb();

reg RST;
reg CLK;
reg MemWriteManual;	
wire [2:0] ALU1Op;
wire [2:0] ALU2Op;
wire [1:0] ALU1Src1;
wire 		 ALU1Src2;
wire [1:0] ALU2Src1;
wire [1:0] ALU2Src2;
	
   wire 	   PCSrc;
	wire     PCWrite;
	wire  	PCWriteCond;
	wire[1:0]     BType;
	
	wire [1:0] CRSrc;
	wire       CRWrite;
	
	wire       SPWrite;
	
  wire       MemWrite;

  wire       IRWrite;
 
parameter HALF_PERIOD = 50;

Fetch UUT (
	.RST(RST),
	.CLK(CLK),
	.MemWriteManual(MemWriteManual),
	.ALU1Op(ALU1Op),
	.ALU2Op(ALU2Op),
	.ALU1Src1(ALU1Src1),
	.ALU1Src2(ALU1Src2),
	.ALU2Src1(ALU2Src1),
	.ALU2Src2(ALU2Src2),
	.PCWrite(PCWrite),
	.PCWriteCond(PCWriteCond),
	.PCSrc(PCSrc),
	.BType(BType),
	.CRSrc(CRSrc),
	.CRWrite(CRWrite),
	.SPWrite(SPWrite),
	.MemWrite(MemWrite),
	.IRWrite(IRWrite)
);

initial begin
    CLK = 0;
    forever begin
        #(HALF_PERIOD);
        CLK = ~CLK;
    end
end

initial begin
	RST = 1;
	MemWriteManual = 0;
	#100;
	#(HALF_PERIOD + 20);
	RST = 0;
	#(2*HALF_PERIOD - 20);
	#(16*HALF_PERIOD);
	
	
	$stop;
	
	
	


end

endmodule