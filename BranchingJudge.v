module BranchingJudge (
    input signed[15:0] imm,
	input[1:0] BType,
    output reg out
);

always @(imm or BType) begin
    if (BType == 0) begin 
        //beq
        if (imm == 0) begin
            out = 1;
        end else begin
            out = 0;
        end
        
    end else if (BType == 1) begin
        //bge
        if (imm >= 0) begin
            out = 1;
        end else begin
            out = 0;
        end
    end else if (BType == 2) begin
        //bgt
        if (imm > 0) begin
            out = 1;
        end else begin
            out = 0;
        end
    end else begin
        //bneq
        if (imm == 0) begin
            out = 0;
        end else begin
            out = 1;
        end
    end
end

endmodule