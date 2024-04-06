`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 07:40:23 PM
// Design Name: 
// Module Name: stage2_transmitter
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


module stage3_transmitter #(parameter N = 8)(
    input logic clkO,
    input logic reset,
    input logic btn_d,
    input logic btn_c,
    input logic mode,
    input logic [N-1:0] data,
    output logic [N-1:0] data2,
    output logic tx,
    output reg [N-1:0] TXBUF [3:0]
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
    
    register treg(clkO, treg_clr, treg_ld, data, data2); 
    shift_register sreg(clkO, sreg_clr, sreg_ld, 0, TXBUF[3], sreg_en, outData, sout);
    counter_comparator counter(cnt, counter_clr, clkO, counter_lt_N);
    reg [1:0] loop;
    
    typedef enum logic [4:0] {init, idle, wait_abit, load_treg, load_wait, wait_sreg, start, shift, stop1, stop2, stop3, stop4, stop5, stop6, last0} statetype;
statetype state, nextstate;
always_ff@(posedge clkO)
    if(reset) state <= init;
    else state <= nextstate;

always_comb
    case(state)
        init: nextstate = idle;
        idle: if (btn_d) nextstate = wait_abit;
              else if (btn_c) nextstate = start;
               else nextstate = idle;
        wait_abit: if (btn_d) nextstate = wait_abit;
                    else nextstate = load_treg;
        load_treg: nextstate = load_wait;
        load_wait: nextstate = wait_sreg;
        wait_sreg: if (btn_d) nextstate = wait_abit;
               else if (btn_c) nextstate = start;
               else           nextstate = wait_sreg;
        start: nextstate = shift;
        shift: if (counter_lt_N) nextstate = shift;
               else nextstate = stop1;
        stop1: nextstate = stop2;
        stop2: if ((mode) & (loop >= 2'b11)) nextstate = last0;
        else if (!mode) nextstate = stop3;
        else nextstate = stop4;
        stop4: nextstate = stop5;
        stop5: nextstate = stop6;
        stop6: nextstate = start;
        last0: nextstate = stop3;
        stop3: if (btn_c) nextstate = stop3;
               else nextstate = idle;
        default: nextstate = init;
     endcase
     

always_comb
    case(state)
        init: begin
        treg_clr = 1; sreg_clr = 1; tx = 1; cnt = 0; sreg_en = 0; counter_clr = 1; treg_ld = 0; sreg_ld = 0;
        end
        idle: begin
        tx = 1; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; treg_ld = 0; sreg_ld = 0;
        end
        wait_abit: begin
        tx = 1; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; treg_ld = 0; sreg_ld = 0;
        end
        load_treg: begin
        tx = 1; treg_ld = 1; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        load_wait: begin
        tx = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        wait_sreg: begin
        tx = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        start: begin
        tx = 0; sreg_ld = 1; counter_clr = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0;
        end
        shift: begin
        sreg_en = 1; tx = sout; cnt = 1; sreg_ld = 0; counter_clr = 0; treg_ld = 0; treg_clr = 0; sreg_clr = 0;
        end
        stop1: begin
        tx = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        stop2: begin
        tx = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        stop3: begin
        tx = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        stop4: begin
        tx = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        stop5: begin
        tx = 1; treg_ld = 0; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        stop6: begin
        tx = 1; treg_ld = 1; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        last0: begin
        tx = 1; treg_ld = 1; treg_clr = 0; sreg_clr = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
        default: begin
        treg_clr = 1; sreg_clr = 1; tx = 1; treg_ld = 0; cnt = 0; sreg_en = 0; counter_clr = 0; sreg_ld = 0;
        end
     endcase  

always_ff@ (posedge clkO)
begin
if (state == init) begin
TXBUF[0] = 0; TXBUF[1] = 0; TXBUF[2] = 0; TXBUF[3] = 0; 
end
else if (state == idle) begin
loop = 2'b00;
end
else if (state == stop4)
begin 
loop = loop + 1;
end
else if (state == load_wait) begin
TXBUF[0] <= data2;
TXBUF[1] <= TXBUF[0];
TXBUF[2] <= TXBUF[1];
TXBUF[3] <= TXBUF[2];
end
else if (state == stop6 | state == last0) begin
TXBUF[0] <= 0;
TXBUF[1] <= TXBUF[0];
TXBUF[2] <= TXBUF[1];
TXBUF[3] <= TXBUF[2];
end

end
    
endmodule
