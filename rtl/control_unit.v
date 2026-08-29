module control_unit(

    input clk,
    input rst,

    input [7:0] instruction,

    output reg [3:0] alu_opcode,
    output reg reg_write,
    output reg halt,
    output reg pc_increment,
    output reg ir_load


);

parameter FETCH     = 2'b00;
parameter DECODE    = 2'b01;
parameter EXECUTE   = 2'b10;
parameter WRITEBACK = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge rst) begin

    if(rst)
        state <= FETCH;
    else
        state <= next_state;

end

always @(*) begin

    alu_opcode = instruction[7:4];
    reg_write  = 1'b0;
    halt = 1'b0;

    case(state)

        FETCH:
        begin
            next_state = DECODE;
            pc_increment = 1'b1;
            ir_load=1;
        end

        DECODE: begin
            
            pc_increment = 1'b0;
            ir_load=0;
            if (alu_opcode==4'b1111)
            begin
                halt=1;
            end
            else
            begin
                next_state = EXECUTE;
                halt=0;
            end
        end

        EXECUTE:begin
            next_state = WRITEBACK;
            pc_increment = 1'b0;
            ir_load=0;
        end

        WRITEBACK: begin
            reg_write = 1'b1;
            next_state = FETCH;
            pc_increment = 1'b0;
            ir_load=0;
        end

        default:
            next_state = FETCH;

    endcase

end

endmodule
