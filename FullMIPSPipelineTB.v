`timescale 1ns / 1ps

module FullMIPSPipelineTB();
    reg clk;
    reg rst;

    FullMIPSPipeline uut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        rst = 1;
        #10 rst = 0;

        #1000 $finish;
    end
endmodule

