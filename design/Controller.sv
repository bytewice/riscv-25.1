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
    output logic       Branch,
    output logic       Jump,
    output logic [1:0] JumpType,
    output logic       Halt
);

    typedef enum logic [6:0]{
        OP_RTYPE   = 7'b0110011,  // Instruções tipo R
        OP_ITYPE   = 7'b0010011,  // Instruções tipo I
        OP_LOAD    = 7'b0000011,  // lw, lh, lb
        OP_STORE   = 7'b0100011,  // sw, sh, sb
        OP_BRANCH  = 7'b1100011,  // beq, bne, etc.
        OP_JAL     = 7'b1101111,  // JAL
        OP_JALR    = 7'b1100111,  // JALR
        OP_HALT    = 7'b1111111   // HALT fictício  
    } opcode_t;

    opcode_t op;

    always_comb begin
       op = opcode_t'(Opcode);

        // Sinais padrão
        ALUSrc    = 1'b0;
        MemtoReg  = 1'b0;
        RegWrite  = 1'b0;
        MemRead   = 1'b0;
        MemWrite  = 1'b0;
        ALUOp     = 2'b00;
        Branch    = 1'b0;
        Jump      = 1'b0;
        JumpType  = 2'b00;
        Halt      = 1'b0;

        unique case (op)
            OP_RTYPE: begin
                RegWrite = 1'b1;
                ALUOp    = 2'b10; // Operações aritméticas/lógicas
            end

            OP_ITYPE: begin
                ALUSrc   = 1'b1; // Fonte de imediato
                RegWrite = 1'b1; // Escrita no registrador
                ALUOp    = 2'b10; // Operações aritméticas/lógicas
            end

            OP_LOAD: begin
                ALUSrc   = 1'b1; // Fonte de imediato
                RegWrite = 1'b1; // Escrita no registrador
                MemRead  = 1'b1; // Leitura da memória
                MemtoReg = 1'b1; // Dados lidos vão para o registrador
                ALUOp    = 2'b00; // Operações de memória
            end

            OP_STORE: begin
                ALUSrc   = 1'b1; // Fonte de imediato
                MemWrite = 1'b1; // Escrita na memória
                ALUOp    = 2'b00; // Operações de memória
            end

            OP_BRANCH: begin
                Branch   = 1'b1; // Sinal de branch ativo
                ALUOp    = 2'b01; // Operações de comparação para branchs
            end

            OP_JAL: begin
                RegWrite = 1'b1; // Escrita no registrador (endereço de retorno)
                Jump     = 1'b1; // Sinal de salto ativo
                JumpType = 2'b01; // Tipo de salto JAL
            end

            OP_JALR: begin
                ALUSrc   = 1'b1; // Fonte de imediato para JALR
                RegWrite = 1'b1; // Escrita no registrador (endereço de retorno)
                Jump     = 1'b1; // Sinal de salto
                JumpType = 2'b10; // Tipo de salto JALR
            end

            OP_HALT: begin
                Halt = 1'b1; // Sinal de parada ativo
            end

            default: begin
            end
        endcase
    end
endmodule
