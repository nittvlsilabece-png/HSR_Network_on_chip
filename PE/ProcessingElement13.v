`timescale 1ns / 1ps

module ProcessingElement13 (
				input clk,
				input rst,
				input [19:0] datain,
				input in_valid,
				input ci,
				output [19:0] dataout,
				output out_valid,
				output [15:0] read 
			);

	reg [2:0] cnt;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			cnt <= 3'b0;
		end
		else begin
			if (cnt < 3'b111) begin
				if (ci == 1) begin
					cnt <= cnt;
				end
				else begin	
					cnt <= cnt + 1;
				end
			end
			else begin
				if (ci == 1'b1) begin
					cnt <= cnt - 3'b1;
				end
				else begin
					cnt <= cnt;
				end
			end
		end
	end

	wire enable,valid;
	assign enable = (cnt < 3'd7) ? 1 : 0;
	assign out_valid = (dataout && valid) ? 1 : 0;

	dataout_buf_13 dataout_buffer (
					.clk (clk),
					.rst (rst),
					.enable (enable),
					.dataout (dataout),
					.out_valid (valid)
					);
	
	datain_buf datain_buffer (
					.clk (clk),
					.rst (rst),
					.in_valid (in_valid),
					.datain (datain),
					.read (read)
				);

endmodule
					
