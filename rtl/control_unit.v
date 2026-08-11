module control_unit(
    input clk,
    input rst,
    input [7:0] instruction,
    output reg [2:0] alu_opcode,
    output reg reg_write
);

localparam FETCH     = 2'b00;
localparam DECODE    = 2'b01;
localparam EXECUTE   = 2'b10;
localparam WRITEBACK = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge rst) begin
    if (rst)
        state <= FETCH;
    else
        state <= next_state;
end

always @(*) begin
    alu_opcode = instruction[7:5];
    reg_write  = 1'b0;
    next_state = FETCH;

    case (state)
        FETCH:     next_state = DECODE;
        DECODE:    next_state = EXECUTE;
        EXECUTE:   next_state = WRITEBACK;
        WRITEBACK: begin
            reg_write  = 1'b1;
            next_state = FETCH;
        end
        default:   next_state = FETCH;
    endcase
end

endmodule
