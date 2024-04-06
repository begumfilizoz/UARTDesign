`timescale 1ns / 1ps
module receiver #(parameter N = 8)(
    input logic clk,
    input logic rx,
    input logic reset,
    output logic [N-1:0] dataOut
);
    logic count;
    logic clkO;
    logic countClr;
    logic shiftLd;
    logic shiftClr;
    logic shiftEn;
    logic counter_lt_N;
    logic recLd;
    logic recClr;
    logic sout;
    logic [N-1:0] data;
    clock_generator cg(clk, clkO);
    receiverHLSM hlsm(clkO, count, countClr, shiftLd, shiftClr, shiftEn, rx, recLd, recClr, sout, counter_lt_N, data, dataOut );
    receiverFSM fsm(clkO, reset, rx, counter_lt_N, count, shiftEn, recClr, shiftClr, countClr, recLd, shiftLd);
endmodule