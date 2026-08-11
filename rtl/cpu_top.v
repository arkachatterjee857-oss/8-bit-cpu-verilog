module cpu_top(
    input clk,
    input rst,
    output [7:0] debug_pc,
    output [7:0] debug_result
);

wire [7:0] pc;
wire [7:0] instruction;
wire [7:0] ir;
wire [2:0] alu_opcode;
wire reg_write;
wire [1:0] rd;
wire [1:0] rs;
wire [7:0] regA;
wire [7:0] regB;
wire [7:0] write_back_data;
wire [7:0] alu_result;
wire carry;
wire overflow;
wire zero;
wire negative;

program_counter PC(
    .clk(clk),
    .rst(rst),
    .pc(pc)
);

instruction_memory IMEM(
    .address(pc),
    .instruction(instruction)
);

instruction_register IR(
    .clk(clk),
    .rst(rst),
    .instruction_in(instruction),
    .instruction_out(ir)
);

control_unit CU(
    .clk(clk),
    .rst(rst),
    .instruction(ir),
    .alu_opcode(alu_opcode),
    .reg_write(reg_write)
);

assign rd = ir[4:3];
assign rs = ir[2:1];

register_file RF(
    .clk(clk),
    .rst(rst),
    .we(reg_write),
    .write_addr(rd),
    .write_data(write_back_data),
    .read_addr1(rd),
    .read_addr2(rs),
    .read_data1(regA),
    .read_data2(regB)
);

alu_8bit ALU(
    .A(regA),
    .B(regB),
    .opcode(alu_opcode),
    .result(alu_result),
    .carry(carry),
    .overflow(overflow),
    .zero(zero),
    .negative(negative)
);

assign write_back_data = alu_result;
assign debug_pc = pc;
assign debug_result = alu_result;

// Simulation-only console output.
// synthesis translate_off
always @(posedge clk) begin
    $display("------------------------------------");
    $display("PC          = %d", pc);
    $display("Instruction = %b", ir);
    $display("Opcode      = %b", alu_opcode);
    $display("RD          = %d", rd);
    $display("RS          = %d", rs);
    $display("A           = %d", regA);
    $display("B           = %d", regB);
    $display("Result      = %d", alu_result);
    $display("Carry       = %b", carry);
    $display("Zero        = %b", zero);
end
// synthesis translate_on

endmodule
