`timescale 1ns / 1ps

module Controller (
    // Entrada
    input  logic [6:0] Opcode,   // Campo opcode de 7 bits da instrução

    // Saídas
    output logic       ALUSrc,
    output logic       MemtoReg,
    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic [1:0] ALUOp,
    output logic       Branch
);

    always_comb begin
        // Inicia todos os sinais de controle em um estado padrão "inativo".
        {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = '0;

        // Usa uma instrução 'case' para decodificar o opcode.
        case (Opcode)
            7'b0110011: begin // Instruções Tipo-R (add, sub, etc.)
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end

            7'b0010011: begin // Instruções Tipo-I (addi, slti, etc.)
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end

            7'b0000011: begin // Instrução LW (Load Word)
                ALUSrc   = 1'b1;
                MemtoReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                ALUOp    = 2'b00;
            end

            7'b0100011: begin // Instrução SW (Store Word)
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = 2'b00;
            end

            7'b1100011: begin // Instruções de desvio (BEQ, BNE, BLT, BGE)
                Branch = 1'b1;
                ALUOp  = 2'b01;
            end

            default: begin
                {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = '0;
            end
        endcase
    end

endmodule