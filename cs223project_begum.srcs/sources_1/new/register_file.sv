`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 06:46:44 PM
// Design Name: 
// Module Name: register_file
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

module register_file #(parameter width = 8, parameter num = 4)
                    (input logic clk, input logic rst,
                     input logic [num-1:0] r_add,
                     input logic [num-1:0] w_add,
                     input logic [width-1:0] w_data,
                     input logic w_en,
                     output logic [width-1:0] r_data,
                     output logic [width-1:0] registers [num-1:0]);

    assign r_data = (r_add < num) ? registers[r_add] : {width{1'b0}};

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < num; i++) begin
                registers[i] <= {width{1'b0}};
            end
        end else if (w_en && (w_add < num)) begin
            registers[w_add] <= w_data;
        end
    end

endmodule
