/*
 * Testbench for the 4-bit magnitude comparator.
 * Runs random smoke tests followed by exhaustive tests of all input pairs.
 */

`timescale 1ns/1ps

module comparator_4bit_tb;

    reg  [3:0] a;
    reg  [3:0] b;
    wire       a_greater;
    wire       b_greater;
    wire       equal;

    integer input_value_a;
    integer input_value_b;
    integer random_value_a;
    integer random_value_b;
    integer random_test_index;
    integer random_seed;
    integer test_count;
    integer failure_count;

    comparator_4bit dut (
        .a(a),
        .b(b),
        .a_greater(a_greater),
        .b_greater(b_greater),
        .equal(equal)
    );

    task automatic check_case;
        input [3:0] test_a;
        input [3:0] test_b;
        begin
            a = test_a;
            b = test_b;
            #1;

            test_count = test_count + 1;

            if (test_a > test_b) begin
                $display("Test %0d: A=%0d, B=%0d -> A > B | result: a_greater=%b b_greater=%b equal=%b",
                         test_count, test_a, test_b, a_greater, b_greater, equal);
                if ({a_greater, b_greater, equal} !== 3'b100) begin
                    $display("FAIL: expected A > B, got %b", {a_greater, b_greater, equal});
                    failure_count = failure_count + 1;
                end
            end else if (test_a < test_b) begin
                $display("Test %0d: A=%0d, B=%0d -> A < B | result: a_greater=%b b_greater=%b equal=%b",
                         test_count, test_a, test_b, a_greater, b_greater, equal);
                if ({a_greater, b_greater, equal} !== 3'b010) begin
                    $display("FAIL: expected A < B, got %b", {a_greater, b_greater, equal});
                    failure_count = failure_count + 1;
                end
            end else begin
                $display("Test %0d: A=%0d, B=%0d -> A == B | result: a_greater=%b b_greater=%b equal=%b",
                         test_count, test_a, test_b, a_greater, b_greater, equal);
                if ({a_greater, b_greater, equal} !== 3'b001) begin
                    $display("FAIL: expected A == B, got %b", {a_greater, b_greater, equal});
                    failure_count = failure_count + 1;
                end
            end
        end
    endtask

    initial begin
        $dumpfile("4bit_comparator_tb.vcd");
        $dumpvars(0, comparator_4bit_tb);

        test_count = 0;
        failure_count = 0;
        random_seed = 32'h1ACE_B00C;

        $display("Starting 20 deterministic random comparator tests...");
        for (random_test_index = 0; random_test_index < 20; random_test_index = random_test_index + 1) begin
            random_value_a = $random(random_seed) & 4'hf;
            random_value_b = $random(random_seed) & 4'hf;
            check_case(random_value_a, random_value_b);
        end

        $display("Starting 256-case exhaustive comparator test...");

        for (input_value_a = 0; input_value_a < 16; input_value_a = input_value_a + 1) begin
            for (input_value_b = 0; input_value_b < 16; input_value_b = input_value_b + 1) begin
                check_case(input_value_a, input_value_b);
            end
        end

        if (failure_count == 0) begin
            $display("PASS: %0d random and exhaustive comparator tests completed successfully.", test_count);
        end else begin
            $display("FAIL: %0d of %0d comparator tests failed.", failure_count, test_count);
            $fatal(1);
        end

        $finish;
    end

endmodule