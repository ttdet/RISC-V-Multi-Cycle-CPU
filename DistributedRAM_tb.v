module DistributedRAM_tb();

reg[15:0] read_i, read_ii;
reg[15:0] data, write_addr;
reg clk;
reg we;


wire [15:0] out_i;
wire [15:0] out_ii;

parameter PERIOD = 100;
parameter HALF_PERIOD = 50;

DistributedRAM UUT(
	.write_data(data),
	.write_addr(write_addr),
	.read_i(read_i),
	.read_ii(read_ii),
	.CLK(clk),
	.we(we),
	.out_i(out_i),
	.out_ii(out_ii)
);

initial begin
    clk = 0;
    forever begin
        #(HALF_PERIOD);
        clk = ~clk;
    end
end

initial begin
	#100;
	we = 0;
	read_i = 'h00;
	read_ii = 'h01;
	write_addr = 'h0005;
	data = 'hffff;

	#10;
	
	we = 1;
	read_i = 'h01;
	read_ii = 'h02;
	write_addr = 'h06;
	data = 'hfffe;
	$display("out_i %h", out_i);
	$display("out_ii %h", out_ii);

	#(PERIOD);
	
	$stop;
end

endmodule