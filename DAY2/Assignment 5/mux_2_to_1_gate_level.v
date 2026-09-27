/*
    Gate-level modelling of 2:1 MUX using primitive logic gates
    y = (~sel & a) | (sel & b)
*/

module mux_2_to_1_gate_level (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);

    wire sel_n, y1, y2;

    not(sel_n, sel);
    and(y1, sel_n, a);
    and(y2, sel, b);
    or(y, y1, y2);

endmodule



