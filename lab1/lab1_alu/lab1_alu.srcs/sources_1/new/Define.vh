`define ALU_OP_BITS 4
`define FLAG_BITS 4

/*
    op codes
*/
`define ADD 0
`define SUB 2
`define OR 4
`define AND 5
`define NOT 6
`define XOR 7
`define SAR 1
`define SHR 3
`define SL  8

/*
    flags
*/
`define CF 1
`define OF 2
`define ZF 4
`define SF 8     // x86 sign flag
`define CF_BIT 0
`define OF_BIT 1
`define ZF_BIT 2
`define SF_BIT 3