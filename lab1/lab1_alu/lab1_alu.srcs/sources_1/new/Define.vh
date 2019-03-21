`define ALU_OP_BITS 3
`define FLAG_BITS 4

/*
    op codes
*/
`define ADD 3'd0
`define SUB 3'd2
`define OR 3'd4
`define AND 3'd5
`define NOT 3'd6
`define XOR 3'd7

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