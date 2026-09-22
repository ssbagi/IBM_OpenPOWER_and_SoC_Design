
/* 
    Structural modelling of the Following gates
    1. AND
    2. NAND
    3. OR
    4. NOR
    5. NOT
    6. XOR
    7. XNOR
*/

module and_gate(a, b, y);
    input a, b;
    output y;
    and a1(y, a, b);
    always @(*) $display("Time = %0t | AND GATE y = a & b | y = %b", $time, y);
endmodule

module nand_gate(a, b, y);
    input a, b;
    output y;
    nand n1(y, a, b);
    always @(*) $display("Time = %0t | NAND GATE y = ~(a & b) | y = %b", $time, y);
endmodule

module or_gate(a, b, y);
    input a, b;
    output y;
    or o1(y, a, b);
    always @(*) $display("Time = %0t | OR GATE y = (a | b) | y = %b", $time, y);
endmodule

module nor_gate(a, b, y);
    input a, b;
    output y;
    nor n2(y, a, b);
    always @(*) $display("Time = %0t | NOR GATE y = ~(a | b) | y = %b", $time, y);
endmodule

module not_gate(a, y);
    input a;
    output y;
    not n3(y, a);
    always @(*) $display("Time = %0t | NOT GATE y = (~a) | y = %b", $time, y);
endmodule

module xor_gate(a, b, y);
    input a, b;
    output y;
    xor x1(y, a, b);
    always @(*) $display("Time = %0t | XOR GATE y = (a ^ b) | y = %b", $time, y);
endmodule

module xnor_gate(a, b, y);
    input a, b;
    output y;
    xnor x2(y, a, b);
    always @(*) $display("Time = %0t | XNOR GATE y = ~(a ^ b) | y = %b", $time, y);
endmodule






