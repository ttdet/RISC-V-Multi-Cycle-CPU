`timescale 1ns / 100ps

module ControlUnit (
	output reg[2:0] ALU1Op,
	output reg[2:0] ALU2Op,
	output reg[1:0] ALU1Src1,
  output reg		 ALU1Src2,
	output reg[1:0] ALU2Src1,
  output reg[1:0] ALU2Src2,
	
  output reg	    PCSrc,
	output reg      PCWrite,
	output reg 		 PCWriteCond,
	
	output reg[1:0] CRSrc,
	output reg      CRWrite,
	
	output reg      SPWrite,
	output reg      MemWrite,
  output reg      IRWrite,
  output reg      ALUO1WRT,
  output reg      ALUO2WRT,
  output reg      MemO1WRT,
  output reg      MemO2WRT,
  output reg[1:0]  BType,
  output reg       EOP,
  input [4:0]  Opcode,
  input        CLK,
  input        Reset
);


   //state flip-flops
reg [3:0]    current_state;
reg [3:0]    next_state;

   //state definitions
parameter    Fetch = 0;
parameter    PC_Rel_Branch = 1;
parameter    Cond_Branch_Execute = 2;
parameter    Cond_Branch_Mem = 3;
parameter    Cond_Branch_WB = 4;
parameter    ALU_C = 5;
parameter    ALU_S_Execute = 6;
parameter    ALU_S_Mem = 7;
parameter    ALU_S_WB = 8;
parameter    ALU_S_LDS = 9;
parameter    ALU_S_WRS = 10;
parameter    Reg_To_Reg = 11;
parameter    Abs_Branch = 12;
parameter    End = 13;
//input PCWriteManual,
//	input IRWriteManual,
//	input RST,
//	input CLK,
//	input [15:0] PCQ,
//	input MemWriteManual,
//	output [2:0] ALU1Op,
//	output [2:0] ALU2Op,
//	output [1:0] ALU1Src1,
//   output 		 ALU1Src2,
//	output [1:0] ALU2Src1,
//   output [1:0] ALU2Src2,
//	
//   output 	    PCSrc,
//	output       PCWrite,
//	output  		 PCWriteCond,
//	
//	output [1:0] CRSrc,
//	output       CRWrite,
//	
//	output       SPWrite,
//	
//  output       MemWrite,
//  output       RegWrite,
//
//  output       IRWrite,
   //register calculation
always @ (negedge CLK, posedge Reset) begin
  if (Reset)
    current_state = Fetch;
  else 
    current_state = next_state;
end


   //OUTPUT signals for each state (depends on current state)
always @ (current_state) begin
        //Reset all signals that cannot be don't cares
  PCWrite = 0; 
  CRWrite = 0;
  SPWrite = 0;
  MemWrite = 0; 
  IRWrite = 0; 
  PCWrite = 0;
  PCWriteCond = 0;
  BType = 0;
	ALU1Src1 = 0;
	ALU1Src2 = 0;
	ALU2Src1 = 0;
	ALU2Src2 = 0;
	ALU1Op = 0;
	ALU2Op = 0;
	CRSrc = 0;
	PCSrc = 0;
	EOP = 0;
	ALUO1WRT = 0;
	ALUO2WRT = 0;
	MemO1WRT = 0;
	MemO2WRT = 0;
		  
		  
        
  case (current_state)
          
	 End:
		begin
			EOP = 1;
		end
		
	
    Fetch:
      begin     
        IRWrite =  1;
					
        ALU1Src1 = 1;
        ALU1Src2 = 0;
        ALU1Op = 0;

        PCWrite = 1;
        PCSrc = 0;
      end 
                         
    PC_Rel_Branch:
      begin
        PCWrite = 1;
        ALU1Src1 = 3;
        ALU1Src2 = 0;
        ALU1Op = 0;
        PCSrc = 0;
      end
				
		Abs_Branch:
			begin
				PCWrite = 1;
				PCSrc = 1;
			end
        
    Cond_Branch_Execute:
      begin
        ALU1Src1 = 2;
        ALU1Src2 = 1;
        ALU1Op = 0;
					
		    ALU2Src1 = 2;
			  ALU2Src2 = 1;
		ALUO1WRT = 1;
		ALUO2WRT = 1;
        ALU2Op = 0;
      end
				
	  Cond_Branch_Mem:
      begin
        MemO1WRT = 1;
		MemO2WRT = 1;
      end
				
		Cond_Branch_WB:
      begin
        ALU2Src1 = 3;
				ALU2Src2 = 3;
        ALU2Op = 1;
				BType = Opcode[3:2];
				PCSrc = 1;
				PCWriteCond = 1;
      end
        
    ALU_C:
      begin
			  if (Opcode == 'b00101) begin
					//addcsp
				  SPWrite = 1;
					ALU2Src1 = 1;
					ALU2Src2 = 1;
					ALU2Op = 0;
				end else begin
          CRWrite = 1;
          CRSrc = 2;
          ALU2Src1 = 1;
          ALU2Src2 = 2;              
          ALU2Op = Opcode[4:2];
				end
      end
        
    ALU_S_Execute:
      begin
        ALU1Src1 = 2;
        ALU1Src2 = 1;
        ALU1Op = 0;
		ALUO1WRT = 1;
		ALUO2WRT = 1;
      end
        
    ALU_S_Mem:
      begin
		  	MemO1WRT = 1;
			MemO2WRT = 1;
      end
          
    ALU_S_WB:
      begin
        CRWrite = 1;
	      CRSrc = 2;
		    ALU2Src1 = 3;
		    ALU2Src2 = 2;
			  ALU2Op = Opcode[4:2];
      end
				
		ALU_S_LDS:
      begin
        CRWrite = 1;
        CRSrc = 0;	
      end
          
		ALU_S_WRS:
      begin
        MemWrite = 1;
      end	
				
		Reg_To_Reg:
      begin
        CRWrite = 1;
				CRSrc = 1;
		    ALU1Src1 = 0;
        case (Opcode)
          5'b00111:
            begin
              ALU1Src2 = 0;
            end
          5'b01011:
            begin
              ALU1Src2 = 1;
            end
        endcase
      end
        
        
      default:
        begin //$display ("not implemented"); 
		end
  
  endcase

end
                
   //NEXT STATE calculation (depends on current state and Opcode)       
always @ (current_state, next_state, Opcode)
  begin         

  //$display("The current state is %d", current_state);
        
        case (current_state)
          
          
          Fetch: 
            begin       
                //$display("The Opcode is %d", Opcode);
               
                if (Opcode == 'b11111) begin
                  next_state = PC_Rel_Branch;
                  //$display("The next state is PC_Rel_Branch");
                end else if (Opcode == 'b11011) begin
						next_state = End;
				end else if (Opcode == 'b11100) begin
                next_state = Abs_Branch;
                //$display("The next state is Ans_Branch");
                end else begin
                      case (Opcode[1:0])

                        2'b00:
                        begin
                            next_state = Cond_Branch_Execute;
                            //$display("The next state is Cond_Branch_Execute");
                        end
                        2'b01:
                          begin
                              next_state = ALU_C;
                              //$display("The next state is ALU_C");
                          end
                        2'b10:
                          begin
                              next_state = ALU_S_Execute;
                              //$display("The next state is ALU_S_Execute");
                          end
                        2'b11:
                          begin next_state = Reg_To_Reg;
                              //$display("The next state is Reg_To_Reg");
                          end
                        default:
                          begin 
                              //$display(" Wrong Opcode %d ", Opcode);  
                              next_state = Fetch; 
                        end

                      endcase

                end

                //$display("In Decode, the next_state is %d", next_state);
              end
          
          PC_Rel_Branch:
            begin
               next_state = Fetch;
               //$display("In PC_Rel_Branch, the next_state is %d", next_state);
            end
				
			Abs_Branch:
				begin
					next_state = Fetch;
					//$display("In Abs_Branch, the next state is %d", next_state);
				end
          
          Cond_Branch_Execute:
            begin
               next_state = Cond_Branch_Mem;
               //$display("In Cond_Branch_Execute, the next_state is %d", next_state);
            end
				
			 Cond_Branch_Mem:
            begin
               next_state = Cond_Branch_WB;
               //$display("In Cond_Branch_Mem, the next_state is %d", next_state);
            end				
				
			 Cond_Branch_WB:
            begin
               next_state = Fetch;
					//$display("In Cond_Branch_WB, the next_state is %d", next_state);
				end
				
			 ALU_C:
            begin
               next_state = Fetch;
               //$display("In ALU_C, the next_state is %d", next_state);
            end
				
			 ALU_S_Execute:
				 case (Opcode)
                 5'b10010:
                   begin
                      next_state = ALU_S_WRS;
                      //$display("The next state is ALU_S_WRS");
                   end
                 5'b11010:
                   begin
                      next_state = ALU_S_LDS;
                      //$display("The next state is ALU_S_LDS");
                   end
                 default:
                   begin
                      next_state = ALU_S_Mem;
                      //$display("The next state is ALU_S_Mem");
                   end
					endcase
				
			 ALU_S_Mem:
            begin
               next_state = ALU_S_WB;
               //$display("In ALU_S_Mem, the next_state is %d", next_state);
            end
				
			 ALU_S_WB:
            begin
               next_state = Fetch;
               //$display("In ALU_S_WB, the next_state is %d", next_state);
            end
				
			 ALU_S_LDS:
            begin
               next_state = Fetch;
               //$display("In ALU_S_LDS, the next_state is %d", next_state);
            end
				
			 ALU_S_WRS:
            begin
               next_state = Fetch;
               //$display("In ALU_S_WRS, the next_state is %d", next_state);
            end
				
			 Reg_To_Reg:
            begin
               next_state = Fetch;
               //$display("In Reg_To_Reg, the next_state is %d", next_state);
            end
			
			 End:
				begin
					next_state = End;
				end
          
          default:
            begin
               //$display(" Not implemented!");
               next_state = End;
            end
          
        endcase
        
        //$display("After the tests, the next_state is %d", next_state);
                
     end

endmodule