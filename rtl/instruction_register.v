module instruction_register(

    input clk,
    input rst,
    input ir_load,
    input [7:0] instruction_in,

    output reg [7:0] instruction_out

);

always @(posedge clk or posedge rst) begin

    if(rst)
        instruction_out <= 8'd0;

    else if (ir_load)
        instruction_out <= instruction_in;

end

endmodule
