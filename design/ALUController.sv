`timescale 1ns / 1ps

module ALUController (
    // Interface de Entradas e Saídas
    input  logic [1:0] ALUOp,
    input  logic [6:0] Funct7,
    input  logic [2:0] Funct3,
    output logic [3:0] Operation
);

    always_comb begin
        // Atribuição de um valor padrão inicial para a saída.
        // Isso garante que 'Operation' sempre tenha um valor definido.
        Operation = 4'b0000;

        unique case (ALUOp)
            2'b00: Operation = 4'b0010;  // LW/SW: ADD para cálculo de endereço

            2'b01: begin // Instruções de desvio (Branch)
                case (Funct3)
                    3'b000: Operation = 4'b0110; // BEQ (SUB)
                    3'b001: Operation = 4'b1001; // BNE
                    3'b100: Operation = 4'b1100; // BLT
                    3'b101: Operation = 4'b1101; // BGE
                    default: Operation = 4'b0000;
                endcase
            end

            2'b10: begin // Instruções do Tipo-R e Tipo-I
                case (Funct3)
                    3'b000: begin
                        if (Funct7 == 7'b0100000)
                            Operation = 4'b0110; // SUB (Tipo-R específico)
                        else
                            Operation = 4'b0010; // ADD / ADDI
                    end
                    3'b001: Operation = 4'b0011; // SLL / SLLI
                    3'b010: Operation = 4'b1100; // SLT / SLTI
                    3'b100: Operation = 4'b0100; // XOR / XORI
                    3'b101: begin
                        if (Funct7 == 7'b0100000)
                            Operation = 4'b1010; // SRA (Tipo-R específico)
                        else
                            Operation = 4'b0101; // SRL / SRLI
                    end
                    3'b110: Operation = 4'b0001; // OR / ORI
                    3'b111: Operation = 4'b0000; // AND / ANDI
                    default: Operation = 4'b0000; // Caso padrão para Funct3
                endcase
            end

        endcase
    end

endmodule