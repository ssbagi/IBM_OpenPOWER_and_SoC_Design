/*
 * 4-bit BCD-to-Excess-3 code converter.
 * Dataflow combinational model.
 */

module bcd_to_excess_3_dataflow (
    input  [3:0] bcd,
    output [3:0] excess_3
);

    assign excess_3 = bcd + 4'b0011;

endmodule
