/*
    Dataflow modelling of 2:1 MUX using the conditional (?:) operator
*/

module mux_2_to_1_dataflow_ternary (
    input wire a,
    input wire b,
    input wire sel,
    output wire y
);

    assign y = sel ? a : b;

endmodule
