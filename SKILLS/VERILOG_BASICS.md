# Verilog HDL Basics

This reference covers the Verilog syntax and simulation patterns used in the NIELIT ASIC assignments.

## 1. Module Structure

A module defines a reusable hardware block. Ports describe signals entering and leaving the block.

```verilog
module and_gate (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule
```

Useful port directions:

- `input`: signal received by the module.
- `output`: signal produced by the module.
- `inout`: bidirectional signal, used only when required.

A bus is declared with a range. For example, `wire [3:0] data` is a 4-bit signal with bits `data[3]` through `data[0]`.

## 2. Common Data Types

- `wire`: driven by a continuous assignment or module connection.
- `reg`: assigned inside an `initial` or `always` procedural block. `reg` does not necessarily mean a physical register.
- `integer`: commonly used for loop counters in testbenches.

In SystemVerilog, `logic` can usually replace `reg` for a single driver.

## 3. Operators

| Operator | Meaning | Example |
| --- | --- | --- |
| `&` | Bitwise AND | `y = a & b` |
| `|` | Bitwise OR | `y = a | b` |
| `^` | Bitwise XOR | `y = a ^ b` |
| `~` | Bitwise NOT | `y = ~a` |
| `&&` | Logical AND | `if (enable && valid)` |
| `||` | Logical OR | `if (a || b)` |
| `!` | Logical NOT | `if (!reset)` |
| `==` | Equality comparison | `if (a == b)` |
| `!=` | Inequality comparison | `if (a != b)` |
| `? :` | Conditional operator | `y = sel ? b : a` |

Use bitwise operators for buses and Boolean logic. Use logical operators for conditions.

### Bitwise Operation Examples

Bitwise operators work on each pair of bits at the same position. If the inputs are 4 bits wide, the result is also 4 bits wide.

| A | B | `A & B` | `A | B` | `A ^ B` |
| --- | --- | --- | --- | --- |
| `1010` | `1100` | `1000` | `1110` | `0110` |

Bitwise NOT inverts every bit:

| A | `~A` |
| --- | --- |
| `1010` | `0101` |

### Reduction Operation Examples

Reduction operators combine all bits of one vector and produce a single bit. They are different from bitwise operators because the result is one bit, not a bus.

For `A = 1010`:

| Operation | Meaning | Output |
| --- | --- | --- |
| `&A` | AND of all bits: `1 & 0 & 1 & 0` | `0` |
| `|A` | OR of all bits: `1 | 0 | 1 | 0` | `1` |
| `^A` | XOR of all bits: `1 ^ 0 ^ 1 ^ 0` | `0` |
| `~&A` | NAND reduction | `1` |
| `~|A` | NOR reduction | `0` |
| `~^A` | XNOR reduction | `1` |

Reduction results for common 4-bit values:

| A | `&A` | `|A` | `^A` |
| --- | --- | --- | --- |
| `0000` | `0` | `0` | `0` |
| `0001` | `0` | `1` | `1` |
| `1111` | `1` | `1` | `0` |
| `1010` | `0` | `1` | `0` |

The key difference is:

- Bitwise AND: `1010 & 1100 = 1000`, producing four output bits.
- Reduction AND: `&1010 = 0`, producing one output bit.

## 4. Dataflow Modeling

Dataflow logic uses continuous `assign` statements. It is useful when the output can be described directly by an expression.

```verilog
module binary_to_gray (
    input  [3:0] binary,
    output [3:0] gray
);
    assign gray[3] = binary[3];
    assign gray[2] = binary[3] ^ binary[2];
    assign gray[1] = binary[2] ^ binary[1];
    assign gray[0] = binary[1] ^ binary[0];
endmodule
```

A continuous assignment updates whenever a signal on its right-hand side changes.

## 5. Combinational Procedural Modeling

Use `always @(*)` when describing combinational logic with `if`, `else`, or `case` statements.

```verilog
module encoder_2_to_1 (
    input  [1:0] in,
    output reg   out
);
    always @(*) begin
        case (in)
            2'b01:   out = 1'b0;
            2'b10:   out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule
```

Important rules:

- Assign every output on every possible path.
- Set a default value before conditional logic when appropriate.
- Include every read signal in the sensitivity list; `@(*)` does this automatically.
- Do not add `#` delays to synthesizable combinational RTL.

## 6. Sequential Modeling

Clocked logic uses an edge-sensitive sensitivity list. Nonblocking assignments are preferred for flip-flops.

```verilog
module register_4bit (
    input        clk,
    input        reset,
    input  [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (reset)
            data_out <= 4'b0000;
        else
            data_out <= data_in;
    end
endmodule
```

Use `=` for most combinational procedural assignments and `<=` for clocked sequential assignments.

## 7. Testbench Structure

A testbench has no external ports. It creates the design under test, drives inputs, waits for the result, and checks outputs.

```verilog
`timescale 1ns/1ps

module example_tb;
    reg a;
    reg b;
    wire y;

    and_gate dut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        a = 1'b0;
        b = 1'b0;
        #10;
        a = 1'b1;
        #10;
        $display("a=%b b=%b y=%b", a, b, y);
        $finish;
    end
endmodule
```

Useful system tasks:

- `$display`: prints once when executed.
- `$monitor`: prints whenever one of its arguments changes.
- `$dumpfile`: names a VCD waveform file.
- `$dumpvars`: selects signals to record in the VCD.
- `$finish`: ends the simulation.
- `$fatal`: stops the simulation with an error.

For a combinational DUT, wait a small simulation step such as `#1` after changing inputs before checking outputs. This allows zero-delay RTL processes to settle.

## 8. Loops and Exhaustive Tests

A `for` loop is useful for applying every value in a range.

