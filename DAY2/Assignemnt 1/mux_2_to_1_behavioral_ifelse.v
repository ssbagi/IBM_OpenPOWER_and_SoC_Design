/*
    Behavioral modelling of 2:1 MUX using if-else inside an always block
*/

module mux_2_to_1_behavioral_ifelse (
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);

    always @(a, b, sel) begin
        if (sel)
            y = a;
        else
            y = b;
    end

endmodule
