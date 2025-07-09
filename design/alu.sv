`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,

        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0001:        // XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0010:        // OR
                    ALUResult = SrcA | SrcB;
            4'b0011:        // ADD, ADDI
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b0100:        // SUB
                    ALUResult = $signed(SrcA) - $signed(SrcB);
            4'b0101:        // BEQ
                    ALUResult = ($signed(SrcA) == $signed(SrcB)) ? 1 : 0;
            4'b0110:        // BNE
                    ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b0111:        // BLT, SLT, SLTI
                    ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 1 : 0;
            4'b1000:        // BGE
                     ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 1 : 0;
            4'b1001:        // shift right (logic) - SRLI
                    ALUResult = SrcA >> SrcB;
            4'b1010:        // shift left (logic) - SLLI
                    ALUResult = SrcA << SrcB;
            4'b1011:        // shift right (arithmetic) - SRAI 
                    ALUResult = $signed(SrcA) >>> SrcB[4:0];
            4'b1100:        // set with srcB - nossa LUI !
                    ALUResult = SrcB;
            4'b1111:        // True
                    ALUResult = 1;
            default:
                    ALUResult = 0;
            endcase
        end
endmodule