`include "mux_2_to_1_behavioral_ifelse.v"

module mux_2_to_1_behavioral_ifelse_tb;
    reg a, b, sel;
    wire y;

    mux_2_to_1_behavioral_ifelse uut (.a(a), .b(b), .sel(sel), .y(y));

    initial begin
        $dumpfile("mux_2_to_1_behavioral_ifelse_tb.vcd");
        $dumpvars(0, mux_2_to_1_behavioral_ifelse_tb);
        $monitor("Time = %0t | a=%b b=%b sel=%b | y=%b", $time, a, b, sel, y);

        a = 0; b = 0; sel = 0;
        #10 a = 0; b = 1; sel = 0;
        #10 a = 0; b = 1; sel = 1;
        #10 a = 1; b = 0; sel = 0;
        #10 a = 1; b = 0; sel = 1;
        #10 $finish;
    end
endmodule
