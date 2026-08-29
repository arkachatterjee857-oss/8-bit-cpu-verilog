module cpu_top(

    input clk,
    input rst,

    output [7:0] debug_pc,
    output [7:0] debug_result

);
/////////////////////////////////////////////////
// PROGRAM COUNTER
/////////////////////////////////////////////////

wire [7:0] pc;

program_counter PC(
    .clk(clk),
    .rst(rst),
    .pc_increment(pc_increment),
    .pc(pc)
);
/////////////////////////////////////////////////
// INSTRUCTION MEMORY
/////////////////////////////////////////////////

wire [7:0] instruction;

instruction_memory IMEM(
    .address(pc),
    .instruction(instruction)
);

/////////////////////////////////////////////////
// INSTRUCTION REGISTER
/////////////////////////////////////////////////

wire [7:0] ir;

instruction_register IR(
    .clk(clk),
    .rst(rst),
    .ir_load(ir_load),
    .instruction_in(instruction),
    .instruction_out(ir)
);

/////////////////////////////////////////////////
// CONTROL UNIT
/////////////////////////////////////////////////

wire [3:0] alu_opcode;
wire reg_write;
wire halt;
wire pc_increment;
wire ir_load;
control_unit CU(
    .clk(clk),
    .rst(rst),
    .instruction(ir),
    .alu_opcode(alu_opcode),
    .reg_write(reg_write),
    .halt(halt),
    .ir_load(ir_load),
    .pc_increment(pc_increment)
);

/////////////////////////////////////////////////
// INSTRUCTION DECODER
/////////////////////////////////////////////////

wire [1:0] rd;
wire [1:0] rs;

assign rd = ir[3:2];
assign rs = ir[1:0];

/////////////////////////////////////////////////
// REGISTER FILE
/////////////////////////////////////////////////

wire [7:0] regA;
wire [7:0] regB;

wire [7:0] write_back_data;

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

/////////////////////////////////////////////////
// ALU
/////////////////////////////////////////////////

wire [7:0] alu_result;

wire carry;
wire overflow;
wire zero;
wire negative;

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

/////////////////////////////////////////////////
// WRITEBACK
/////////////////////////////////////////////////

assign write_back_data = alu_result;
assign debug_pc     = pc;
assign debug_result = alu_result;

/////////////////////////////////////////////////
// OPTIONAL DEBUG SIGNALS
/////////////////////////////////////////////////

// synthesis translate_off

always @(posedge clk)
begin

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
