`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 12:31:05 PM
// Design Name: 
// Module Name: stage2
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


module stage2 #(parameter N = 8)(
    input logic clk,
    input logic reset,
    input logic rx,
    input logic btn_d,
    input logic btn_c,
    input logic [N-1:0] data,
    output logic tx,
    output logic [N-1:0] dataOut,
    output logic [N-1:0] data2
    );
    stage2_transmitter trans(clk, reset, btn_d, btn_c, data, data2, tx);
    stage2_receiver rec(clk, rx, reset, dataOut);
endmodule

