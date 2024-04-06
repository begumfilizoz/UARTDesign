`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 12:00:46 PM
// Design Name: 
// Module Name: digit_ctr
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


module digit_ctr(
input logic [1:0] an_num,
output reg [3:0] an
    );
always@(*)
begin
case(an_num)
2'b00: begin
an = 4'b1110;
end
2'b01: begin
an = 4'b1101;
end
2'b10: begin
an = 4'b1011;
end
2'b11: begin
an = 4'b0111;
end
endcase
end
endmodule
