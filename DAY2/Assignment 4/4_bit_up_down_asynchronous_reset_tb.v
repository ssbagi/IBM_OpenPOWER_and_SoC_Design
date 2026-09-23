/* Testbench for the asynchronous-reset up/down counter. */

`timescale 1ns/1ps

module up_down_counter_asynchronous_reset_tb;

    reg clk;
    reg reset;
    reg up;
    wire [3:0] count;
    integer test_count;
    integer failure_count;
    integer value;
    reg [87:0] mode;

    up_down_counter_asynchronous_reset dut (
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
                mode = "ASYNC RESET";
            else if (up)
                mode = "UP COUNT";
            else
                mode = "DOWN COUNT";

            if (count !== expected_count) begin
                $display("FAIL: Test %0d | %s | Expected=%b | Got=%b",
                         test_count, mode, expected_count, count);
                failure_count = failure_count + 1;
            end else begin
                $display("PASS: Test %0d | %s | Count=%b",
                         test_count, mode, count);
            end
        end
    endtask

    initial begin
        $dumpfile("4_bit_up_down_asynchronous_reset_tb.vcd");
        $dumpvars(0, up_down_counter_asynchronous_reset_tb);

        clk = 1'b0;
        reset = 1'b0;
        up = 1'b1;
        test_count = 0;
        failure_count = 0;

        $display("====================================================");
        $display("Asynchronous Reset 4-bit Up/Down Counter Test     ");
        $display("====================================================");

        #2 reset = 1'b1;
        check_count(4'd0);

        up = 1'b0;
        #2 reset = 1'b1;
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

        if (failure_count == 0)
            $display("\nPASS: %0d/%0d asynchronous-reset tests passed.",
                     test_count, test_count);
        else
            $fatal(1, "FAIL: %0d of %0d tests failed.",
                   failure_count, test_count);

        $finish;
    end

endmodule
