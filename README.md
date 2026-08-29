# 8-bit Multicycle CPU using Verilog HDL

A modular **8-bit multicycle processor** designed in Verilog HDL and developed/tested using Xilinx Vivado. The project focuses on RTL design, datapath/control separation, FSM-based sequencing, instruction decoding, ALU design, register-file operations, and functional verification.

> **Project status:** Educational RTL CPU under active development. The current implementation supports a custom instruction format and ALU-based operations. Additional processor features such as data memory, branching, and a fully implemented architectural HALT state are planned extensions.

## Architecture

The processor is organized as a multicycle datapath controlled by an FSM:

```text
                 +----------------------+
                 |   Instruction ROM    |
                 +----------+-----------+
                            |
                            v
                   +----------------+
                   | Instruction Reg|
                   |      (IR)      |
                   +--------+-------+
                            |
                            v
                   +----------------+
                   |   Control FSM  |
                   +--------+-------+
                            |
                Control signals / opcode
                            |
                            v
                   +----------------+
                   |  Register File |
                   |    4 x 8-bit   |
                   +-------+--------+
                       A   |    | B
                           v    v
                         +--------+
                         |  ALU   |
                         +---+----+
                             |
                             v
                         Writeback
                             |
                             +-------> Register File

        PC --------------------> Instruction Memory
```

### Multicycle execution flow

```text
FETCH → DECODE → EXECUTE → WRITEBACK → FETCH
```

The PC is advanced and the instruction register is loaded during FETCH. The instruction is decoded and the register operands are read, the ALU performs the selected operation during EXECUTE, and the result is committed to the destination register during WRITEBACK.

## Instruction Format

The current 8-bit instruction is divided into:

```text
 7       4 3    2 1    0
+---------+------+------+
| Opcode  |  Rd  |  Rs  |
+---------+------+------+ 
  4 bits   2 bits  2 bits
```

- **Opcode `[7:4]`** selects the operation.
- **Rd `[3:2]`** selects the destination register.
- **Rs `[1:0]`** selects the source register.

With two-bit register addresses, the processor provides four registers: `R0`–`R3`.

## Instruction Set

| Opcode | Instruction | Operation |
|---|---|---|
| `0000` | ADD | `Rd ← Rd + Rs` |
| `0001` | SUB | `Rd ← Rd - Rs` |
| `0010` | AND | `Rd ← Rd & Rs` |
| `0011` | OR | `Rd ← Rd \| Rs` |
| `0100` | XOR | `Rd ← Rd ^ Rs` |
| `0101` | NOT | `Rd ← ~Rd` |
| `0110` | INC | `Rd ← Rd + 1` |
| `0111` | DEC | `Rd ← Rd - 1` |
| `1000` | LEFT SHIFT | `Rd ← Rd << 2` |
| `1001` | RIGHT SHIFT | `Rd ← Rd >> 2` |
| `1010` | MOV | `Rd ← Rs` |
| `1111` | HALT* | Reserved for halt/control handling |

`*` HALT is currently detected by the control logic, with the dedicated architectural HALT state planned as a next refinement.

## Main RTL Modules

### `alu_8bit.v`

Implements the CPU arithmetic and logical operations. It generates:

- 8-bit result
- Carry flag
- Signed overflow flag
- Zero flag
- Negative/sign flag

The ALU is implemented as combinational RTL using an opcode-controlled `case` structure.

### `register_file.v`

Implements a **4 × 8-bit register file** with:

- Two combinational read ports
- One synchronous write port
- Write-enable control
- Reset initialization

The current reset values are:

```text
R0 = 10
R1 = 5
R2 = 3
R3 = 1
```

### `program_counter.v`

Stores the current instruction address and increments it when the `pc_increment` control signal is asserted.

### `instruction_memory.v`

Provides the processor's instruction storage. The current implementation is **ROM-like instruction memory** from the CPU's point of view; it is read using the PC and does not expose a processor write interface.

### `instruction_register.v`

Holds the fetched instruction so that it remains available while the processor moves through the multicycle control sequence.

### `control_unit.v`

Implements the synchronous FSM responsible for sequencing the processor through:

```text
FETCH → DECODE → EXECUTE → WRITEBACK
```

It generates control signals including:

- `pc_increment`
- `ir_load`
- `reg_write`
- `alu_opcode`
- `halt`

### `cpu_top.v`

Integrates the complete datapath and control path into the top-level processor.

## Verification

The simulation testbench is located in `tb/cpu_tb.v`.

It provides:

- Clock generation
- Reset sequencing
- Program loading into instruction memory
- CPU-level monitoring
- Register-file observation
- ALU/result monitoring
- Instruction-level checks
- HALT detection for simulation termination

Important signals to inspect in Vivado's waveform viewer include:

```text
PC
IR
state
opcode
Rd
Rs
regA
regB
alu_result
reg_write
pc_increment
ir_load
R0–R3
carry
overflow
zero
negative
```

## Repository Structure

```text
8-bit-cpu-verilog/
├── rtl/
│   ├── alu_8bit.v
│   ├── register_file.v
│   ├── program_counter.v
│   ├── instruction_memory.v
│   ├── instruction_register.v
│   ├── control_unit.v
│   └── cpu_top.v
├── tb/
│   └── cpu_tb.v
└── README.md
```

## Tools

- **Verilog HDL** — RTL implementation
- **Xilinx Vivado** — synthesis and FPGA development
- **Vivado Behavioral Simulation** — functional verification and waveform analysis

## Design Concepts Demonstrated

This project demonstrates practical RTL concepts including:

- Combinational and sequential logic
- FSM design
- Multicycle CPU organization
- Datapath and control-path separation
- Register-transfer operations
- ALU design and status flags
- Instruction encoding and decoding
- Register-file design
- Clocked state updates
- Reset handling
- RTL simulation and waveform debugging
- FPGA synthesis analysis

## Current Limitations

The current processor is intentionally compact and educational. It does not yet include:

- Separate data RAM
- LOAD/STORE instructions
- Conditional/unconditional branches
- Stack support
- Interrupt handling
- Pipelining
- A dedicated architectural HALT state that permanently holds the FSM in HALT

These provide natural next steps for extending the processor.

## Future Improvements

Planned extensions include:

1. Add data memory and `LOAD`/`STORE` instructions.
2. Add branch and jump instructions.
3. Complete the dedicated `HALT` FSM state.
4. Improve the instruction set and control encoding.
5. Add more comprehensive self-checking verification.
6. Explore a pipelined version for comparison with the multicycle architecture.

## Learning Objective

The goal of this project is to build a processor from fundamental RTL blocks and understand how **datapath, control logic, instruction execution, storage, timing, and verification** interact at the hardware-description level.
