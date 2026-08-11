module alu_8bit(
    input [7:0] A,
    input [7:0] B,
    input [2:0] opcode,
    output reg [7:0] result,
    output reg carry,
    output reg overflow,
    output reg zero,
    output reg negative
);

reg [8:0] temp;

always @(*) begin
    result   = 8'd0;
    carry    = 1'b0;
    overflow = 1'b0;
    temp     = 9'd0;

    case(opcode)
        3'b000: begin
            temp   = A + B;
            result = temp[7:0];
            carry  = temp[8];
        end
        3'b001: begin
            temp   = A - B;
            result = temp[7:0];
            carry  = temp[8];
        end
        3'b010: result = A & B;
        3'b011: result = A | B;
        3'b100: result = A ^ B;
        3'b101: result = ~A;
        3'b110: begin
            temp   = A + 1'b1;
            result = temp[7:0];
            carry  = temp[8];
        end
        3'b111: begin
            temp   = A - 1'b1;
            result = temp[7:0];
            carry  = temp[8];
        end
    endcase

    zero     = (result == 8'd0);
    negative = result[7];
end

endmodule
