/*
 * Testbench for the 4-bit binary-to-Gray code converter.
 * Exhaustively tests all binary values from 0 to 15.
 */

`timescale 1ns/1ps

module binary_to_gray_tb;

    reg  [3:0] binary;
    wire [3:0] gray;

    integer binary_value;
    integer expected_gray;
    integer test_count;
    integer failure_count;

    binary_to_gray dut (
        .binary(binary),
        .gray(gray)
    );

    initial begin
        $dumpfile("3_bit_binary_to_gray_tb.vcd");
        $dumpvars(0, binary_to_gray_tb);

        test_count = 0;
        failure_count = 0;

        $display("===============================================");
        $display("      4-bit Binary-to-Gray Converter Test      ");
        $display("===============================================");
        $display("Formula: Gray = Binary ^ (Binary >> 1)");
        $display("Testing all 16 binary input combinations...\n");
        $display("Time\tTest\tBinary(dec)\tBinary\tGray\tGray(dec)\tExpected");

        for (binary_value = 0; binary_value < 16; binary_value = binary_value + 1) begin
            binary = binary_value;
            #1;

            expected_gray = (binary_value >> 1) ^ binary_value;
            test_count = test_count + 1;

            $display("%0t\t%0d\t%0d\t\t%b\t%b\t%0d\t\t%b",
                     $time, test_count, binary_value, binary, gray,
                     gray, expected_gray[3:0]);

            if (gray !== expected_gray[3:0]) begin
                $display("  FAIL: Binary=%0d (%b), Expected Gray=%0d (%b), Got Gray=%0d (%b)",
                         binary_value, binary, expected_gray, expected_gray[3:0], gray, gray);
                failure_count = failure_count + 1;
            end
        end

        if (failure_count == 0) begin
            $display("\nPASS: %0d/%0d binary-to-Gray tests completed successfully.",
                     test_count, test_count);
            $display("All Gray-code outputs match the expected values.");
        end else begin
            $display("\nFAIL: %0d of %0d binary-to-Gray tests failed.",
                     failure_count, test_count);
            $fatal(1);
        end

        $finish;
    end

endmodule
