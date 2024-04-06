`timescale 1ns / 1ps
module receiverHLSM #(parameter N = 8)(
    input logic clk,
    input logic count,
    input logic countClr,
    input logic shiftLd,
    input logic shiftClr,
    input logic shiftEn,
    input logic rx,
    input logic recLd,
    input logic recClr,
    output logic sout,
    output logic counter_lt_N,
    output logic [N-1:0] data,
    output logic [N-1:0] dataOut
    );
    counter_comparator cc(count, countClr, clk, counter_lt_N);
    shift_register(clk, shiftClr, shiftLd, rx, 0, shiftEn, data, sout);
    register recReg(clk, recClr, recLd, data, dataOut );
    endmodule