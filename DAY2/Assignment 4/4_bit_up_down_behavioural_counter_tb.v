/*
 * Testbench for the 4-bit synchronous up/down counter.
 */

`timescale 1ns/1ps

module up_down_counter_4_bit_tb;

    reg clk;
    reg reset;
    reg up;
    wire [3:0] count;

    integer test_count;
    integer failure_count;
    integer value;
    reg [79:0] mode;

    up_down_counter_4_bit dut (
        .clk(clk),
        .reset(reset),
        .up(up),
        .count(count)
    );

    always #5 clk = ~clk;

    task check_count;
        input [3:0] expected_count;
        begin
            #1;
            test_count = test_count + 1;

            if (reset)
                mode = "RESET";
            else if (up)
                mode = "UP COUNT";
            else
                mode = "DOWN COUNT";

            if (count !== expected_count) begin
                $display("FAIL: Test %0d | %s | up=%b | Expected=%b | Got=%b",
                         test_count, mode, up, expected_count, count);
                failure_count = failure_count + 1;
            end else begin
                $display("PASS: Test %0d | %s | up=%b | Count=%b",
                         test_count, mode, up, count);
            end
        end
    endtask

    initial begin
        $dumpfile("4_bit_up_down_behavioural_counter_tb.vcd");
        $dumpvars(0, up_down_counter_4_bit_tb);

        clk = 1'b0;
        reset = 1'b1;
        up = 1'b1;
        test_count = 0;
        failure_count = 0;

        $display("============================================");
        $display("   Exhaustive 4-bit Up/Down Counter Test   ");
        $display("============================================");
        $display("up=1: UP COUNT | up=0: DOWN COUNT");

        @(posedge clk);
        check_count(4'd0);

        up = 1'b0;
        @(posedge clk);
        check_count(4'd0);

        reset = 1'b0;
        up = 1'b1;

        $display("\nTesting all 16 UP COUNT states...");
        for (value = 1; value <= 16; value = value + 1) begin
            @(posedge clk);
            check_count(value[3:0]);
        end

        up = 1'b0;
        $display("\nTesting all 16 DOWN COUNT states...");
        for (value = 15; value >= 0; value = value - 1) begin
            @(posedge clk);
            check_count(value[3:0]);
        end

        if (failure_count == 0) begin
            $display("\nPASS: %0d/%0d counter tests completed successfully.",
                     test_count, test_count);
        end else begin
            $display("\nFAIL: %0d of %0d counter tests failed.",
                     failure_count, test_count);
            $fatal(1);
        end

        $finish;
    end

endmodule
