module imm_Gen (
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);

    logic [6:0] opcode;
    assign opcode = inst_code[6:0];

    always_comb begin
        unique case (opcode)

            // I-type: LW, LH, LB, LBU, LHU
            7'b0000011: begin
                logic [11:0] imm_i;
                imm_i = inst_code[31:20];
                Imm_out = {{20{imm_i[11]}}, imm_i};
            end

            // I-type aritimetica: ADDI, SLTI, SLLI, SRLI, SRAI
            7'b0010011: begin
                logic [11:0] imm_i;
                logic [4:0] shamt;
                imm_i = inst_code[31:20];
                shamt = inst_code[24:20];

                case (inst_code[14:12])
                    3'b001, 3'b101: // SLLI, SRLI, SRAI
                        Imm_out = {27'd0, shamt}; // Shift 
                    default: // ADDI, SLTI, etc.
                        Imm_out = {{20{imm_i[11]}}, imm_i};
                endcase
            end

            // S-type: SW, SH, SB
            7'b0100011: begin
                logic [11:0] imm_s;
                imm_s = {inst_code[31:25], inst_code[11:7]};
                Imm_out = {{20{imm_s[11]}}, imm_s};
            end

            // B-type: BEQ, BNE, etc.
            7'b1100011: begin
                logic [12:0] imm_b;
                imm_b = {
                    inst_code[31],
                    inst_code[7],
                    inst_code[30:25],
                    inst_code[11:8],
                    1'b0
                };
                Imm_out = {{19{imm_b[12]}}, imm_b};
            end

            // J-type: JAL
            7'b1101111: begin
                logic [20:0] imm_j;
                imm_j = {
                    inst_code[31],
                    inst_code[19:12],
                    inst_code[20],
                    inst_code[30:21],
                    1'b0
                };
                Imm_out = {{11{imm_j[20]}}, imm_j};
            end

            // I-type: JALR
            7'b1100111: begin
                logic [11:0] imm_jalr;
                imm_jalr = inst_code[31:20];
                Imm_out = {{20{imm_jalr[11]}}, imm_jalr};
            end

            default: begin
                Imm_out = 32'd0;
            end
        endcase
    end
endmodule