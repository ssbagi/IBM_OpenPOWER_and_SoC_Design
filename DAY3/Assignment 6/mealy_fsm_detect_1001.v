`timescale 1ns/1ps

module mealy_fsm_detect_1001 (
	input  wire clk,
	input  wire reset,
	input  wire data_in,
	output reg  detected
);

	localparam [1:0] S0 = 2'b00,
					 S1 = 2'b01,
					 S2 = 2'b10,
					 S3 = 2'b11;

	reg [1:0] PS, NS;

	always @(posedge clk) begin
		if (reset)
			PS <= S0;
		else
			PS <= NS;
	end

	always @(PS or data_in) begin
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
				NS = data_in ? S1 : S0;
			end

			default: NS = S0;
		endcase
	end

	always @(PS or data_in) begin
		case (PS)
			S0, S1, S2: detected = 1'b0;
			S3: detected = data_in;
			default: detected = 1'b0;
		endcase
	end

endmodule
