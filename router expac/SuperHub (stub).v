//input  : sd_in (20 bits) from crossbar o4 at a cluster hub
//output : one of 4 routers, picked by dest_local (sd_in[1:0])
//cred_any : OR of child credits for simple backpressure

module SuperHub(
			input clk,
			input rst,
			
			input [19:0] sd_in,
			input sd_in_valid,

			input [3:0] cred_child,

			output reg [19:0] out_cluster0,
			output reg [19:0] out_cluster1,
			output reg [19:0] out_cluster2,
			output reg [19:0] out_cluster3,
			output reg	  v_cluster0,
			output reg    v_cluster1,
			output reg	  v_cluster2,
			output reg	  v_cluster3,
			
			output 	    cred_any
		);
		
	wire [1:0] dest_local = sd_in[1:0];
	assign cred_any = |cred_child;

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			{out_cluster0, out_cluster1, out_cluster2, out_cluster3} <= {20'b0, 20'b0, 20'b0, 20'b0};
			{v_cluster0, v_cluster1, v_cluster2, v_cluster3} <= 4'b0000;
		end else begin
			{v_cluster0, v_cluster1, v_cluster2, v_cluster3} <= 4'b0000;

			if (sd_in_valid) begin
				case (dest_local)
					2'd0: begin out_cluster0 <= sd_in; v_cluster0 <= 1'b1; end
					2'd1: begin out_cluster1 <= sd_in; v_cluster1 <= 1'b1; end
					2'd2: begin out_cluster2 <= sd_in; v_cluster2 <= 1'b1; end
					2'd3: begin out_cluster3 <= sd_in; v_cluster3 <= 1'b1; end
				endcase
			end
		end
	end
endmodule

			