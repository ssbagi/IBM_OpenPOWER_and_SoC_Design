# Assignment 4 - 4-bit Up/Down Counter

This folder contains a behavioral Verilog design and self-checking testbench for a synchronous 4-bit up/down counter.

## Files

| File | Purpose |
|---|---|
| [Assignment_04.pdf](Assignment_04.pdf) | Assignment problem statement |
| [4_bit_up_down_behavioural_counter.v](4_bit_up_down_behavioural_counter.v) | Behavioral counter design |
| [4_bit_up_down_behavioural_counter_tb.v](4_bit_up_down_behavioural_counter_tb.v) | Self-checking testbench |
| [4_bit_up_down_synchronous_reset.v](4_bit_up_down_synchronous_reset.v) | Counter with synchronous reset |
| [4_bit_up_down_synchronous_reset_tb.v](4_bit_up_down_synchronous_reset_tb.v) | Exhaustive synchronous-reset testbench |
| [4_bit_up_down_asynchronous_reset.v](4_bit_up_down_asynchronous_reset.v) | Counter with asynchronous reset |
| [4_bit_up_down_asynchronous_reset_tb.v](4_bit_up_down_asynchronous_reset_tb.v) | Exhaustive asynchronous-reset testbench |
| [4_bit_up_down_behavioural_counter_tb.vcd](4_bit_up_down_behavioural_counter_tb.vcd) | Basic counter waveform data |
| [4_bit_up_down_synchronous_reset_tb.vcd](4_bit_up_down_synchronous_reset_tb.vcd) | Synchronous-reset waveform data |
| [4_bit_up_down_asynchronous_reset_tb.vcd](4_bit_up_down_asynchronous_reset_tb.vcd) | Asynchronous-reset waveform data |
| [4_bit_up_down_behavioural_counter_simulation.log](4_bit_up_down_behavioural_counter_simulation.log) | Behavioral counter compile and simulation log |
| [4_bit_up_down_synchronous_reset_simulation.log](4_bit_up_down_synchronous_reset_simulation.log) | Synchronous-reset compile and simulation log |
| [4_bit_up_down_asynchronous_reset_simulation.log](4_bit_up_down_asynchronous_reset_simulation.log) | Asynchronous-reset compile and simulation log |

## Counter Behavior

On every rising edge of `clk`:

```text
reset = 1  -> count = 0
reset = 0 and up = 1 -> count = count + 1
reset = 0 and up = 0 -> count = count - 1
```

The 4-bit output naturally wraps around:

```text
1111 + 1 = 0000
0000 - 1 = 1111
```

## Compile and Simulate

```powershell
iverilog -o sim_4_bit_up_down_counter.vvp 4_bit_up_down_behavioural_counter.v 4_bit_up_down_behavioural_counter_tb.v
vvp .\sim_4_bit_up_down_counter.vvp
gtkwave .\4_bit_up_down_behavioural_counter_tb.vcd
```

The testbench performs 34 checks:

1. Two reset checks, with `up=1` and `up=0`.
2. Sixteen UP COUNT transitions: `0001` through `1111`, then wraparound to `0000`.
3. Sixteen DOWN COUNT transitions: `1111` through `0000`.

Simulation output labels use `RESET`, `UP COUNT`, and `DOWN COUNT`. `up=1` selects UP COUNT; `up=0` selects DOWN COUNT.

### Behavioral Counter Simulation Output

