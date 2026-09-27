/*
    Behavioral modelling of 2:1 MUX using a case statement
*/

module mux_2_to_1_behavioral_case (
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);

    always @(*) begin
        case (sel)
            1'b0 : y = a;
            1'b1 : y = b;
        endcase
    end

endmodule
