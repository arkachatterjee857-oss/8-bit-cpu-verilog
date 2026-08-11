`timescale 1ns/1ps

module cpu_tb;

reg clk;
reg rst;

wire [7:0] debug_pc;
wire [7:0] debug_result;

cpu_top DUT(
    .clk(clk),
    .rst(rst),
    .debug_pc(debug_pc),
    .debug_result(debug_result)
);

always #5 clk = ~clk;

initial begin
    clk = 1'b0;
    rst = 1'b1;

    #20;
    rst = 1'b0;

    #500;
    $finish;
end

always @(posedge clk) begin
    $display("====================================");
    $display("Time       = %0t", $time);
    $display("PC         = %d", DUT.pc);
    $display("IR         = %b", DUT.ir);
    $display("Opcode     = %b", DUT.alu_opcode);
    $display("R0         = %d", DUT.RF.regfile[0]);
    $display("R1         = %d", DUT.RF.regfile[1]);
    $display("R2         = %d", DUT.RF.regfile[2]);
    $display("R3         = %d", DUT.RF.regfile[3]);
    $display("ALU Result = %d", DUT.alu_result);
end

endmodule
