`timescale 1ns / 1ps

module ClusterHubTile (
			input clk,
			input rst,
		
			input  [19:0] ring_cw_in,
			input  ring_cw_vi,
			output [19:0] ring_cw_out,
			output ring_cw_vo,
			input  ring_cw_ci,
			output ring_cw_co,

			input  [19:0] ring_ccw_in,
			input  ring_ccw_vi,
			output [19:0] ring_ccw_out,
			output ring_ccw_vo,
			input  ring_ccw_ci,
			output ring_ccw_co,
		
			output [19:0] up_to_SH_data,
			output up_to_SH_valid,
			input  down_from_SH_ci,
			input  [19:0] down_from_SH_data,
			input  down_from_SH_valid,
			output up_to_SH_co,
			
			output [19:0] down_to_leaf0_data,
			output down_to_leaf0_valid,
			input  leaf0_ci,
			output [19:0] down_to_leaf1_data,
			output down_to_leaf1_valid,
			input  leaf1_ci,
			output [19:0] down_to_leaf2_data,
			output down_to_leaf2_valid,
			input  leaf2_ci,
			output [19:0] down_to_leaf3_data,
			output down_to_leaf3_valid,
			input  leaf3_ci,


			input  [19:0] up_from_leaf0_data,
			input  up_from_leaf0_valid,
			output down_to_leaf0_co,
			input  [19:0] up_from_leaf1_data,
			input  up_from_leaf1_valid,
			output down_to_leaf1_co,
			input  [19:0] up_from_leaf2_data,
			input  up_from_leaf2_valid,
			output down_to_leaf2_co,
			input  [19:0] up_from_leaf3_data,
			input  up_from_leaf3_valid,
			output down_to_leaf3_co,

			input [1:0] my_cluster
			);

	wire [19:0] router_o1, router_o2, router_o3, router_o4, router_o5, router_o6, router_o7;
	wire router_vo1, router_vo2, router_vo3, router_vo4, router_vo5, router_vo6, router_vo7;
	wire router_co1, router_co2, router_co3, router_co4, router_co5, router_co6, router_co7;

	Router7 router (
			.clk (clk), .rst(rst),
			
			.in1 (ring_cw_in),  .vi1 (ring_cw_vi),
			.in2 (ring_ccw_in), .vi2 (ring_ccw_vi),
			.in3 (down_from_SH_data), .vi3 (down_from_SH_valid),
			.in4 (up_from_leaf0_data), .vi4 (up_from_leaf0_valid),
			.in5 (up_from_leaf1_data), .vi5 (up_from_leaf1_valid),
			.in6 (up_from_leaf2_data), .vi6 (up_from_leaf2_valid),
			.in7 (up_from_leaf3_data), .vi7 (up_from_leaf3_valid),

			.ci1 (ring_cw_ci),
			.ci2 (ring_ccw_ci),
			.ci3 (down_from_SH_ci),
			.ci4 (leaf0_ci),
			.ci5 (leaf1_ci),
			.ci6 (leaf2_ci),
			.ci7 (leaf3_ci),
	
			.o1 (router_o1), .vo1 (router_vo1), .co1 (router_co1),
			.o2 (router_o2), .vo2 (router_vo2), .co2 (router_co2),
			.o3 (router_o3), .vo3 (router_vo3), .co3 (router_co3),
			.o4 (router_o4), .vo4 (router_vo4), .co4 (router_co4),
			.o5 (router_o5), .vo5 (router_vo5), .co5 (router_co5),
			.o6 (router_o6), .vo6 (router_vo6), .co6 (router_co6),
			.o7 (router_o7), .vo7 (router_vo7), .co7 (router_co7),
			
			.my_cluster (my_cluster),
			.my_local (2'd0),
			.is_hub (1'b1),
			.is_superhub (1'b0)
			);

		assign ring_cw_out = router_o1;
		assign ring_cw_vo  = router_vo1;
		assign ring_cw_co = router_co1;
	
		assign ring_ccw_out = router_o2;
		assign ring_ccw_vo  = router_vo2;
		assign ring_ccw_co  = router_co2;

		assign up_to_SH_data  = router_o3;
		assign up_to_SH_valid = router_vo3;
		assign up_to_SH_co = router_co3;

		assign down_to_leaf0_data = router_o4;
		assign down_to_leaf0_valid = router_vo4;
		assign down_to_leaf0_co = router_co4;

		assign down_to_leaf1_data = router_o5;
		assign down_to_leaf1_valid = router_vo5;
		assign down_to_leaf1_co = router_co5;

		assign down_to_leaf2_data = router_o6;
		assign down_to_leaf2_valid = router_vo6;
		assign down_to_leaf2_co = router_co6;
		
		assign down_to_leaf3_data = router_o7;
		assign down_to_leaf3_valid = router_vo7;
		assign down_to_leaf3_co = router_co7;

endmodule
