`timescale 1ns / 1ps

module FullMIPSPipeline(
    input wire clk,
    input wire rst
);

    // IF -> ID wires
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    // ID -> EX wires
    wire [1:0]  id_ex_wb;
    wire [2:0]  id_ex_mem;
    wire [3:0]  id_ex_execute;
    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdat1;
    wire [31:0] id_ex_readdat2;
    wire [31:0] id_ex_sign_ext;
    wire [4:0]  id_ex_instr_bits_20_16;
    wire [4:0]  id_ex_instr_bits_15_11;

    // EX -> MEM & IF wires
    wire [1:0]  ex_mem_wb;
    wire [2:0]  ex_mem_mem;
    wire [31:0] ex_mem_adder_out;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rdata2;
    wire        ex_mem_zero;
    wire [4:0]  ex_mem_write_reg;

    // MEM -> WB & IF wires
    wire [31:0] mem_wb_read_data;
    wire [31:0] mem_wb_alu_result;
    wire [4:0]  mem_wb_write_reg;
    wire [1:0]  mem_wb_ctl;
    wire        mem_pc_src;

    // WB -> ID wire
    wire [31:0] wb_write_data;

    // 1. Instruction Fetch Stage
    fetch f1(
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(mem_pc_src),
        .ex_mem_npc(ex_mem_adder_out),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );

    // 2. Instruction Decode Stage
    decode d1(
        .clk(clk),
        .rst(rst),
        .wb_reg_write(mem_wb_ctl[1]),               // RegWrite
        .wb_write_reg_location(mem_wb_write_reg),
        .mem_wb_write_data(wb_write_data),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc),
        .id_ex_wb(id_ex_wb),
        .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc),
        .id_ex_readdat1(id_ex_readdat1),
        .id_ex_readdat2(id_ex_readdat2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
    );

    // 3. Execute Stage
    // id_ex_execute = {RegDst, ALUOp[1:0], ALUSrc}
    execute e1(
        .clk(clk),
        .ctlwb_in(id_ex_wb),
        .ctlm_in(id_ex_mem),
        .npc(id_ex_npc),
        .rdata1(id_ex_readdat1),
        .rdata2(id_ex_readdat2),
        .s_extend(id_ex_sign_ext),
        .instr_2016(id_ex_instr_bits_20_16),
        .instr_1511(id_ex_instr_bits_15_11),
        .alu_op(id_ex_execute[2:1]),
        .funct(id_ex_sign_ext[5:0]),                // Lower 6 bits of instruction
        .alusrc(id_ex_execute[0]),
        .regdst(id_ex_execute[3]),
        .ctlwb_out(ex_mem_wb),
        .ctlm_out(ex_mem_mem),
        .adder_out(ex_mem_adder_out),
        .alu_result_out(ex_mem_alu_result),
        .rdata2_out(ex_mem_rdata2),
        .zero(ex_mem_zero),
        .muxout_out(ex_mem_write_reg)
    );

    // 4. Memory Stage
    // ex_mem_mem = {Branch, MemRead, MemWrite}
    MEMORY m1(
        .clk(clk),
        .ALUResult(ex_mem_alu_result),
        .WriteData(ex_mem_rdata2),
        .WriteReg(ex_mem_write_reg),
        .WBControl(ex_mem_wb),
        .MemWrite(ex_mem_mem[0]),
        .MemRead(ex_mem_mem[1]),
        .Branch(ex_mem_mem[2]),
        .Zero(ex_mem_zero),
        .ReadData(mem_wb_read_data),
        .ALUResult_out(mem_wb_alu_result),
        .WriteReg_out(mem_wb_write_reg),
        .WBControl_out(mem_wb_ctl),
        .PCSrc(mem_pc_src)
    );

    // 5. Writeback Stage
    // sel = MemtoReg (1 -> ReadData, 0 -> ALUResult)
    wb_mux w1(
        .y(wb_write_data),
        .a(mem_wb_read_data),
        .b(mem_wb_alu_result),
        .sel(mem_wb_ctl[0])
    );

endmodule