```text
Compile command: iverilog -o sim_4_bit_up_down_counter.vvp 4_bit_up_down_behavioural_counter.v 4_bit_up_down_behavioural_counter_tb.v
Compilation output: no errors
Simulation command: vvp .\sim_4_bit_up_down_counter.vvp

VCD info: dumpfile 4_bit_up_down_behavioural_counter_tb.vcd opened for output.
============================================
	Exhaustive 4-bit Up/Down Counter Test
============================================
up=1: UP COUNT | up=0: DOWN COUNT
PASS: Test 1 | RESET      | up=1 | Count=0000
PASS: Test 2 | RESET      | up=0 | Count=0000
Testing all 16 UP COUNT states...
PASS: Test 3  | UP COUNT   | up=1 | Count=0001
PASS: Test 4  | UP COUNT   | up=1 | Count=0010
PASS: Test 5  | UP COUNT   | up=1 | Count=0011
PASS: Test 6  | UP COUNT   | up=1 | Count=0100
PASS: Test 7  | UP COUNT   | up=1 | Count=0101
PASS: Test 8  | UP COUNT   | up=1 | Count=0110
PASS: Test 9  | UP COUNT   | up=1 | Count=0111
PASS: Test 10 | UP COUNT   | up=1 | Count=1000
PASS: Test 11 | UP COUNT   | up=1 | Count=1001
PASS: Test 12 | UP COUNT   | up=1 | Count=1010
PASS: Test 13 | UP COUNT   | up=1 | Count=1011
PASS: Test 14 | UP COUNT   | up=1 | Count=1100
PASS: Test 15 | UP COUNT   | up=1 | Count=1101
PASS: Test 16 | UP COUNT   | up=1 | Count=1110
PASS: Test 17 | UP COUNT   | up=1 | Count=1111
PASS: Test 18 | UP COUNT   | up=1 | Count=0000
Testing all 16 DOWN COUNT states...
PASS: Test 19 | DOWN COUNT | up=0 | Count=1111
PASS: Test 20 | DOWN COUNT | up=0 | Count=1110
PASS: Test 21 | DOWN COUNT | up=0 | Count=1101
PASS: Test 22 | DOWN COUNT | up=0 | Count=1100
PASS: Test 23 | DOWN COUNT | up=0 | Count=1011
PASS: Test 24 | DOWN COUNT | up=0 | Count=1010
PASS: Test 25 | DOWN COUNT | up=0 | Count=1001
PASS: Test 26 | DOWN COUNT | up=0 | Count=1000
PASS: Test 27 | DOWN COUNT | up=0 | Count=0111
PASS: Test 28 | DOWN COUNT | up=0 | Count=0110
PASS: Test 29 | DOWN COUNT | up=0 | Count=0101
PASS: Test 30 | DOWN COUNT | up=0 | Count=0100
PASS: Test 31 | DOWN COUNT | up=0 | Count=0011
PASS: Test 32 | DOWN COUNT | up=0 | Count=0010
PASS: Test 33 | DOWN COUNT | up=0 | Count=0001
PASS: Test 34 | DOWN COUNT | up=0 | Count=0000
PASS: 34/34 counter tests completed successfully.
```

Recorded terminal-output images: [part 1](Compilation_4_bit_up_down_behavioural_code_part1.png) and [part 2](Compilation_4_bit_up_down_behavioural_code_part2.png).

Complete compile and simulation output: [behavioral counter log](4_bit_up_down_behavioural_counter_simulation.log).

## Reset Implementations

### Synchronous Reset

Reset is checked only on a rising edge of `clk`:

```verilog
always @(posedge clk)
```

```powershell
iverilog -o sim_synchronous_reset.vvp 4_bit_up_down_synchronous_reset.v 4_bit_up_down_synchronous_reset_tb.v
vvp .\sim_synchronous_reset.vvp
gtkwave .\4_bit_up_down_synchronous_reset_tb.vcd
```

Expected result:

```text
Compile command: iverilog -o sim_synchronous_reset.vvp 4_bit_up_down_synchronous_reset.v 4_bit_up_down_synchronous_reset_tb.v
Compilation output: no errors
Simulation command: vvp .\sim_synchronous_reset.vvp

VCD info: dumpfile 4_bit_up_down_synchronous_reset_tb.vcd opened for output.
====================================================
 Synchronous Reset 4-bit Up/Down Counter Test
====================================================
PASS: Test 1  | SYNC RESET | Count=0000
PASS: Test 2  | SYNC RESET | Count=0000

Testing all 16 UP COUNT states...
PASS: Test 3  | UP COUNT   | Count=0001
PASS: Test 4  | UP COUNT   | Count=0010
PASS: Test 5  | UP COUNT   | Count=0011
PASS: Test 6  | UP COUNT   | Count=0100
PASS: Test 7  | UP COUNT   | Count=0101
PASS: Test 8  | UP COUNT   | Count=0110
PASS: Test 9  | UP COUNT   | Count=0111
PASS: Test 10 | UP COUNT   | Count=1000
PASS: Test 11 | UP COUNT   | Count=1001
PASS: Test 12 | UP COUNT   | Count=1010
PASS: Test 13 | UP COUNT   | Count=1011
PASS: Test 14 | UP COUNT   | Count=1100
PASS: Test 15 | UP COUNT   | Count=1101
PASS: Test 16 | UP COUNT   | Count=1110
PASS: Test 17 | UP COUNT   | Count=1111
PASS: Test 18 | UP COUNT   | Count=0000

Testing all 16 DOWN COUNT states...
PASS: Test 19 | DOWN COUNT | Count=1111
PASS: Test 20 | DOWN COUNT | Count=1110
PASS: Test 21 | DOWN COUNT | Count=1101
PASS: Test 22 | DOWN COUNT | Count=1100
PASS: Test 23 | DOWN COUNT | Count=1011
PASS: Test 24 | DOWN COUNT | Count=1010
PASS: Test 25 | DOWN COUNT | Count=1001
PASS: Test 26 | DOWN COUNT | Count=1000
PASS: Test 27 | DOWN COUNT | Count=0111
PASS: Test 28 | DOWN COUNT | Count=0110
PASS: Test 29 | DOWN COUNT | Count=0101
PASS: Test 30 | DOWN COUNT | Count=0100
PASS: Test 31 | DOWN COUNT | Count=0011
PASS: Test 32 | DOWN COUNT | Count=0010
PASS: Test 33 | DOWN COUNT | Count=0001
PASS: Test 34 | DOWN COUNT | Count=0000
PASS: 34/34 synchronous-reset tests passed.
```

