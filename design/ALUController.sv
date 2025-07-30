`timescale 1ns / 1ps

module ALUController (
    // Interface de Entradas e Saídas
    input  logic [1:0] ALUOp,
    input  logic [6:0] Funct7,
    input  logic [2:0] Funct3,
    output logic [3:0] Operation
);

    localparam logic [3:0]
        OP_AND  = 4'b0000,
        OP_OR   = 4'b0001,
        OP_ADD  = 4'b0010,
        OP_SLL  = 4'b0011,
        OP_XOR  = 4'b0100,
        OP_SRL  = 4'b0101,
        OP_SUB  = 4'b0110,
        OP_SRA  = 4'b1010,
        OP_BEQ  = 4'b1000,
        OP_BNE  = 4'b1001,
        OP_BLT  = 4'b1100,
        OP_BGE  = 4'b1101;

    always_comb begin
        // Atribuição de um valor padrão inicial para a saída.
        // Isso garante que 'Operation' sempre tenha um valor definido.
        Operation = OP_AND;

        if (ALUOp == 2'b00) begin // ADD para cálculo de endereço
            Operation = OP_ADD;
        end

        else if (ALUOp == 2'b01) begin // Instruções de desvio (branches)
            unique case (Funct3)
                3'b000: Operation = OP_BEQ; // BEQ
                3'b001: Operation = OP_BNE; // BNE
                3'b100: Operation = OP_BLT; // BLT
                3'b101: Operation = OP_BGE; // BGE
                default: Operation = OP_AND;
            endcase
        end

        else if (ALUOp == 2'b10) begin
            // Tipo-R e Tipo-I
            unique case (Funct3)
                3'b000: begin
                    if (Funct7 == 7'b0100000) begin
                        Operation = OP_SUB; // SUB
                    end 
                    
                    else begin
                        Operation = OP_ADD; // ADD / ADDI
                    end
                end

                3'b001: Operation = OP_SLL;  // SLL / SLLI
                3'b010: Operation = OP_BLT;  // SLT / SLTI (usa mesmo código do BLT)
                3'b100: Operation = OP_XOR;  // XOR / XORI
                
                3'b101: begin
                    if (Funct7 == 7'b0100000) begin
                        Operation = OP_SRA; // SRA (Tipo-R específico)
                    end 
                    
                    else begin
                        Operation = OP_SRL; // SRL / SRLI
                    end
                end

                3'b110: Operation = OP_OR;   // OR / ORI
                3'b111: Operation = OP_AND;  // AND / ANDI

                default: Operation = OP_AND; // Caso padrão para Funct3 desconhecido
            endcase
        end

        else begin
            // ALUOp inválido
            Operation = OP_AND;
        end
    end
endmodule