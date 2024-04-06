`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 02:01:12 PM
// Design Name: 
// Module Name: counter_comparator
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


module counter_comparator #(parameter N = 8)(
input logic cnt,
input logic clr,
input logic clk,
output logic counter_lt_N
    );

logic [N-1:0] q;
always_ff @(posedge clk)
    if (clr) q <= 0;
    else if(cnt) q <= q + 1;

assign counter_lt_N = (q < N - 1);
endmodule

