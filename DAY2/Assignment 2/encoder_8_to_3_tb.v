/*
 * Testbench for 8-to-3 Encoder
 * Drives all valid one-hot input combinations using a for loop.
 */

`timescale 1ns/1ps

module encoder_8_to_3_tb;

    reg  [7:0] in;
    wire [2:0] out;
    integer i;

    encoder_8_to_3 dut (
        .in(in),
        .out(out)
    );

    initial begin
        $dumpfile("encoder_8_to_3_tb.vcd");
        $dumpvars(0, in, out);

        $timeformat(-9, 0, " ns", 0);
        $display("Time\tin\t\tout");

        for (i = 0; i < 8; i = i + 1) begin
            in = 8'b00000001 << i;
            #1;
            $display("%0t\t%b\t%b", $time, in, out);
            #9;
        end

        $finish;
    end

endmodule