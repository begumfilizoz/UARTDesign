`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 02:10:49 PM
// Design Name: 
// Module Name: transmitterFSM
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


module receiverFSM #(parameter N = 8)(
    input logic clk,
    input logic reset,
    input logic rx,
    input logic counter_lt_N,
    output logic cnt,
    output logic shiftEn,
    output logic recClr,
    output logic shiftClr,
    output logic countClr,
    output logic recLd,
    output logic shiftLd
    
    );
   
typedef enum logic [2:0] {init, idle, shift, stop1, stop2, load} statetype;
statetype state, nextstate;
always_ff@(posedge clk, posedge reset)
    if(reset) state <= init;
    else state <= nextstate;

always_comb
    case(state)
        init: nextstate = idle;
        idle: if (rx) nextstate = idle;
               else nextstate = shift;
        shift: if (counter_lt_N) nextstate = shift;
               else nextstate = stop1;
        stop1: if (rx) nextstate = stop2;
               else nextstate = init;
        stop2: if (rx) nextstate = load;
               else nextstate = init;
        load: nextstate = idle;
        default: nextstate = init;
     endcase
     

always_comb
    case(state)
        init: begin
        cnt = 0; shiftEn = 0; recClr = 1; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        idle: begin
        cnt = 0; shiftEn = 0; recClr = 0; shiftClr = 1; countClr = 1; recLd = 0; shiftLd = 0;
        end
        shift: begin
        cnt = 1; shiftEn = 1; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        stop1: begin
        cnt = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        stop2: begin
        cnt = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        load: begin
        cnt = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 1; shiftLd = 0;
        end
        default: begin
        cnt = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
     endcase  

endmodule

