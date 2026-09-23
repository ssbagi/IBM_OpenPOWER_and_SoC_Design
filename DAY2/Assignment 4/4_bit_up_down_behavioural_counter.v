/*
 * 4-bit synchronous up/down counter.
 * Behavioral Verilog model.
 *
 * reset = 1: count is cleared to 0.
 * up    = 1: count increments on each rising clock edge.
 * up    = 0: count decrements on each rising clock edge.
 */

module up_down_counter_4_bit (
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
