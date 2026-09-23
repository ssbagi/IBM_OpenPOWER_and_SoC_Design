/*
 * 4-bit up/down counter with asynchronous active-high reset.
 * Reset clears the count immediately, without waiting for clk.
 */

module up_down_counter_asynchronous_reset (
    input            clk,
    input            reset,
    input            up,
    output reg [3:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 4'b0000;
        else if (up)
            count <= count + 4'b0001;
        else
            count <= count - 4'b0001;
    end

endmodule