```verilog
integer value;

for (value = 0; value < 16; value = value + 1) begin
    data_in = value;
    #1;
end
```

For two 4-bit inputs, nested loops cover all $16 x 16 = 256$ combinations:

```verilog
for (a_value = 0; a_value < 16; a_value = a_value + 1) begin
    for (b_value = 0; b_value < 16; b_value = b_value + 1) begin
        check_case(a_value, b_value);
    end
end
```

A good verification flow can run a few deterministic random tests first, then perform exhaustive coverage.

## 9. Compilation and Simulation with Icarus Verilog

From an assignment directory:

```powershell
iverilog -g2012 -o sim.vvp design.v design_tb.v
vvp sim.vvp
```

From the repository root, quote paths containing spaces:

```powershell
iverilog -g2012 -o "DAY2/Assignment 2/sim.vvp" "DAY2/Assignment 2/design.v" "DAY2/Assignment 2/design_tb.v"
vvp "DAY2/Assignment 2/sim.vvp"
```

The `-g2012` option enables SystemVerilog-2012 language support in Icarus Verilog.

## 10. Waveforms and Timing

A VCD file records signal transitions for viewing in a waveform viewer. The testbench controls when inputs change; combinational RTL normally responds without an intentional time delay.

```verilog
$dumpfile("design_tb.vcd");
$dumpvars(0, design_tb);
```

A `#10` in a testbench means wait 10 simulation time units before applying the next stimulus. It does not add a hardware delay to a combinational module. Delta-cycle changes may appear at the same simulation timestamp while dependent logic settles.

## 11. Common Mistakes

- Compiling from the wrong directory or forgetting to quote paths with spaces.
- Connecting ports positionally in the wrong order; named connections are safer.
- Forgetting a default branch in combinational `case` logic.
- Omitting a signal from an `always` sensitivity list; use `always @(*)`.
- Using blocking assignments inconsistently in clocked logic; use nonblocking assignments for registers.
- Assuming `$monitor` prints one line per test; it prints on every watched signal change.
- Forgetting to compile both the design file and its testbench.
- Treating generated `.vcd` and `.vvp` files as source code; they are simulation artifacts.

## 12. Naming and Style

- Use descriptive module and signal names.
- Keep one module per source file when practical.
- Align bus widths explicitly, for example `input [3:0] a`.
- Keep testbench stimulus and checking separate from synthesizable RTL.
- Add a short header describing the purpose of each module.

## 13. Detailed Testbench Verification

A complete testbench should do more than apply inputs. It should verify expected outputs, report failures clearly, and provide enough waveform information to debug the DUT.

### Checking Expected Results

Use case inequality `!==` when unknown (`X`) or high-impedance (`Z`) values should cause a failure.

```verilog
if (y !== (a & b)) begin
    $display("FAIL: a=%b b=%b expected=%b got=%b", a, b, a & b, y);
    $fatal(1);
end
```

For a comparator, the three output flags should be mutually exclusive:

```verilog
if ((a > b) && ({a_greater, b_greater, equal} !== 3'b100))
    $fatal(1, "Incorrect A > B result");
else if ((a < b) && ({a_greater, b_greater, equal} !== 3'b010))
    $fatal(1, "Incorrect A < B result");
else if ((a == b) && ({a_greater, b_greater, equal} !== 3'b001))
    $fatal(1, "Incorrect equality result");
```

### Reusable Checking Tasks

A task avoids repeating the same stimulus and checking code:

```verilog
task automatic check_case;
    input [3:0] test_a;
    input [3:0] test_b;
    begin
        a = test_a;
        b = test_b;
        #1;
        $display("A=%0d B=%0d", test_a, test_b);
    end
endtask
```

Call the task from the main `initial` block:

```verilog
check_case(4'd3, 4'd5);
check_case(4'd9, 4'd2);
```

Use `automatic` so each task call has its own temporary storage.

### Random and Exhaustive Verification

Random tests quickly exercise varied input combinations. A fixed seed makes the sequence repeatable:

```verilog
random_seed = 32'h1ACE_B00C;

for (random_index = 0; random_index < 20; random_index = random_index + 1) begin
    random_a = $random(random_seed) & 4'hF;
    random_b = $random(random_seed) & 4'hF;
    check_case(random_a, random_b);
end
```

For two 4-bit inputs, nested loops provide complete coverage:

```verilog
for (a_value = 0; a_value < 16; a_value = a_value + 1) begin
    for (b_value = 0; b_value < 16; b_value = b_value + 1) begin
        check_case(a_value, b_value);
    end
end
```

The recommended order is directed tests, deterministic random tests, and then exhaustive tests when the input space is small enough.

### Waveform Dumping

Use VCD system tasks to record signals for a waveform viewer:

```verilog
initial begin
    $dumpfile("design_tb.vcd");
    $dumpvars(0, design_tb);
end
```

`$dumpvars(0, design_tb)` records the testbench scope and the DUT hierarchy below it. To limit the dump, select specific signals:

```verilog
$dumpvars(0, a, b, y);
```

For combinational logic, output changes normally occur at the same simulation timestamp after delta-cycle settling. A testbench `#10` controls when the next input is applied; it does not add an intentional hardware delay to the DUT.

## 14. Testbench Checklist

- Declare input-driving signals as `reg` or `logic`.
- Declare DUT outputs as `wire` or `logic`.
- Instantiate the DUT with named port connections.
- Initialize every input before checking outputs.
- Wait for combinational logic to settle before checking.
- Print useful decimal, binary, or hexadecimal values.
- Check outputs against expected values.
- Use random tests for varied cases and exhaustive tests for small input spaces.
- Generate a VCD when waveform inspection is needed.
- Finish with a clear `PASS` or `FAIL` result and call `$finish`.
