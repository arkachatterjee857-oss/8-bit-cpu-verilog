module program_counter(

    input clk,
    input rst,
    input pc_increment,
    output reg [7:0] pc

);

always @(posedge clk or posedge rst) begin

    if(rst)
        pc <= 8'd0;

    else if(pc_increment)
        pc <= pc + 1'b1;

end

endmodule
