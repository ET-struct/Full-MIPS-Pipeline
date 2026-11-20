`timescale 1ns / 1ps

module instrMem(
    input clk,
    input rst,
    input [31:0] addr,
    output [31:0] data
);

    reg [31:0] mem [0:255];
    integer i;

    initial begin
        // Pre-fill memory with NOP (opcode 6'b100000 from control.v)
        // so instructions draining past the end of instr.txt do not inject X
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h80000000;
        end

        // Load program instructions from instr.txt
        $readmemb("instr.mem", mem);

        // Optional console check in Vivado Tcl Console
        for (i = 0; i < 24; i = i + 1) begin
            $display("\tIMEM[%0d] = %0b", i, mem[i]);
        end
    end

    // Output NOP if addr is out of bounds or X before reset settles
    assign data = (addr < 32'd256) ? mem[addr[7:0]] : 32'h80000000;

endmodule
