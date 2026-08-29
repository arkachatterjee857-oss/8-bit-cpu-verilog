`timescale 1ns / 1ps

module alu_8bit(

    input [7:0] A,
    input [7:0] B,
    input [3:0] opcode,

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

    case(opcode)

        4'b0000: begin
            temp   = A + B;
            result = temp[7:0];
            carry  = temp[8];
            overflow = (~(A[7] ^ B[7])) & (result[7] ^ A[7]);
        end

        4'b0001: begin
            temp   = A - B;
            result = temp[7:0];
            carry  = temp[8];
            overflow = ((A[7] ^ B[7])) & (result[7] ^ A[7]);
        end

        4'b0010: result = A & B;

        4'b0011: result = A | B;

        4'b0100: result = A ^ B;

        4'b0101: result = ~A;

        4'b0110: begin
            temp   = A + 1;
            result = temp[7:0];
            carry  = temp[8];
            overflow = (~(A[7] ^ B[7])) & (result[7] ^ A[7]);
        end

        4'b0111: begin
            temp   = A - 1;
            result = temp[7:0];
            carry  = temp[8];
            overflow = ((A[7] ^ B[7])) & (result[7] ^ A[7]);
        end
        
        4'b1000: begin // left shift
            temp=A<<2;
            result=temp[7:0];
        end
        
        4'b1001: begin // right shift
            temp=A>>2;
            result=temp[7:0];
        end
        
        4'b1010: begin // MOV function
            temp=B[7:0];
            result=temp[7:0];
        end
    endcase

    zero     = (result == 8'd0);
    negative = result[7];

end

endmodule
