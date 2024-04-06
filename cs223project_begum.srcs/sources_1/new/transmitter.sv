`timescale 1ns / 1ps
module transmitter #(parameter N = 8) (
    input logic clk,
    input logic reset,
    input logic btn_d,
    input logic btn_c,
    input logic [N-1:0] data,
    output logic [N-1:0] data2,
    output logic tx
);
    logic [N-1:0] outData;
    logic treg_ld;
    logic treg_clr;
    logic sreg_ld;
    logic sreg_clr;
    logic counter_lt_N;
    logic sin;
    logic sout;
    logic cnt;
    logic sreg_en;
    logic counter_clr;
    logic clkO;
    clock_generator cg(clk, clkO);
    transmitterHLSM datapath(clkO, data, treg_ld, treg_clr, sreg_ld, sreg_clr, cnt, counter_clr, sreg_en, sout, counter_lt_N, outData, data2);
    transmitterFSM controller(clkO, reset, btn_d, btn_c, counter_lt_N, sout, cnt, tx, sreg_en, treg_clr, sreg_clr, counter_clr, treg_ld, sreg_ld);
endmodule