Complete compile and simulation output: [synchronous-reset log](4_bit_up_down_synchronous_reset_simulation.log).

### Asynchronous Reset

Reset clears the count immediately when it changes from `0` to `1`:

```verilog
always @(posedge clk or posedge reset)
```

```powershell
iverilog -o sim_asynchronous_reset.vvp 4_bit_up_down_asynchronous_reset.v 4_bit_up_down_asynchronous_reset_tb.v
vvp .\sim_asynchronous_reset.vvp
gtkwave .\4_bit_up_down_asynchronous_reset_tb.vcd
```

Expected result:

```text
Compile command: iverilog -o sim_asynchronous_reset.vvp 4_bit_up_down_asynchronous_reset.v 4_bit_up_down_asynchronous_reset_tb.v
Compilation output: no errors
Simulation command: vvp .\sim_asynchronous_reset.vvp

VCD info: dumpfile 4_bit_up_down_asynchronous_reset_tb.vcd opened for output.
====================================================
Asynchronous Reset 4-bit Up/Down Counter Test
====================================================
PASS: Test 1 | ASYNC RESET | Count=0000
PASS: Test 2 | ASYNC RESET | Count=0000

Testing all 16 UP COUNT states...
PASS: Test 3  | UP COUNT   | Count=0001
PASS: Test 4  | UP COUNT   | Count=0010
PASS: Test 5  | UP COUNT   | Count=0011
PASS: Test 6  | UP COUNT   | Count=0100
PASS: Test 7  | UP COUNT   | Count=0101
PASS: Test 8  | UP COUNT   | Count=0110
PASS: Test 9  | UP COUNT   | Count=0111
PASS: Test 10 | UP COUNT   | Count=1000
PASS: Test 11 | UP COUNT   | Count=1001
PASS: Test 12 | UP COUNT   | Count=1010
PASS: Test 13 | UP COUNT   | Count=1011
PASS: Test 14 | UP COUNT   | Count=1100
PASS: Test 15 | UP COUNT   | Count=1101
PASS: Test 16 | UP COUNT   | Count=1110
PASS: Test 17 | UP COUNT   | Count=1111
PASS: Test 18 | UP COUNT   | Count=0000

Testing all 16 DOWN COUNT states...
PASS: Test 19 | DOWN COUNT | Count=1111
PASS: Test 20 | DOWN COUNT | Count=1110
PASS: Test 21 | DOWN COUNT | Count=1101
PASS: Test 22 | DOWN COUNT | Count=1100
PASS: Test 23 | DOWN COUNT | Count=1011
PASS: Test 24 | DOWN COUNT | Count=1010
PASS: Test 25 | DOWN COUNT | Count=1001
PASS: Test 26 | DOWN COUNT | Count=1000
PASS: Test 27 | DOWN COUNT | Count=0111
PASS: Test 28 | DOWN COUNT | Count=0110
PASS: Test 29 | DOWN COUNT | Count=0101
PASS: Test 30 | DOWN COUNT | Count=0100
PASS: Test 31 | DOWN COUNT | Count=0011
PASS: Test 32 | DOWN COUNT | Count=0010
PASS: Test 33 | DOWN COUNT | Count=0001
PASS: Test 34 | DOWN COUNT | Count=0000
PASS: 34/34 asynchronous-reset tests passed.
```

Complete compile and simulation output: [asynchronous-reset log](4_bit_up_down_asynchronous_reset_simulation.log).

Both reset-variant testbenches perform 34 checks: two reset checks, 16 up-count transitions, and 16 down-count transitions.

## Reset Comparison

| Reset type | Behavioral block | When `count` becomes `0000` |
|---|---|---|
| Synchronous | `always @(posedge clk)` | At the next rising clock edge while `reset=1` |
| Asynchronous | `always @(posedge clk or posedge reset)` | Immediately when `reset` changes from `0` to `1` |
