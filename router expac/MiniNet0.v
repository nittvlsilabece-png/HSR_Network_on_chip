`timescale 1ns / 1ps

module mininetwork0 (
		input clk,
		input rst,
		output state,

		input [1:0] cluster,

		output [19:0] hub_ring_cw_out,
		input hub_ring_cw_ci,
		output hub_ring_cw_vo,

		input [19:0] hub_ring_cw_in,
		output  hub_ring_cw_co,
		input  hub_ring_cw_vi,

		output [19:0] hub_ring_ccw_out,
		input  hub_ring_ccw_ci,
		output hub_ring_ccw_vo,

		input [19:0] hub_ring_ccw_in,
		output hub_ring_ccw_co,
		input  hub_ring_ccw_vi,

		input [19:0] hub_down_from_SH_data,
		output hub_up_to_SH_co,
		input hub_down_from_SH_valid,

		output [19:0] hub_up_to_SH_data,
		input hub_down_from_SH_ci,
		output hub_up_to_SH_valid,

		output [15:0] read0,
		output [15:0] read1,
		output [15:0] read2,
		output [15:0] read3
		);

	wire [19:0] n_in1 [0:3], n_in2 [0:3], n_in3 [0:3], n_in4 [0:3];
	wire	    n_vi1 [0:3], n_vi2 [0:3], n_vi3 [0:3], n_vi4 [0:3];
	wire 	    n_ci1 [0:3], n_ci2 [0:3], n_ci3 [0:3], n_ci4 [0:3];

	wire [19:0] n_o1  [0:3], n_o2  [0:3], n_o3  [0:3], n_o4  [0:3];
	wire 	    n_vo1 [0:3], n_vo2 [0:3], n_vo3 [0:3], n_vo4 [0:3];
	wire 	    n_co1 [0:3], n_co2 [0:3], n_co3 [0:3], n_co4 [0:3];
	
	genvar gi;
	generate
		for (gi = 0; gi < 4; gi = gi + 1) begin : G_TIE
			assign n_in3[gi] = 20'b0;
			assign n_vi3[gi] = 1'b0;
			assign n_ci4[gi] = 1'b0;
		end
	endgenerate

	Node0 u_node0 (
			.clk (clk), .rst (rst),
			.in1 (n_in1[0]), .in2 (n_in2[0]), .in3 (n_in3[0]), .in4 (n_in4[0]),
			.vi1 (n_vi1[0]), .vi2 (n_vi2[0]), .vi3 (n_vi3[0]), .vi4 (n_vi4[0]),
			.ci1 (n_ci1[0]), .ci2 (n_ci2[0]), .ci3 (n_ci3[0]), .ci4 (n_ci4[0]),
			.my_cluster (cluster), .my_local (2'b00),
			.is_hub (1'b0), .is_superhub (1'b0),
			.o1 (n_o1[0]), .o2 (n_o2[0]), .o3 (n_o3[0]), .o4 (n_o4[0]),
			.vo1 (n_vo1[0]), .vo2 (n_vo2[0]), .vo3 (n_vo3[0]), .vo4 (n_vo4[0]),
			.co1 (n_co1[0]), .co2 (n_co2[0]), .co3 (n_co3[0]), .co4 (n_co4[0]),
			.state (state), .read (read0)
			);
		
	Node1 u_node1 (
			.clk (clk), .rst (rst),
			.in1 (n_in1[1]), .in2 (n_in2[1]), .in3 (n_in3[1]), .in4 (n_in4[1]),
			.vi1 (n_vi1[1]), .vi2 (n_vi2[1]), .vi3 (n_vi3[1]), .vi4 (n_vi4[1]),
			.ci1 (n_ci1[1]), .ci2 (n_ci2[1]), .ci3 (n_ci3[1]), .ci4 (n_ci4[1]),
			.my_cluster (cluster), .my_local (2'b01),
			.is_hub (1'b0), .is_superhub (1'b0),
			.o1 (n_o1[1]), .o2 (n_o2[1]), .o3 (n_o3[1]), .o4 (n_o4[1]),
			.vo1 (n_vo1[1]), .vo2 (n_vo2[1]), .vo3 (n_vo3[1]), .vo4 (n_vo4[1]),
			.co1 (n_co1[1]), .co2 (n_co2[1]), .co3 (n_co3[1]), .co4 (n_co4[1]),
			.read (read1)
			);

	Node2 u_node2 (
			.clk (clk), .rst (rst),
			.in1 (n_in1[2]), .in2 (n_in2[2]), .in3 (n_in3[2]), .in4 (n_in4[2]),
			.vi1 (n_vi1[2]), .vi2 (n_vi2[2]), .vi3 (n_vi3[2]), .vi4 (n_vi4[2]),
			.ci1 (n_ci1[2]), .ci2 (n_ci2[2]), .ci3 (n_ci3[2]), .ci4 (n_ci4[2]),
			.my_cluster (cluster), .my_local (2'b10),
			.is_hub (1'b0), .is_superhub (1'b0),
			.o1 (n_o1[2]), .o2 (n_o2[2]), .o3 (n_o3[2]), .o4 (n_o4[2]),
			.vo1 (n_vo1[2]), .vo2 (n_vo2[2]), .vo3 (n_vo3[2]), .vo4 (n_vo4[2]),
			.co1 (n_co1[2]), .co2 (n_co2[2]), .co3 (n_co3[2]), .co4 (n_co4[2]),
			.read (read2)
			);

	Node3 u_node3 (
			.clk (clk), .rst (rst),
			.in1 (n_in1[3]), .in2 (n_in2[3]), .in3 (n_in3[3]), .in4 (n_in4[3]),
			.vi1 (n_vi1[3]), .vi2 (n_vi2[3]), .vi3 (n_vi3[3]), .vi4 (n_vi4[3]),
			.ci1 (n_ci1[3]), .ci2 (n_ci2[3]), .ci3 (n_ci3[3]), .ci4 (n_ci4[3]),
			.my_cluster (cluster), .my_local (2'b11),
			.is_hub (1'b0), .is_superhub (1'b0),
			.o1 (n_o1[3]), .o2 (n_o2[3]), .o3 (n_o3[3]), .o4 (n_o4[3]),
			.vo1 (n_vo1[3]), .vo2 (n_vo2[3]), .vo3 (n_vo3[3]), .vo4 (n_vo4[3]),
			.co1 (n_co1[3]), .co2 (n_co2[3]), .co3 (n_co3[3]), .co4 (n_co4[3]),
			.read (read3)
			);

	assign n_in1[0] = n_o1[3]; assign n_vi1[0] = n_vo1[3]; assign n_ci1[3] = n_co1[0];
	assign n_in1[1] = n_o1[0]; assign n_vi1[1] = n_vo1[0]; assign n_ci1[0] = n_co1[1];
	assign n_in1[2] = n_o1[1]; assign n_vi1[2] = n_vo1[1]; assign n_ci1[1] = n_co1[2];
	assign n_in1[3] = n_o1[2]; assign n_vi1[3] = n_vo1[2]; assign n_ci1[2] = n_co1[3];
	
	assign n_in2[0] = n_o2[1]; assign n_vi2[0] = n_vo2[1]; assign n_ci2[1] = n_co2[0];
	assign n_in2[1] = n_o2[2]; assign n_vi2[1] = n_vo2[2]; assign n_ci2[2] = n_co2[1];
	assign n_in2[2] = n_o2[3]; assign n_vi2[2] = n_vo2[3]; assign n_ci2[3] = n_co2[2];
	assign n_in2[3] = n_o2[0]; assign n_vi2[3] = n_vo2[0]; assign n_ci2[0] = n_co2[3];

	wire [19:0] hub_dn_d [0:3]; wire hub_dn_v [0:3]; wire leaf_ci [0:3];			//input from router7
	wire [19:0] hub_up_d [0:3]; wire hub_up_v [0:3]; wire hub_up_co [0:3];			//output to router7

	assign hub_up_d[0] = n_o3[0]; assign hub_up_v[0] = n_vo3[0]; assign n_ci3[0] = hub_up_co[0];
	assign hub_up_d[1] = n_o3[1]; assign hub_up_v[1] = n_vo3[1]; assign n_ci3[1] = hub_up_co[1];
	assign hub_up_d[2] = n_o3[2]; assign hub_up_v[2] = n_vo3[2]; assign n_ci3[2] = hub_up_co[2];
	assign hub_up_d[3] = n_o3[3]; assign hub_up_v[3] = n_vo3[3]; assign n_ci3[3] = hub_up_co[3];

	assign n_in4[0] = hub_dn_d[0]; assign n_vi4[0] = hub_dn_v[0]; assign leaf_ci[0] = n_co4[0];
	assign n_in4[1] = hub_dn_d[1]; assign n_vi4[1] = hub_dn_v[1]; assign leaf_ci[1] = n_co4[1];
	assign n_in4[2] = hub_dn_d[2]; assign n_vi4[2] = hub_dn_v[2]; assign leaf_ci[2] = n_co4[2];
	assign n_in4[3] = hub_dn_d[3]; assign n_vi4[3] = hub_dn_v[3]; assign leaf_ci[3] = n_co4[3];

	ClusterHubTile u_hub (
				.clk (clk), .rst (rst),
				.ring_cw_in   (hub_ring_cw_in),
				.ring_cw_vi   (hub_ring_cw_vi),
				.ring_cw_out  (hub_ring_cw_out),
				.ring_cw_vo   (hub_ring_cw_vo),
				.ring_cw_ci   (hub_ring_cw_ci),
				.ring_cw_co   (hub_ring_cw_co),
				.ring_ccw_in  (hub_ring_ccw_in),
				.ring_ccw_vi  (hub_ring_ccw_vi),
				.ring_ccw_out (hub_ring_ccw_out),
				.ring_ccw_vo  (hub_ring_ccw_vo),
				.ring_ccw_ci  (hub_ring_ccw_ci),
				.ring_ccw_co  (hub_ring_ccw_co),

				.up_to_SH_data (hub_up_to_SH_data),
				.up_to_SH_valid (hub_up_to_SH_valid),
				.up_to_SH_co (hub_up_to_SH_co),
				
				.down_from_SH_data (hub_down_from_SH_data),
				.down_from_SH_valid (hub_down_from_SH_valid),
				.down_from_SH_ci (hub_down_from_SH_ci),
	
				.down_to_leaf0_data (hub_dn_d[0]), .down_to_leaf0_valid (hub_dn_v[0]), .leaf0_ci (leaf_ci[0]),
				.down_to_leaf1_data (hub_dn_d[1]), .down_to_leaf1_valid (hub_dn_v[1]), .leaf1_ci (leaf_ci[1]),
				.down_to_leaf2_data (hub_dn_d[2]), .down_to_leaf2_valid (hub_dn_v[2]), .leaf2_ci (leaf_ci[2]),
	            .down_to_leaf3_data (hub_dn_d[3]), .down_to_leaf3_valid (hub_dn_v[3]), .leaf3_ci (leaf_ci[3]),

				.up_from_leaf0_data (hub_up_d[0]), .up_from_leaf0_valid (hub_up_v[0]), .down_to_leaf0_co (hub_up_co[0]),
    		    .up_from_leaf1_data (hub_up_d[1]), .up_from_leaf1_valid (hub_up_v[1]), .down_to_leaf1_co (hub_up_co[1]),
    			.up_from_leaf2_data (hub_up_d[2]), .up_from_leaf2_valid (hub_up_v[2]), .down_to_leaf2_co (hub_up_co[2]),
    			.up_from_leaf3_data (hub_up_d[3]), .up_from_leaf3_valid (hub_up_v[3]), .down_to_leaf3_co (hub_up_co[3]),

    			.my_cluster (cluster)
  );

endmodule                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
