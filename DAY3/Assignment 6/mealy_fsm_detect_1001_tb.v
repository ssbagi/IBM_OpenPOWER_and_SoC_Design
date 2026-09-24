`timescale 1ns/1ps

module mealy_fsm_detect_1001_tb;

    reg clk;
    reg reset;
    reg data_in;
    wire detected;
    integer error_count;
    integer expected_state;
    integer i;

    mealy_fsm_detect_1001 dut (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .detected(detected)
    );

    always #5 clk = ~clk;

    task send_bit;
        input bit_value;
        reg expected_detected;
        begin
            expected_detected = (expected_state == 3) && bit_value;

            @(negedge clk);
            data_in = bit_value;
            #1;
            if (detected !== expected_detected) begin
                $display("ERROR: bit=%b, detected=%b, expected=%b, state=%0d, time=%0t",
                         bit_value, detected, expected_detected, expected_state, $time);
                error_count = error_count + 1;
            end

            @(posedge clk);

            case (expected_state)
                0: expected_state = bit_value ? 1 : 0;
                1: expected_state = bit_value ? 1 : 2;
                2: expected_state = bit_value ? 1 : 3;
                3: expected_state = bit_value ? 1 : 0;
                default: expected_state = 0;
            endcase
        end
    endtask

    initial begin
        $dumpfile("mealy_fsm_detect_1001.vcd");
        $dumpvars(0, mealy_fsm_detect_1001_tb);

        clk = 1'b0;
        reset = 1'b1;
        data_in = 1'b0;
        error_count = 0;
        expected_state = 0;

        #17;
        reset = 1'b0;

        // Directed cases, followed by a reproducible randomized stream.
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b0);
        send_bit(1'b1);

        for (i = 0; i < 256; i = i + 1)
            send_bit($urandom_range(0, 1));

        if (error_count == 0)
            $display("MEALY TEST PASSED: 264 directed/random bits checked");
        else
            $display("TEST FAILED: %0d error(s)", error_count);

        #10;
        $finish;
    end

endmodule