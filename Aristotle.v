module Aristotle(
	input CLK,
	input RST,
	output EOP
);

//Control signals
wire [2:0] alu1OpCtrl;
wire [2:0] alu2OpCtrl;
wire [1:0] alu1Src1Ctrl;
wire 	   alu1Src2Ctrl;
wire [1:0] alu2Src1Ctrl;
wire [1:0] alu2Src2Ctrl;
	
wire 	   PCSrcCtrl;
wire       PCWriteCtrl;
wire  	   PCWriteCondCtrl;
wire [1:0] BTypeCtrl;

wire       ALUO1WRTCtrl;
wire       ALUO2WRTCtrl;

wire       MemO1WRTCtrl;
wire       MemO2WRTCtrl;
	
wire [1:0] CRSrcCtrl;
wire       CRWriteCtrl;
	
wire       SPWriteCtrl;
wire       MemWriteCtrl;
wire       RegWriteCtrl;

wire       IRWriteCtrl;


//ALU 1 and 2 inputs/ouputs
wire [15:0] alu1out;
wire [15:0] alu2out;

wire [2:0] alu1Op;
wire [2:0] alu2Op;

wire [15:0] aluo1q;
wire [15:0] aluo2q;

wire alu1Zero;
wire alu2Zero;

//ALU source inputs
wire [15:0] gnd = 0;
wire [15:0] one = 1;

wire [15:0] immS1;
wire [15:0] immS2;
wire [15:0] constant;
wire [15:0] pcOut;
wire [15:0] spOut;
wire [15:0] crOut;
wire [15:0] irOut;

//ALU source outputs
wire signed [15:0] alu1Src1Out;
wire signed [15:0] alu1Src2Out;
wire signed [15:0] alu2Src1Out;
wire signed [15:0] alu2Src2Out;

wire [15:0] InstructionMemOut1;
wire [15:0] InstructionMemOut2;

wire [15:0] StackMemOut1;
wire [15:0] StackMemOut2;

//Register inputs
wire [15:0] pcSrcOut;
wire [15:0] crSrcOut;

//Main memory wires
wire [15:0] mem1q;
wire [15:0] mem2q;

wire bJudgeOut;

wire PCWrite = ((bJudgeOut & PCWriteCondCtrl) | PCWriteCtrl); //TODO: Set in @always

ControlUnit CtrlUnit (
	.Opcode(irOut[4:0]),
	.CLK(CLK),
	.Reset(RST),
	.ALU1Op(alu1OpCtrl),
	.ALU2Op(alu2OpCtrl),
	.ALU1Src1(alu1Src1Ctrl),
   .ALU1Src2(alu1Src2Ctrl),
	.ALU2Src1(alu2Src1Ctrl),
   .ALU2Src2(alu2Src2Ctrl),
	
   .PCSrc(PCSrcCtrl),
	.PCWrite(PCWriteCtrl),
	.PCWriteCond(PCWriteCondCtrl),
	.BType(BTypeCtrl),
	
	.CRSrc(CRSrcCtrl),
	.CRWrite(CRWriteCtrl),
	
	.SPWrite(SPWriteCtrl),
	
   .MemWrite(MemWriteCtrl),
   .ALUO1WRT(ALUO1WRTCtrl),
   .ALUO2WRT(ALUO2WRTCtrl),
   .MemO1WRT(MemO1WRTCtrl),
   .MemO2WRT(MemO2WRTCtrl),
   .IRWrite(IRWriteCtrl),
   .EOP(EOP)

);

DistributedRAM InstructionMem (
	.read_i(pcOut[7:0]),
	.read_ii(0),
	.out_i(InstructionMemOut1),
	.out_ii(InstructionMemOut2),
	.we(gnd),
	.write_addr(aluo1q),
	.write_data(0),
	.CLK(CLK)
);

DistributedRAM StackMem (
	.read_i(aluo1q[7:0]),
	.read_ii(aluo2q[7:0]),
	.out_i(StackMemOut1),
	.out_ii(StackMemOut2),
	.we(MemWriteCtrl),
	.write_addr(aluo1q),
	.write_data(crOut),
	.CLK(CLK)
);

