`timescale 1ns / 1ps

module tb_top;

  //clock and reset signal declaration
  logic tb_clk, reset;
  logic [31:0] tb_WB_Data;

  logic [4:0] reg_num;
  logic [31:0] reg_data;
  logic reg_write_sig;
  logic wr;
  logic rd;
  logic [8:0] addr;
  logic [31:0] wr_data;
  logic [31:0] rd_data;

  localparam CLKPERIOD = 10;
  localparam CLKDELAY = CLKPERIOD / 2;

  riscv riscV (
      .clk(tb_clk),
      .reset(reset),
      .WB_Data(tb_WB_Data),
      .reg_num(reg_num),
      .reg_data(reg_data),
      .reg_write_sig(reg_write_sig),
      .wr(wr),
      .rd(rd),
      .addr(addr),
      .wr_data(wr_data),
      .rd_data(rd_data)
  );

  initial begin
    tb_clk = 0;
    reset  = 1;
    #(CLKPERIOD);
    reset = 0;

    #(CLKPERIOD * 50);

    $stop;
  end

  // Monitor sincronizado com o clock
  always @(posedge tb_clk) begin
    if (!reset) begin
      if (reg_write_sig && reg_num != 0) begin
        $display("%0t: Register [%0d] written with value: [%0X] | [%0d]\n", 
                 $time, reg_num, reg_data, reg_data);
      end

      if (wr) begin
        $display("%0t: Memory [%0d] written with value: [%0X] | [%0d]\n", 
                 $time, addr, wr_data, wr_data);
      end

      if (rd) begin
        $display("%0t: Memory [%0d] read with value: [%0X] | [%0d]\n", 
                 $time, addr, rd_data, rd_data);
      end
    end
  end

  // Monitor alternativo assíncrono
  always @(*) begin
    if (!reset) begin
      if (reg_write_sig && reg_num != 0) begin
        $display("%0t: Register [%0d] written with value: [%0X] | [%0d]\n", 
                 $time, reg_num, reg_data, reg_data);
      end
    end
  end

  // clock generator
  always #(CLKDELAY) tb_clk = ~tb_clk;

endmodule
