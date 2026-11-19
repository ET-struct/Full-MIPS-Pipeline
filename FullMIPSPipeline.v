`timescale 1ns / 1ps

module FullMIPSPipeline(
    input clk,
    input rst
    );
    
    fetch f1(
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(),
        .ex_mem_npc(),
        .if_id_instr(),
        .if_id_npc()
    );
    
    decode d1(
        .clk(clk),
        .rst(rst),
        .wb_reg_write(),
        .wb_write_reg_location(),
        .mem_wb_write_data(),
        .if_id_instr(),
        .if_id_npc(),
        .id_ex_wb(),
        .id_ex_mem(),
        .id_ex_execute(),
        .id_ex_npc(),
        .id_ex_readdat1(),
        .id_ex_readdat2(),
        .id_ex_sign_ext(),
        .id_ex_instr_bits_20_16(),
        .id_ex_instr_bits_15_11()
    );
    
    execute e1(
        .clk(clk),
        .ctlwb_in(),
        .ctlm_in(),
        .npc(),
        .rdata1(), 
        .rdata2(),
        .s_extend(),
        .instr_2016(),
        .instr_1511(),
        .alu_op(),
        .funct(),
        .alusrc(),
        .regdst(),
        .ctlwb_out(),
        .ctlm_out(),
        .adder_out(),
        .alu_result_out(),
        .rdata2_out(),
        .zero(),
        .muxout_out()
    );
    
    MEMORY m1(
        .clk(clk),
        .ALUResult(),
        .WriteData(),
        .WriteReg(),
        .WBControl(),
        .MemWrite(),
        .MemRead(),
        .Branch(),
        .Zero(),
        .ReadData(),
        .ALUResult_out(),
        .WriteReg_out(),
        .WBControl_out(),
        .PCSrc()
    );
    
    wb_mux w1(
        .y(),
        .a(),
        .b(),
        .sel()
    );
    
    
endmodule
