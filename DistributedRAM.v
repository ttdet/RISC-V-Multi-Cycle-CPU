module DistributedRAM(write_data, 
                    out_i,
						  out_ii,
						  read_i,
						  read_ii,
                    write_addr,
                    we,
                    CLK);	
   
   // Definitions
`define MEM_DEPTH 256
`define MEM_WIDTH 16
`define ADDR_SIZE 8

   // Inputs
   input [`ADDR_SIZE-1:0] write_addr;
	input [`ADDR_SIZE-1:0] read_i;
	input [`ADDR_SIZE-1:0] read_ii;
   input [`MEM_WIDTH-1:0] write_data;
   input                  we;
   input                  CLK;

   // Outputs
   output [`MEM_WIDTH-1:0] out_i;
	output [`MEM_WIDTH-1:0] out_ii;


   // The memory
   reg [`MEM_WIDTH-1:0] mem [0:`MEM_DEPTH-1];

   initial
     begin
        $readmemh("memory.txt", mem, 0, `MEM_DEPTH-1);
     end
   
	
	assign out_i = mem[read_i];
	assign out_ii = mem[read_ii];
	

   // Operations
   always @ (posedge CLK)
     begin
	if (we)
          mem[write_addr] <= write_data;
   end
   
endmodule