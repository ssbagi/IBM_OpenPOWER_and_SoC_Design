/*
    Shared testbench for the gate modules.
    Both logic_gates_dataflow.v and logic_gates_structure.v define modules
    with identical names/ports, so pick which DUT to include via `DATAFLOW`.
    Compile e.g.: iverilog -DDATAFLOW logic_gates_tb.v   (dataflow version)
                  iverilog logic_gates_tb.v              (structural version, default)
*/

`ifdef DATAFLOW
    `include "logic_gates_dataflow.v"
`else
    `include "logic_gates_structure.v"
`endif

module logic_gates_tb;
    reg a, b;
    wire y_and, y_nand, y_or, y_nor, y_not, y_xor, y_xnor;

    and_gate  u_and  (a, b, y_and);
    nand_gate u_nand (a, b, y_nand);
    or_gate   u_or   (a, b, y_or);
    nor_gate  u_nor  (a, b, y_nor);
    not_gate  u_not  (a, y_not);
    xor_gate  u_xor  (a, b, y_xor);
    xnor_gate u_xnor (a, b, y_xnor);

    initial begin
        $dumpfile("logic_gates_tb.vcd");
        $dumpvars(0, logic_gates_tb);

        a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10 $finish;
    end
endmodule
