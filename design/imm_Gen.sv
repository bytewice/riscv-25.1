`timescale 1ns / 1ps

module imm_Gen (
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);

    logic [6:0] opcode;
    logic [2:0] funct3;

    always_comb begin
        // Atribui um valor padrão no início para cobrir todos os casos
        Imm_out = 32'b0;

        // Extrai os campos relevantes da instrução para as variáveis locais.
        opcode = inst_code[6:0];
        funct3 = inst_code[14:12];

        if (opcode == 7'b0000011) begin // I-type para instruções 'load'
            // Extensão de sinal dos 12 bits do imediato
            Imm_out = {{20{inst_code[31]}}, inst_code[31:20]};

        end else if (opcode == 7'b0010011) begin // I-type para operações aritméticas/lógicas
            if (funct3 == 3'b001 || funct3 == 3'b101) begin // SLLI, SRLI, SRAI
                Imm_out = {27'b0, inst_code[24:20]};
            end else begin // ADDI, SLTI, etc.
                Imm_out = {{20{inst_code[31]}}, inst_code[31:20]};
            end

        end else if (opcode == 7'b0100011) begin // S-type para instruções 'store'
            // Monta o imediato de 12 bits com extensão de sinal a partir de dois campos.
            Imm_out = {{20{inst_code[31]}}, inst_code[31:25], inst_code[11:7]};

        end else if (opcode == 7'b1100011) begin // B-type para instruções 'branch'
            // Monta o imediato de 13 bits (com o LSB implícito como 0) com extensão de sinal.
            Imm_out = { {19{inst_code[31]}}, // Bit 12 (sinal)
                        inst_code[31],       // Bit 11
                        inst_code[7],        // Bits 10:5
                        inst_code[30:25],    // Bits 4:1
                        inst_code[11:8],     // Bit 0 (implícito)
                        1'b0
                      };
        end
    end

endmodule