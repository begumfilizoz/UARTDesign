`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 08:52:49 PM
// Design Name: 
// Module Name: button_debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: https://community.intel.com/t5/Programmable-Devices/Debouncer-verilog-code/td-p/90838
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module button_debouncer(
    input wire clk,
    input wire btn1,
    output reg btn2
);
 parameter N = 8;
 reg [N:0] sft;
 always @ (posedge clk) 
 begin
   sft <= {sft ,btn1};
   if(~|sft)
     btn2 <= 1'b0;
   else if(&sft)
     btn2 <= 1'b1;
   else btn2 <= btn2;
 end
 endmodule
