// Code learned from fpga4student.com
module clock_divider #(parameter N = 115200)(
c_in,
c_out,
    );
input c_in;
output reg c_out;
reg[29:0] ctr = 30'd0;
parameter div = 100000000/N;
always @(posedge c_in)
begin
    ctr <= ctr + 30'd1;
    if(ctr >= (div-1))
        ctr <= 30'd0;
// c_out <= (ctr<div/2)?1'b1:1'b0;
    if (ctr<div/2)
        c_out <= 1'b1;
    else
        c_out <= 1'b0; 
end
endmodule
