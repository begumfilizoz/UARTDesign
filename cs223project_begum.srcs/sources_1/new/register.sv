`timescale 1ns / 1ps
module register #(parameter N = 8)(input logic clk,
    input logic reset,
    input logic ld,
    input logic [N-1:0] d,
    output logic [N-1:0] q);
// asynchronous reset
always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else if (ld) q <= d;
endmodule