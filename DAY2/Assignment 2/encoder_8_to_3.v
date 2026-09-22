/*

 * 8-to-3 Encoder Module
 * Author   : Shreyas S Bai
 * Date     : 22-09-2026
 * Description: This module implements an 8-to-3 encoder.

 * INPUT   : 8-bit input signal
 * OUTPUT  : 3-bit encoded output signal

 Truth Table:
    Input    Output
    ----------------
    00000001  000
    00000010  001
    00000100  010
    00001000  011
    00010000  100
    00100000  101
    01000000  110
    10000000  111

    This is kind of Multiplexer where only one input is active at a time and the output represents the binary code of the active input.

*/

module encoder_8_to_3 (
    input  [7:0] in,
    output reg [2:0] out
);

    always @(*) begin
        case (in)
            8'b00000001: out = 3'b000;
            8'b00000010: out = 3'b001;
            8'b00000100: out = 3'b010;
            8'b00001000: out = 3'b011;
            8'b00010000: out = 3'b100;
            8'b00100000: out = 3'b101;
            8'b01000000: out = 3'b110;
            8'b10000000: out = 3'b111;
            default:     out = 3'b000;
        endcase
    end
endmodule













