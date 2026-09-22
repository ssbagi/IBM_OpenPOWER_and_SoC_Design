/*
 * 4-bit magnitude comparator
 * Compares unsigned values A and B from 0 to F.
 */

module comparator_4bit (
	input  [3:0] a,
	input  [3:0] b,
	output reg  a_greater,
	output reg  b_greater,
	output reg  equal
);

	always @(*) begin
		a_greater = 1'b0;
		b_greater = 1'b0;
		equal = 1'b0;

		if (a[3] != b[3]) begin
			a_greater = a[3];
			b_greater = b[3];
		end else if (a[2] != b[2]) begin
			a_greater = a[2];
			b_greater = b[2];
		end else if (a[1] != b[1]) begin
			a_greater = a[1];
			b_greater = b[1];
		end else if (a[0] != b[0]) begin
			a_greater = a[0];
			b_greater = b[0];
		end else begin
			equal = 1'b1;
		end
	end

endmodule
