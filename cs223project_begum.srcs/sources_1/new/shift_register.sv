`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 11:24:00 PM
// Design Name: 
// Module Name: shift_register
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

module shift_register #(parameter N = 8)
    (input logic clk,
    input logic reset, 
    input logic load,
    input logic sin,
    input logic [N-1:0] d,
    input logic sreg_en,
    output logic [N-1:0] q,
    output logic sout);  
always_ff @(posedge clk)
    if (reset) q <= 0;
    else if (load) q <= d;
    else if (sreg_en) q <= {sin, q[N-1:1]};
    assign sout = q[0];
endmodule