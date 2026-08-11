module instruction_register(
    input clk,
    input rst,
    input [7:0] instruction_in,
    output reg [7:0] instruction_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        instruction_out <= 8'd0;
    else
        instruction_out <= instruction_in;
end

endmodule
