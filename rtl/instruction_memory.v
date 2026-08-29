module instruction_memory(

    input [7:0] address,
    output [7:0] instruction

);

reg [7:0] memory [0:255];

initial begin

    memory[0] = 8'b10100001;

end

assign instruction = memory[address];

endmodule
