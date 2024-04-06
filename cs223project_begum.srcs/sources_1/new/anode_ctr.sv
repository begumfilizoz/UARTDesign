`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 10:39:51 AM
// Design Name: 
// Module Name: anode_ctr
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


module anode_ctr(
input [3:0] binnum,
output reg [6:0] display
    );
always@(binnum)
begin 
    case(binnum)
        4'b0000:
            display = 7'b1000000;
        4'b0001:
            display = 7'b1111001;
        4'b0010:
            display = 7'b0100100;
        4'b0011:
            display = 7'b0110000;
        4'b0100:
            display = 7'b0011001;   
        4'b0101:
            display = 7'b0010010;
        4'b0110:
            display = 7'b0000010;  
        4'b0111:
            display = 7'b1111000;
        4'b1000:
            display = 7'b0000000;
        4'b1001:
            display = 7'b0010000; 
        4'b1010:
            display = 7'b0001000;   
        4'b1011:
            display = 7'b0000011; 
        4'b1100:
            display = 7'b1000110;   
        4'b1101:
            display = 7'b0100001;  
        4'b1110:
            display = 7'b0000110; 
        4'b1111:
            display = 7'b0001110;
        default: display = 7'b1111111;                   
   endcase
end
endmodule
