/*
    Behavioral modelling of 2:1 MUX using an always block
*/

module mux_2_to_1_behavioral (
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);

    always @(sel, a, b) begin
        if (sel)
            y = a;
        else
            y = b;
    end

endmodule
