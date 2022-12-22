`timescale 1ns / 1ps


module Fetch(
	input RST,
	input CLK,
	input MemWriteManual,
	output [2:0] ALU1Op,
	output [2:0] ALU2Op,
	output [1:0] ALU1Src1,
   output 		 ALU1Src2,
	output [1:0] ALU2Src1,
   output [1:0] ALU2Src2,
	
   output 	    PCSrc,
	output       PCWrite,
	output  		 PCWriteCond,
   output           BType,
	
	output [1:0] CRSrc,
	output       CRWrite,
	
	output       SPWrite,
	
  output       MemWrite,
  output       RegWrite,

  output       IRWrite

);


wire [15:0] PCOut;
wire [15:0] IROut;
wire [15:0] MemOut1;
wire [15:0] MemOut2;
wire [15:0] Mux1Out;
wire [15:0] Mux2Out;
wire [15:0] ALU1output;
wire        zeroDetect;

Register PC (
	.CLK(CLK),
	.D(ALU1output),
	.WRT(PCWrite),
	.RST(RST),
	.Q(PCOut)
);

DistributedRAM InstructionMem (
	.read_i(PCOut[7:0]),
	.read_ii('b00000000),
	.out_i(MemOut1),
	.out_ii(MemOut2),
	.we(MemWriteManual),
	.write_addr(0),
	.write_data(0),
	.CLK(CLK)
);

Mux_4Input mux1 (
	.a(0),
	.b(1), //only this will be used
	.c(0), //for testing
	.d(0),
	.ctrl(ALU1Src1),
	.out(Mux1Out)
);

Mux_2Input mux2 (
	.a(PCOut),
	.b(0),
	.ctrl(ALU1Src2),
	.out(Mux2Out)
);

ALU alu (
	.A(Mux1Out),
	.B(Mux2Out),
	.OP(ALU1Op),
	.ALUOut(ALU1output),
	.ZERODETECT(zeroDetect)
);


D_Latch IR (
	.CLK(CLK),
	.D(MemOut1),
	.WRT(IRWrite),
	.RST(RST),
	.Q(IROut)
);

ControlUnit CtrlUnit (
	.Opcode(IROut[4:0]),
	.CLK(CLK),
	.Reset(RST),
	.ALU1Op(ALU1Op),
	.ALU2Op(ALU2Op),
	.ALU1Src1(ALU1Src1),
   .ALU1Src2(ALU1Src2),
	.ALU2Src1(ALU2Src1),
   .ALU2Src2(ALU2Src2),
	
   .PCSrc(PCSrc),
	.PCWrite(PCWrite),
	.PCWriteCond(PCWriteCond),
	.BType(BType),
	
	.CRSrc(CRSrc),
	.CRWrite(CRWrite),
	
	.SPWrite(SPWrite),
	
   .MemWrite(MemWrite),

   .IRWrite(IRWrite)	

);






endmodule