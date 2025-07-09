`timescale 1ns / 1ps

module ALUController_Corrigido (
    // Entradas
    input logic [1:0] ALUOp,
    input logic [6:0] Funct7,
    input logic [2:0] Funct3,

    // Saída
    output logic [3:0] Operation
);

    // A saída 'Operation' precisa ser do tipo 'reg' para poder
    // receber atribuições dentro de um bloco 'always'.

    // Usando always@(*) para descrever lógica combinacional.
    // A lista de sensibilidade (*) garante que o bloco será reavaliado
    // sempre que qualquer um dos sinais lidos (ALUOp, Funct7, Funct3) mudar.
    always @(*) begin
        // A lógica foi reestruturada para usar 'if-else if' em vez de 'case'.
        // É uma boa prática definir um valor padrão no início para cobrir todos
        // os casos e evitar a inferência de latches.
        if (ALUOp == 2'b00) begin
            // LW/SW: A ALU deve realizar uma SOMA para o cálculo do endereço.
            Operation = 4'b0010;
        end
        else if (ALUOp == 2'b01) begin
            // Branch: A ALU realiza uma operação para a verificação do desvio.
            Operation = 4'b1000;
        end
        else if (ALUOp == 2'b10) begin
            // Para instruções do Tipo-R e Tipo-I, a operação depende de Funct3/Funct7.
            if (Funct3 == 3'b000) begin
                if (Funct7 == 7'b0100000)
                    Operation = 4'b0110; // SUB
                else
                    Operation = 4'b0010; // ADD/ADDI
            end
            else if (Funct3 == 3'b001) begin
                Operation = 4'b0011; // SLL/SLLI
            end
            else if (Funct3 == 3'b010) begin
                Operation = 4'b1100; // SLT/SLTI
            end
            else if (Funct3 == 3'b100) begin
                Operation = 4'b0100; // XOR/XORI
            end
            else if (Funct3 == 3'b101) begin
                if (Funct7 == 7'b0100000)
                    Operation = 4'b1010; // SRA (Shift Right Arithmetic)
                else
                    Operation = 4'b0101; // SRL/SRLI (Shift Right Logical)
            end
            else if (Funct3 == 3'b110) begin
                Operation = 4'b0001; // OR/ORI
            end
            else if (Funct3 == 3'b111) begin
                Operation = 4'b0000; // AND/ANDI
            end
            else begin
                // Cobre outros valores de Funct3 (caso de default do 'case' original)
                Operation = 4'b0000;
            end
        end
        else begin
            // Cobre outros valores de ALUOp (ex: 2'b11)
            Operation = 4'b0000;
        end
    end

endmodule