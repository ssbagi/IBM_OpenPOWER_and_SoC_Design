`timescale 1ns/1ps

module moore_fsm_detect_1001_nonoverlap (
	input  wire clk,
	input  wire reset,
	input  wire data_in,
	output reg  detected
);

	localparam [2:0] S0 = 3'b000,
					 S1 = 3'b001,
					 S2 = 3'b010,
					 S3 = 3'b011,
					 S4 = 3'b100;

	reg [2:0] PS, NS;

	always @(posedge clk) begin
		if (reset)
			PS <= S0;
		else
			PS <= NS;
	end

	always @(PS, data_in) begin
		NS = S0;

		case (PS)
			S0: begin
				NS = data_in ? S1 : S0;
			end

			S1: begin
				NS = data_in ? S1 : S2;
			end

			S2: begin
				NS = data_in ? S1 : S3;
			end

			S3: begin
				NS = data_in ? S4 : S0;
			end

			S4: begin
				NS = data_in ? S1 : S0;
			end

			default: NS = S0;
		endcase
	end

	always @(PS) begin
		case (PS)
			S0, S1, S2, S3: detected = 1'b0;
			S4: detected = 1'b1;
			default: detected = 1'b0;
		endcase
	end

endmodule
