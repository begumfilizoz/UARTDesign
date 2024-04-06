`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 12:31:05 PM
// Design Name: 
// Module Name: stage3
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


module stage3 #(parameter N = 8)(
    input logic clk,
    input logic reset,
    input logic rx,
    input logic btnd,
    input logic btnc,
    input logic btnl,
    input logic btnr,
    input logic btnu,
    input logic [N-1:0] data,
    output logic tx,
    output logic [6:0] seg,
    output logic [3:0] an,
    output logic [N-1:0] data2,
    output logic whichMem,
    output logic [1:0] page
    );
//    assign page [0] = 0;
//    assign page[1] = 1;
    logic [N-1:0] dataOut;
    reg [N-1:0] RXBUF [3:0];
    reg [N-1:0] TXBUF [3:0];
    int num0 = 2'b00;
    int num1 = 2'b01;
    int num2 = 2'b10;
    int num3 = 2'b11;
    reg [3:0] dig1, dig2, dig3, dig4;
    reg [1:0] count;
    logic clkO;
    clock_generator cg(clk, clkO);
    logic btn_u;
    logic btn_d;
    logic btn_c;
    logic btn_l;
    logic btn_r;
    button_debouncer bd1(clk, btnu, btn_u);
    button_debouncer bd2(clk, btnd, btn_d);
    button_debouncer bd3(clk, btnl, btn_l);
    button_debouncer bd4(clk, btnr, btn_r);
    button_debouncer bd5(clk, btnc, btn_c);
//    always@ (*)
//    begin
//    case (whichMem)
//    0: begin 
//    dig1 = TXBUF[1][3:0];    
//    dig2 = TXBUF[1][7:4];    
//    dig3 = TXBUF[0][3:0];    
//    dig4 = TXBUF[0][7:4];
//    end
//    endcase
//    end
    
    always@(posedge clkO)
    begin 
    if (reset)
        count <= 0;
    else 
        count <= count + 1; 
    end
    
    reg [3:0] NumAn;
    reg [3:0] anTemp;
    
    always@ (*)
    begin
        case(count[1:0])
        2'b00: begin
        
        NumAn = dig1;
        anTemp = 4'b1110;
        end
        2'b01: begin
        
        NumAn = dig2;
        anTemp = 4'b1101;
        end
        2'b10: begin
        
        NumAn = dig3;
        anTemp = 4'b1011;
        end
        2'b11: begin
        
        NumAn = dig4;
        anTemp = 4'b0111;
        end
        endcase
        end
    
    assign an = anTemp; 
    anode_ctr ac (NumAn, seg);
    stage3_transmitter trans(clkO, reset, btn_d, btn_c, data, data2, tx, TXBUF);
    
    stage3_receiver rec(clkO, rx, reset, dataOut, RXBUF);
    
    typedef enum logic  [3:0] {t1, t2, t3, t4, t5, t6, r1, r2, r3, r4, r5, r6} statetype;
    statetype[1:0] state, nextstate;
    
    always_ff@(posedge clkO)
        if (reset) state <= t1;
        else state <= nextstate;
    always_comb
        case (state)
        t1: if (btn_u) nextstate = r1;
        else if (btn_r | btn_l) nextstate = t2;
        else nextstate = t1;
        t2: if (btn_r | btn_l) nextstate = t2;
        else nextstate = t3;
        t3: if (btn_u) nextstate = r6; 
        else if (btn_r | btn_l) nextstate = t4;
        else nextstate = t3;
        t4: if (btn_r | btn_l) nextstate = t4;
        else nextstate = t1;
        t5: if (btn_u) nextstate = t5;
        else nextstate = t3;
        t6: if (btn_u) nextstate = t6;
        else nextstate = t1;
        r1: if (btn_u) nextstate = r1;
        else nextstate = r2;
        r2: if (btn_u) nextstate = t6;
        else if (btn_r | btn_l) nextstate = r3;
        else nextstate = r2;
        r3: if (btn_r | btn_l) nextstate = r3;
        else nextstate = r4;
        r4: if (btn_u) nextstate = t5; 
        else if (btn_r | btn_l) nextstate = r5;
        else nextstate = r4;
        r5: if (btn_r | btn_l) nextstate = r5;
        else nextstate = r2;
        r6: if (btn_u) nextstate = r6;
        else nextstate = r4;
        default: if (btn_u) nextstate = r1;
        else if (btn_r | btn_l) nextstate = t2;
        else nextstate = t1;
    endcase  
    
    always@ (*)
    begin 
        case (state)
        t1: begin 
        whichMem = 0;
        dig1 = TXBUF[1][3:0];    
        dig2 = TXBUF[1][7:4];    
        dig3 = TXBUF[0][3:0];    
        dig4 = TXBUF[0][7:4];
        page[0] = 0;
        page[1] = 1;
        end
        t2: begin 
        whichMem = 0;
        dig1 = TXBUF[3][3:0];    
        dig2 = TXBUF[3][7:4];    
        dig3 = TXBUF[2][3:0];    
        dig4 = TXBUF[2][7:4];
        page[0] = 1;
        page[1] = 0;
        end
        t3: begin 
        whichMem = 0;
        dig1 = TXBUF[3][3:0];    
        dig2 = TXBUF[3][7:4];    
        dig3 = TXBUF[2][3:0];    
        dig4 = TXBUF[2][7:4];
        page[0] = 1;
        page[1] = 0;
        end
        t4: begin 
        whichMem = 0;
        dig1 = TXBUF[1][3:0];    
        dig2 = TXBUF[1][7:4];    
        dig3 = TXBUF[0][3:0];    
        dig4 = TXBUF[0][7:4];
        page[0] = 0;
        page[1] = 1;
        end
        t5: begin 
        whichMem = 0;
        dig1 = TXBUF[3][3:0];    
        dig2 = TXBUF[3][7:4];    
        dig3 = TXBUF[2][3:0];    
        dig4 = TXBUF[2][7:4];
        page[0] = 1;
        page[1] = 0;
        end
        t6: begin 
        whichMem = 0;
        dig1 = TXBUF[1][3:0];    
        dig2 = TXBUF[1][7:4];    
        dig3 = TXBUF[0][3:0];    
        dig4 = TXBUF[0][7:4];
        page[0] = 0;
        page[1] = 1;
        end
        r1: begin 
        whichMem = 1;
        dig1 = RXBUF[1][3:0];    
        dig2 = RXBUF[1][7:4];    
        dig3 = RXBUF[0][3:0];    
        dig4 = RXBUF[0][7:4];
        page[0] = 0;
        page[1] = 1;
        end
        r2: begin 
        whichMem = 1;
        dig1 = RXBUF[1][3:0];    
        dig2 = RXBUF[1][7:4];    
        dig3 = RXBUF[0][3:0];    
        dig4 = RXBUF[0][7:4];
        page[0] = 0;
        page[1] = 1;
        end
        r3: begin 
        whichMem = 1;
        dig1 = RXBUF[3][3:0];    
        dig2 = RXBUF[3][7:4];    
        dig3 = RXBUF[2][3:0];    
        dig4 = RXBUF[2][7:4];
        page[0] = 1;
        page[1] = 0;
        end
        r4: begin 
        whichMem = 1;
        dig1 = RXBUF[3][3:0];    
        dig2 = RXBUF[3][7:4];    
        dig3 = RXBUF[2][3:0];    
        dig4 = RXBUF[2][7:4];
        page[0] = 1;
        page[1] = 0;
        end
        r5: begin 
        whichMem = 1;
        dig1 = RXBUF[1][3:0];    
        dig2 = RXBUF[1][7:4];    
        dig3 = RXBUF[0][3:0];    
        dig4 = RXBUF[0][7:4];
        page[0] = 0;
        page[1] = 1;
        end
        r6: begin 
        whichMem = 1;
        dig1 = RXBUF[3][3:0];    
        dig2 = RXBUF[3][7:4];    
        dig3 = RXBUF[2][3:0];    
        dig4 = RXBUF[2][7:4];
        page[0] = 1;
        page[1] = 0;
        end
        default: begin 
        whichMem = 1;
        dig1 = TXBUF[1][3:0];    
        dig2 = TXBUF[1][7:4];    
        dig3 = TXBUF[0][3:0];    
        dig4 = TXBUF[0][7:4];
        page[0] = 0;
        page[1] = 1;
        end
        endcase   
    end
endmodule
