`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 05:45:15 PM
// Design Name: 
// Module Name: two_transmitterFSM
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

module transmitterFSM #(parameter N = 8)(
    input logic clk,
    input logic reset,
    input logic btn_d,
    input logic btn_c,
    input logic counter_lt_N,
    input logic sout,
    output logic cnt,
    output logic tx,
    output logic shiftEn,
    output logic transClr,
    output logic shiftClr,
    output logic countClr,
    output logic transLd,
    output logic shiftLd
    
    );
    
typedef enum logic [2:0] {init, idle, load_treg, wait_sreg, start, shift, stop1, stop2} statetype;
statetype state, nextstate;
always_ff@(posedge clk, posedge reset)
    if(reset) state <= init;
    else state <= nextstate;

always_comb
    case(state)
        init: nextstate = idle;
        idle: if (btn_d) nextstate = load_treg;
               else nextstate = idle;
        load_treg: nextstate = wait_sreg;
        wait_sreg: if (btn_c) nextstate = start;
               else nextstate = wait_sreg;
        start: nextstate = shift;
        shift: if (counter_lt_N) nextstate = shift;
               else nextstate = stop1;
        stop1: nextstate = stop2;
        stop2: nextstate = idle;
        default: nextstate = init;
     endcase
     

always_comb
    case(state)
        init: begin
        transClr = 1; shiftClr = 1; tx = 1; cnt = 0; shiftEn = 0; countClr = 0; transLd = 0; shiftLd = 0;
        end
        idle: begin
        tx = 1; transClr = 0; shiftClr = 0; cnt = 0; shiftEn = 0; countClr = 0; transLd = 0; shiftLd = 0;
        end
        load_treg: begin
        tx = 1; transLd = 1; transClr = 0; shiftClr = 0; cnt = 0; shiftEn = 0; countClr = 0; shiftLd = 0;
        end
        wait_sreg: begin
        tx = 1; transLd = 0; transClr = 0; shiftClr = 0; cnt = 0; shiftEn = 0; countClr = 0; shiftLd = 0;
        end
        start: begin
        tx = 0; shiftLd = 1; countClr = 1; transLd = 0; transClr = 0; shiftClr = 0; cnt = 0; shiftEn = 0;
        end
        shift: begin
        shiftEn = 1; tx = sout; cnt = 1; shiftLd = 0; countClr = 0; transLd = 0; transClr = 0; shiftClr = 0;
        end
        stop1: begin
        tx = 1; transLd = 0; transClr = 0; shiftClr = 0; cnt = 0; shiftEn = 0; countClr = 0; shiftLd = 0;
        end
        stop2: begin
        tx = 1; transLd = 0; transClr = 0; shiftClr = 0; cnt = 0; shiftEn = 0; countClr = 0; shiftLd = 0;
        end
        default: begin
        transClr = 1; shiftClr = 1; tx = 1; transLd = 0; cnt = 0; shiftEn = 0; countClr = 0; shiftLd = 0;
        end
     endcase  

endmodule