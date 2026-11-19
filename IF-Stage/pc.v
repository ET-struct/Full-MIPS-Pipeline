`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2026 10:07:54 PM
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc(
    input clk,
    input rst,
    input [31:0] pc,
    output [31:0] pc_next
    );
    reg [31:0] tmp;
    always@(posedge clk)begin
    if(rst)begin
        tmp<=32'b0;
    end else begin
        tmp <= pc;
    end
    end
    assign pc_next = tmp;
endmodule
