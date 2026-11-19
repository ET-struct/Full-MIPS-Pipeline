`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/13/2026 09:36:15 PM
// Design Name: 
// Module Name: wb_mux
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


`timescale 1ns / 1ps
module wb_mux(
    output wire [31:0] y,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire sel
);
   
    assign y = sel ? a : b;
    
endmodule
