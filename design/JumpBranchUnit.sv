`timescale 1ns / 1ps

module JumpBranchUnit #(
    parameter int PC_W = 9
) (
    input  logic [PC_W-1:0] CurPC,         // Valor atual do PC (parcial)
    input  logic [31:0]     Imm,           // Imediato (sign-extendido)
    input  logic [31:0]     RegBase,       // Conteúdo do rs1 (para JALR)
    input  logic            Branch,        // Sinal de branch habilitado
    input  logic            Jump,          // Sinal de jump habilitado
    input  logic [1:0]      JumpTypeCode,  // 00: normal, 01: JAL, 10: JALR
    input  logic [31:0]     ALUFlag,       // Resultado da ALU para condição de branch
    output logic [31:0]     PCPlusImm,     // PC + Imm (para branch ou JAL)
    output logic [31:0]     PCPlus4,       // PC + 4 (incremento padrão)
    output logic [31:0]     NextPC,        // Próximo valor de PC escolhido
    output logic [31:0]     PCPlus4Out,    // PC + 4 salvo no registrador
    output logic            PcSel          // 1: salto/desvio; 0: sequência normal
);

    typedef enum logic [1:0] {
        JUMP_NONE = 2'b00,
        JUMP_JAL  = 2'b01,
        JUMP_JALR = 2'b10
    } JumpKind_t;

    JumpKind_t JumpKind;

    logic [31:0] PC32;
  
    assign PC32       = { {(32-PC_W){1'b0}}, CurPC };
    assign PCPlus4    = PC32 + 32'd4;
    assign PCPlus4Out = PCPlus4;
    assign PCPlusImm  = PC32 + Imm;

    // Cálculo do alvo de JALR
    logic [31:0] JALRTarget;
    assign JALRTarget = (RegBase + Imm) & 32'hFFFFFFFE;

    // Conversão do tipo de jump
    always_comb JumpKind = JumpKind_t'(JumpTypeCode);

    // Seleção do próximo PC (NextPC)
    always_comb begin
        unique case (JumpKind)
            JUMP_JAL:  NextPC = PCPlusImm;
            JUMP_JALR: NextPC = JALRTarget;
            default: begin
                if (Branch && ALUFlag[0])
                    NextPC = PCPlusImm;
                else
                    NextPC = PCPlus4;
            end
        endcase
    end

    // Seleção final do PC: 1 se desvio ou jump for tomado
    assign PcSel = Jump || (Branch && ALUFlag[0]);
endmodule