/*
 * Testbench for the 4-bit BCD-to-Excess-3 code converter.
 * Tests all valid BCD digits from 0 to 9.
 */

`timescale 1ns/1ps

module bcd_to_excess_3_dataflow_tb;

    reg  [3:0] bcd;
    wire [3:0] excess_3;
    reg  [3:0] expected_excess_3;

    integer bcd_value;
    integer test_count;
    integer failure_count;

    bcd_to_excess_3_dataflow dut (
        .bcd(bcd),
        .excess_3(excess_3)
    );

    initial begin
        $dumpfile("bcd_to_excess_3_dataflow_tb.vcd");
        $dumpvars(0, bcd_to_excess_3_dataflow_tb);

        test_count = 0;
        failure_count = 0;

        $display("===============================================");
        $display("      BCD-to-Excess-3 Converter Test          ");
        $display("===============================================");
        $display("Formula: Excess-3 = BCD + 3");
        $display("Testing all valid BCD digits from 0 to 9...\n");
        $display("Time\tTest\tBCD(dec)\tBCD\tExcess-3\tExpected");

        for (bcd_value = 0; bcd_value < 10; bcd_value = bcd_value + 1) begin
            bcd = bcd_value;
            #1;

            expected_excess_3 = bcd_value + 3;
            test_count = test_count + 1;

            $display("%0t\t%0d\t%0d\t\t%b\t%b\t\t%b",
                     $time, test_count, bcd_value, bcd, excess_3,
                     expected_excess_3);

            if (excess_3 !== expected_excess_3) begin
                $display("  FAIL: BCD=%0d (%b), Expected Excess-3=%b, Got=%b",
                         bcd_value, bcd, expected_excess_3, excess_3);
                failure_count = failure_count + 1;
            end
        end

        if (failure_count == 0) begin
            $display("\nPASS: %0d/%0d BCD-to-Excess-3 tests completed successfully.",
                     test_count, test_count);
        end else begin
            $display("\nFAIL: %0d of %0d tests failed.", failure_count, test_count);
            $fatal(1);
        end

        $finish;
    end

endmodule
