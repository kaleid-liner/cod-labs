`define BITS 32
`define REG_ADDR 5
`define REG_SIZE 32
`define ADDR_BITS 8

`define OP_BITS 6

`define R 6'b000000
`define ADDI 6'b001000
`define ANDI 6'b001100
`define BEQ 6'b000100
`define BNE 6'b000101
`define LW 6'b100011
`define ORI 6'b001101
`define XORI 6'b001110
`define SW 6'b101011
`define J 6'b000010
`define SLTI 6'b001010
`define ERET 6'b010000

`define FUNCT_BITS 6

`define ADD_FUNCT 6'b100000
`define AND_FUNCT 6'b100100
`define SUB_FUNCT 6'b100010
`define OR_FUNCT 6'b100101
`define XOR_FUNCT 6'b100110
`define NOR_FUNCT 6'b100111
`define SLT_FUNCT 6'b101010

`define ALU_OP_BITS 4

`define ALU_ADD 4'b0000
`define ALU_SUB 4'b0001
`define ALU_AND 4'b0010
`define ALU_OR 4'b0011
`define ALU_XOR 4'b0100
`define ALU_NOR 4'b0101
`define ALU_SLT 4'b0110

`define INTR_BITS 8
`define INT_VEC_BITS 4
