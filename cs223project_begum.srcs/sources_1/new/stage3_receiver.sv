`timescale 1ns / 1ps
module stage3_receiver #(parameter N = 8)(
    input logic clkO,
    input logic rx,
    input logic reset,
    output logic [N-1:0] dataOut,
    reg [N-1:0] RXBUF [3:0]
);
    
    logic count;
    logic countClr;
    logic shiftLd;
    logic shiftClr;
    logic shiftEn;
    logic counter_lt_N;
    logic recLd;
    logic recClr;
    logic sout;
    logic [N-1:0] data;
    counter_comparator cc(count, countClr, clkO, counter_lt_N);
    shift_register sr(clkO, shiftClr, shiftLd, rx, 0, shiftEn, data, sout);
    register recReg(clkO, recClr, recLd, RXBUF[3], dataOut );
    
typedef enum logic [2:0] {init, idle, shift, stop1, stop2, load} statetype;
statetype state, nextstate;
always_ff@(posedge clkO)
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
        count = 0; shiftEn = 0; recClr = 1; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        idle: begin
        count = 0; shiftEn = 0; recClr = 0; shiftClr = 1; countClr = 1; recLd = 0; shiftLd = 0;
        end
        shift: begin
        count = 1; shiftEn = 1; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        stop1: begin
        count = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        stop2: begin
        count = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
        load: begin
        count = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 1; shiftLd = 0;
        end
        default: begin
        count = 0; shiftEn = 0; recClr = 0; shiftClr = 0; countClr = 0; recLd = 0; shiftLd = 0;
        end
     endcase  
     
always_ff@ (posedge clkO)

if (state == init) begin
RXBUF[0] = 0; RXBUF[1] = 0; RXBUF[2] = 0; RXBUF[3] = 0; 
end
else if (state == load) begin
RXBUF[0] <= data;
RXBUF[1] <= RXBUF[0];
RXBUF[2] <= RXBUF[1];
RXBUF[3] <= RXBUF[2];
end


endmodule
