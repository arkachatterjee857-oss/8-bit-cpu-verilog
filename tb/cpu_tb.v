`timescale 1ns / 1ps

module cpu_tb;

    reg clk;
    reg rst;

    wire [7:0] debug_pc;
    wire [7:0] debug_result;

    //==================================================
    // DUT
    //==================================================
    cpu_top DUT (
        .clk(clk),
        .rst(rst),
        .debug_pc(debug_pc),
        .debug_result(debug_result)
    );

    //==================================================
    // CLOCK
    // 10 ns clock period
    //==================================================
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //==================================================
    // TEST PROGRAM
    // Instruction format:
    // [7:4] = opcode
    // [3:2] = Rd
    // [1:0] = Rs
    //==================================================
    initial begin

        // MOV R0,R1
        // 1010 00 01
        DUT.IMEM.memory[0] = 8'b1010_00_01;

        // ADD R0,R1
        // 0000 00 01
        DUT.IMEM.memory[1] = 8'b0000_00_01;

        // SUB R0,R2
        // 0001 00 10
        DUT.IMEM.memory[2] = 8'b0001_00_10;

        // AND R0,R3
        // 0010 00 11
        DUT.IMEM.memory[3] = 8'b0010_00_11;

        // OR R0,R1
        // 0011 00 01
        DUT.IMEM.memory[4] = 8'b0011_00_01;

        // XOR R0,R2
        // 0100 00 10
        DUT.IMEM.memory[5] = 8'b0100_00_10;

        // NOT R0
        // 0101 00 00
        DUT.IMEM.memory[6] = 8'b0101_00_00;

        // INC R0
        // 0110 00 00
        DUT.IMEM.memory[7] = 8'b0110_00_00;

        // DEC R0
        // 0111 00 00
        DUT.IMEM.memory[8] = 8'b0111_00_00;

        // LEFT SHIFT R0 by 2
        // 1000 00 00
        DUT.IMEM.memory[9] = 8'b1000_00_00;

        // RIGHT SHIFT R0 by 2
        // 1001 00 00
        DUT.IMEM.memory[10] = 8'b1001_00_00;

        // HALT
        // 1111 00 00
        DUT.IMEM.memory[11] = 8'b1111_00_00;

    end

    //==================================================
    // RESET
    //==================================================
    initial begin
        rst = 1'b1;

        // Hold reset for two clock cycles
        #20;
        rst = 1'b0;
    end

    //==================================================
    // MONITOR
    //==================================================
    always @(posedge clk) begin
        #1;

        $display("=================================================");
        $display("TIME        = %0t ns", $time);
        $display("RESET       = %b", rst);
        $display("PC          = %02h (%0d)", DUT.pc, DUT.pc);
        $display("IR          = %08b", DUT.ir);
        $display("STATE       = %02b", DUT.CU.state);
        $display("ALU OPCODE  = %04b", DUT.alu_opcode);
        $display("RD          = %02b", DUT.rd);
        $display("RS          = %02b", DUT.rs);
        $display("REG A       = %0d", DUT.regA);
        $display("REG B       = %0d", DUT.regB);
        $display("ALU RESULT  = %0d", DUT.alu_result);
        $display("REG WRITE   = %b", DUT.reg_write);
        $display("PC INC      = %b", DUT.pc_increment);
        $display("IR LOAD     = %b", DUT.ir_load);
        $display("HALT        = %b", DUT.halt);
        $display("R0          = %0d", DUT.RF.regfile[0]);
        $display("R1          = %0d", DUT.RF.regfile[1]);
        $display("R2          = %0d", DUT.RF.regfile[2]);
        $display("R3          = %0d", DUT.RF.regfile[3]);
        $display("CARRY       = %b", DUT.carry);
        $display("OVERFLOW    = %b", DUT.overflow);
        $display("ZERO        = %b", DUT.zero);
        $display("NEGATIVE    = %b", DUT.negative);
    end

    //==================================================
    // SELF-CHECKING EXPECTED RESULTS
    // Each instruction takes 4 cycles in the current FSM:
    // FETCH -> DECODE -> EXECUTE -> WRITEBACK
    //==================================================
    initial begin

        @(negedge rst);

        // MOV R0,R1: 10 -> 5
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd5)
            $display("PASS: MOV R0,R1");
        else
            $display("FAIL: MOV R0,R1 | Expected R0=5, Got R0=%0d", DUT.RF.regfile[0]);

        // ADD R0,R1: 5 + 5 = 10
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd10)
            $display("PASS: ADD R0,R1");
        else
            $display("FAIL: ADD R0,R1 | Expected R0=10, Got R0=%0d", DUT.RF.regfile[0]);

        // SUB R0,R2: 10 - 3 = 7
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd7)
            $display("PASS: SUB R0,R2");
        else
            $display("FAIL: SUB R0,R2 | Expected R0=7, Got R0=%0d", DUT.RF.regfile[0]);

        // AND R0,R3: 7 & 1 = 1
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd1)
            $display("PASS: AND R0,R3");
        else
            $display("FAIL: AND R0,R3 | Expected R0=1, Got R0=%0d", DUT.RF.regfile[0]);

        // OR R0,R1: 1 | 5 = 5
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd5)
            $display("PASS: OR R0,R1");
        else
            $display("FAIL: OR R0,R1 | Expected R0=5, Got R0=%0d", DUT.RF.regfile[0]);

        // XOR R0,R2: 5 ^ 3 = 6
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd6)
            $display("PASS: XOR R0,R2");
        else
            $display("FAIL: XOR R0,R2 | Expected R0=6, Got R0=%0d", DUT.RF.regfile[0]);

        // NOT R0: ~6 = 249
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd249)
            $display("PASS: NOT R0");
        else
            $display("FAIL: NOT R0 | Expected R0=249, Got R0=%0d", DUT.RF.regfile[0]);

        // INC R0: 249 + 1 = 250
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd250)
            $display("PASS: INC R0");
        else
            $display("FAIL: INC R0 | Expected R0=250, Got R0=%0d", DUT.RF.regfile[0]);

        // DEC R0: 250 - 1 = 249
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd249)
            $display("PASS: DEC R0");
        else
            $display("FAIL: DEC R0 | Expected R0=249, Got R0=%0d", DUT.RF.regfile[0]);

        // LEFT SHIFT R0 by 2: 249 << 2 -> 228 (8-bit result)
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd228)
            $display("PASS: LEFT SHIFT R0");
        else
            $display("FAIL: LEFT SHIFT R0 | Expected R0=228, Got R0=%0d", DUT.RF.regfile[0]);

        // RIGHT SHIFT R0 by 2: 228 >> 2 = 57
        repeat(4) @(posedge clk);
        #1;
        if (DUT.RF.regfile[0] == 8'd57)
            $display("PASS: RIGHT SHIFT R0");
        else
            $display("FAIL: RIGHT SHIFT R0 | Expected R0=57, Got R0=%0d", DUT.RF.regfile[0]);

    end

    //==================================================
    // END SIMULATION WHEN HALT IS DETECTED
    //==================================================
    always @(posedge clk) begin
        #1;

        if (DUT.halt === 1'b1) begin
            $display("=================================================");
            $display("HALT INSTRUCTION ENCOUNTERED");
            $display("FINAL PC = %0d", DUT.pc);
            $display("FINAL R0 = %0d", DUT.RF.regfile[0]);
            $display("FINAL R1 = %0d", DUT.RF.regfile[1]);
            $display("FINAL R2 = %0d", DUT.RF.regfile[2]);
            $display("FINAL R3 = %0d", DUT.RF.regfile[3]);
            $display("SIMULATION COMPLETE");
            $display("=================================================");
            $finish;
        end
    end

    // Safety timeout in case HALT is not detected.
    initial begin
        #2000;
        $display("ERROR: Simulation timeout; HALT was not detected.");
        $finish;
    end

endmodule
