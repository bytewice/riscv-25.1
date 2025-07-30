`timescale 1ns / 1ps

module alu#(
    parameter DATA_WIDTH = 32,
    parameter OPCODE_LENGTH = 4
)(
    input  logic [DATA_WIDTH-1:0]    SrcA,
    input  logic [DATA_WIDTH-1:0]    SrcB,
    input  logic [OPCODE_LENGTH-1:0] Operation,
    output logic [DATA_WIDTH-1:0]    ALUResult
);

    logic [4:0] shift_amount;

    always_comb begin
        // Valor padrão evita latch
        ALUResult = '0;
        shift_amount = SrcB[4:0];

        case (Operation)
            4'b0000: // AND
                ALUResult = SrcA & SrcB;

            4'b0001: // OR
                ALUResult = SrcA | SrcB;

            4'b0010: // ADD
                ALUResult = SrcA + SrcB;

            4'b0011: // SLL (Shift Left Logical)
                ALUResult = SrcA << shift_amount;

            4'b0100: // XOR
                ALUResult = SrcA ^ SrcB;

            4'b0101: // SRL (Shift Right Logical)
                ALUResult = SrcA >> shift_amount;

            4'b0110: // SUB
                ALUResult = SrcA - SrcB;

            4'b1000: // Equal (BEQ)
                ALUResult = (SrcA == SrcB) ? 32'd1 : 32'd0;

            4'b1001: // Not Equal (BNE)
                ALUResult = (SrcA != SrcB) ? 32'd1 : 32'd0;

            4'b1010: // SRA (Shift Right Arithmetic)
                ALUResult = $signed(SrcA) >>> shift_amount;

            4'b1100: // SLT (Set Less Than - signed)
                ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;

            4'b1101: // BGE (Branch Greater or Equal - signed)
                ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 32'd1 : 32'd0;

            default:
                ALUResult = 32'd0;
        endcase
    end
endmodule