ALU ALU1(
	.A(alu1Src1Out),
	.B(alu1Src2Out),
	.OP(alu1OpCtrl),
	.ALUOut(alu1out),
	.ZERODETECT(alu1Zero)
);

ALU ALU2(
	.A(alu2Src1Out),
	.B(alu2Src2Out),
	.OP(alu2OpCtrl),
	.ALUOut(alu2out),
	.ZERODETECT(alu2Zero)
);

//ALU1 Input Muxes
Mux_4Input ALU1SRC1(
	.a(gnd),
	.b(one),
	.c(immS1),
	.d(constant),
	.ctrl(alu1Src1Ctrl),
	.out(alu1Src1Out)
);


Mux_2Input ALU1SRC2(
	.a(pcOut),
	.b(spOut),
	.ctrl(alu1Src2Ctrl),
	.out(alu1Src2Out)
);


//ALU2 Input Muxes
Mux_4Input ALU2SRC1(
	.a(gnd),
	.b(constant),
	.c(immS2),
	.d(mem1q),
	.ctrl(alu2Src1Ctrl),
	.out(alu2Src1Out)
);

Mux_4Input ALU2SRC2(
	.a(gnd),
	.b(spOut),
	.c(crOut),
	.d(mem2q),
	.ctrl(alu2Src2Ctrl),
	.out(alu2Src2Out)
);


//CR source Mux
Mux_4Input CRSrc(
	.a(StackMemOut1),
	.b(alu1out),
	.c(alu2out),
	.d(gnd),
	.ctrl(CRSrcCtrl),
	.out(crSrcOut)
);

Mux_2Input PCSrc(
	.a(alu1out),
	.b(crOut),
	.ctrl(PCSrcCtrl),
	.out(pcSrcOut)
);

//The most registery registers
Register PC(
	.D(pcSrcOut),
	.CLK(CLK),
	.RST(RST),
	.WRT(PCWrite),
	.Q(pcOut)
);

sp_register SP(
	.D(alu2out),
	.CLK(CLK),
	.RST(RST),
	.WRT(SPWriteCtrl),
	.Q(spOut)
);

Register CR(
	.D(crSrcOut),
	.CLK(CLK),
	.RST(RST),
	.WRT(CRWriteCtrl),
	.Q(crOut)
);


Register Mem1(
	.D(StackMemOut1),
	.CLK(CLK),
	.RST(RST),
	.WRT(MemO1WRTCtrl),
	.Q(mem1q)
);

Register Mem2(
	.D(StackMemOut2),
	.CLK(CLK),
	.RST(RST),
	.WRT(MemO2WRTCtrl),
	.Q(mem2q)
);

Register AluO1(
	.D(alu1out),
	.CLK(CLK),
	.RST(RST),
	.WRT(ALUO1WRTCtrl),
	.Q(aluo1q)
);

Register AluO2(
	.D(alu2out),
	.CLK(CLK),
	.RST(RST),
	.WRT(ALUO2WRTCtrl),
	.Q(aluo2q)
);

D_Latch IR (
	.CLK(CLK),
	.D(InstructionMemOut1),
	.WRT(IRWriteCtrl),
	.RST(RST),
	.Q(irOut)
);


ImmediateGenerator S1ImmGen(
	.sin(irOut[9:5]),
	.cin(gnd),
	.Select(gnd),
	.imm(immS1)
);


ImmediateGenerator S2ImmGen(
	.sin(irOut[14:10]),
	.cin(gnd),
	.Select(gnd),
	.imm(immS2)
);

ImmediateGenerator C1ImmGen(
	.sin(gnd),
	.cin(irOut[15:5]),
	.Select(one),
	.imm(constant)
);

BranchingJudge BJudge (
	.imm(alu2out),
	.BType(BTypeCtrl),
	.out(bJudgeOut)
);

endmodule