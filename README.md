# 8-bit CPU Design using Verilog HDL

A modular 8-bit CPU developed as an RTL/digital design project using Verilog HDL and Xilinx Vivado.

## Architecture

The processor is composed of:

- 8-bit ALU
- 4 x 8-bit register file
- 8-bit program counter
- Instruction memory
- Instruction register
- FSM-based control unit
- Top-level CPU datapath/control integration

## Instruction Set

| Opcode | Instruction |
|---|---|
| `000` | ADD |
| `001` | SUB |
| `010` | AND |
| `011` | OR |
| `100` | XOR |
| `101` | NOT |
| `110` | INC |
| `111` | DEC |

Instruction format:

```text
 7 6 5 | 4 3 | 2 1 | 0
 Opcode   Rd    Rs   x
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

- Verilog HDL
- Xilinx Vivado
- Vivado Behavioral Simulation

## Verification

The testbench generates a clock and reset sequence and monitors the program counter, instruction register, opcode, register-file contents, and ALU result. The RTL has also been synthesized successfully in Vivado.

## Current Scope

This is an educational CPU/RTL project intended to demonstrate datapath design, control logic, modular Verilog, simulation, and synthesis. Future improvements can include LOAD/STORE instructions, data memory, branching, and pipelining.
