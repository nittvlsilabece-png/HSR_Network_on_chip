`timescale 1ns / 1ps

module UpMux_4to1 (
			input clk,
			input rst,
			
			input [19:0] c_data0, input c_vld0, output reg c_cred0,
			input [19:0] c_data1, input c_vld1, output reg c_cred1,
			input [19:0] c_data2, input c_vld2, output reg c_cred2,
			input [19:0] c_data3, input c_vld3, output reg c_cred3,

			output reg [19:0] hub_in3_data,
			output reg hub_in3_valid,
		
			input hub_co3
		);

	wire any_vld = c_vld0 | c_vld1 | c_vld2 | c_vld3;
	wire [1:0] sel_comb = c_vld0 ? 2'd0 : c_vld1 ? 2'd1 : c_vld2 ? 2'd2 : 2'd3;

	reg [1:0] q [0:7];
	reg [2:0] head, tail;
	reg [3:0] pend;

	wire fifo_full = (pend == 8);
	wire fifo_empty = (pend == 0);

	wire accept = any_vld && !fifo_full;

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			hub_in3_valid 	<= 1'b0;
			hub_in3_data	<= 20'b0;
			head <= 3'd0; tail <= 3'd0; pend <= 4'd0;
		end 
		else begin
			hub_in3_valid 	<= 1'b0;
			
			if (accept) begin
				case (sel_comb)
					2'd0: hub_in3_data <= c_data0;
					2'd1: hub_in3_data <= c_data1;
					2'd2: hub_in3_data <= c_data2;
					default: hub_in3_data <= c_data3;
				endcase	
				
				hub_in3_valid <= 1'b1;
		
				q[tail] <= sel_comb;
				tail 	<= tail + 3'd1;
				pend    <= pend + 4'd1;
			end
	
			if (!fifo_empty && hub_co3) begin
				head <= head + 3'd1;
				pend <= pend - 4'd1;
			end
		end
	end
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			c_cred0 <= 1'b0; c_cred1 <= 1'b0; c_cred2 <= 1'b0; c_cred3 <= 1'b0;
		end
		else begin
			c_cred0 <= 1'b0; c_cred1 <= 1'b0; c_cred2 <= 1'b0; c_cred3 <= 1'b0;
			if (!fifo_empty && hub_co3) begin
				case (q[head])
					2'd0: c_cred0 <= 1'b1;
					2'd1: c_cred1 <= 1'b1;
					2'd2: c_cred2 <= 1'b1;
					2'd3: c_cred3 <= 1'b1;
				endcase
			end
		end
	end

endmodule
