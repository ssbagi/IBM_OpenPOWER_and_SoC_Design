/*
 * 4-bit up/down counter with synchronous active-high reset.
 * Reset is checked only on the rising edge of clk.
 */

module up_down_counter_synchronous_reset (
    input            clk,
    input            reset,
    input            up,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else if (up)
            count <= count + 4'b0001;
        else
            count <= count - 4'b0001;
    end

endmodule
