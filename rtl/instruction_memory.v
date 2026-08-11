module instruction_memory(
    input [7:0] address,
    output [7:0] instruction
);

reg [7:0] memory [0:255];
integer i;

initial begin
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 8'b00000000;

    memory[0] = 8'b00000010; // ADD R0,R1
    memory[1] = 8'b00100100; // SUB R0,R2
    memory[2] = 8'b01000110; // AND R0,R3
    memory[3] = 8'b01100010; // OR  R0,R1
    memory[4] = 8'b10000100; // XOR R0,R2
    memory[5] = 8'b10100000; // NOT R0
    memory[6] = 8'b11000000; // INC R0
    memory[7] = 8'b11100000; // DEC R0
end

assign instruction = memory[address];

endmodule
