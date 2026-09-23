/*
 * 4-bit BCD-to-seven-segment display decoder.
 * Combinational case decoder.
 *
 * Seven-segment display:
 *       ---
 *      |   |
 *      |   |
 *       ---
 *      |   |
 *      |   |
 *       ---
 *
 * Segment numbering:
 *       --- 0 ---
 *      |         |
 *    5 |         | 1
 *      |--- 6 ---|
 *      |         |
 *    4 |         | 2
 *      |--- 3 ---|
 *
 * A segment value of 1 turns that segment on.
 * Output order: {segment[6], segment[5], ..., segment[0]}.
 *
 * BCD     Digit     segment[6:0]
 * 0000      0          0111111
 * 0001      1          0000110
 * 0010      2          1011011
 * 0011      3          1001111
 * 0100      4          1100110
 * 0101      5          1101101
 * 0110      6          1111101
 * 0111      7          0000111
 * 1000      8          1111111
 * 1001      9          1101111
 *
 * Invalid BCD inputs (1010 to 1111) turn all segments off.
 */

module bcd_to_seven_segment_dataflow (
    input  [3:0] bcd,
    output reg [6:0] segment
);

    always @(*) begin
        case (bcd)
            4'd0:    segment = 7'b0111111;
            4'd1:    segment = 7'b0000110;
            4'd2:    segment = 7'b1011011;
            4'd3:    segment = 7'b1001111;
            4'd4:    segment = 7'b1100110;
            4'd5:    segment = 7'b1101101;
            4'd6:    segment = 7'b1111101;
            4'd7:    segment = 7'b0000111;
            4'd8:    segment = 7'b1111111;
            4'd9:    segment = 7'b1101111;
            default: segment = 7'b0000000;
        endcase
    end

endmodule
