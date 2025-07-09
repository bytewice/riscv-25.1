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
        // Atribui um valor padrão para a saída para evitar a inferência de latches
        ALUResult = '0;

        // A quantidade de deslocamento para operações de shift é extraída dos 5 bits menos significativos de SrcB.
        shift_amount = SrcB[4:0];
.
        if (Operation == 4'b0000) begin      // AND
            ALUResult = SrcA & SrcB;
        end
        else if (Operation == 4'b0001) begin // OR
            ALUResult = SrcA | SrcB;
        end
        else if (Operation == 4'b0010) begin // ADD
            ALUResult = SrcA + SrcB;
        end
        else if (Operation == 4'b0011) begin // SLL (Shift Left Logical)
            ALUResult = SrcA << shift_amount;
        end
        else if (Operation == 4'b0100) begin // XOR
            ALUResult = SrcA ^ SrcB;
        end
        else if (Operation == 4'b0101) begin // SRL (Shift Right Logical)
            ALUResult = SrcA >> shift_amount;
        end
        else if (Operation == 4'b0110) begin // SUB
            ALUResult = SrcA - SrcB;
        end
        else if (Operation == 4'b1000) begin // Equal (para BEQ)
            ALUResult = (SrcA == SrcB); // Atribuição direta do booleano (resulta em 1 ou 0)
        end
        else if (Operation == 4'b1001) begin // Not Equal (para BNE)
            ALUResult = (SrcA != SrcB);
        end
        else if (Operation == 4'b1010) begin // SRA (Shift Right Arithmetic)
            // O casting para $signed garante que o bit de sinal seja propagado
            ALUResult = $signed(SrcA) >>> shift_amount;
        end
        else if (Operation == 4'b1100) begin // SLT (Set Less Than, com sinal)
            ALUResult = ($signed(SrcA) < $signed(SrcB));
        end
        else if (Operation == 4'b1101) begin // BGE (Branch Greater or Equal, com sinal)
            ALUResult = ($signed(SrcA) >= $signed(SrcB));
        end
    end

endmodule