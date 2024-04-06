`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 04:12:37 PM
// Design Name: 
// Module Name: transmitterHLSM
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


module transmitterHLSM #(parameter N = 8)(
    input logic clk,
    input logic [N-1:0] data,
    input logic treg_ld,
    input logic treg_clr,
    input logic sreg_ld,
    input logic sreg_clr,
    input logic cnt,
    input logic counter_clr,
    input logic sreg_en,
    output logic sout,
    output logic counter_lt_N,
    output logic [N-1:0] data3,
    output logic [N-1:0] data2
    );
    
    register treg(clk, treg_clr, treg_ld, data, data2); 
    shift_register sreg(clk, sreg_clr, sreg_ld, 0, data2, sreg_en, data3, sout);
    counter_comparator counter(cnt, counter_clr, clk, counter_lt_N);
endmodule
