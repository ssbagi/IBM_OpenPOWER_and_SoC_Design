/*
 * Testbench for the 4-bit BCD-to-seven-segment display decoder.
 * Tests all valid BCD digits from 0 to 9.
 */

`timescale 1ns/1ps

module bcd_to_seven_segment_dataflow_tb;

    reg  [3:0] bcd;
    wire [6:0] segment;
    reg  [6:0] expected_segment;

    integer bcd_value;
    integer test_count;
    integer failure_count;

    bcd_to_seven_segment_dataflow dut (
        .bcd(bcd),
        .segment(segment)
    );

    function [6:0] expected_segments;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: expected_segments = 7'b0111111;
                4'd1: expected_segments = 7'b0000110;
                4'd2: expected_segments = 7'b1011011;
                4'd3: expected_segments = 7'b1001111;
                4'd4: expected_segments = 7'b1100110;
                4'd5: expected_segments = 7'b1101101;
                4'd6: expected_segments = 7'b1111101;
                4'd7: expected_segments = 7'b0000111;
                4'd8: expected_segments = 7'b1111111;
                4'd9: expected_segments = 7'b1101111;
                default: expected_segments = 7'b0000000;
            endcase
        end
    endfunction

    initial begin
        $dumpfile("bcd_to_seven_segment_dataflow_tb.vcd");
        $dumpvars(0, bcd_to_seven_segment_dataflow_tb);

        test_count = 0;
        failure_count = 0;

        $display("=======================================================");
        $display("          BCD-to-Seven-Segment Decoder Test           ");
        $display("=======================================================");
        $display("Segment order: {6, 5, 4, 3, 2, 1, 0}; 1 = ON");
        $display("Time\tTest\tBCD\tSegments\tExpected");

        for (bcd_value = 0; bcd_value < 10; bcd_value = bcd_value + 1) begin
            bcd = bcd_value;
            #1;

            expected_segment = expected_segments(bcd);
            test_count = test_count + 1;

            $display("%0t\t%0d\t%0d\t%b\t%b", $time, test_count,
                     bcd_value, segment, expected_segment);

            if (segment !== expected_segment) begin
                $display("  FAIL: BCD=%0d, Expected=%b, Got=%b",
                         bcd_value, expected_segment, segment);
                failure_count = failure_count + 1;
            end
        end

        if (failure_count == 0) begin
            $display("\nPASS: %0d/%0d BCD-to-seven-segment tests completed successfully.",
                     test_count, test_count);
        end else begin
            $display("\nFAIL: %0d of %0d tests failed.", failure_count, test_count);
            $fatal(1);
        end

        $finish;
    end

endmodule
