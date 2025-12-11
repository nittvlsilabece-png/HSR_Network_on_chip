`timescale 1ns / 1ps

module Network (
    input clk,
    input rst,

    output state0,
    output state1,
    output state2,
    output state3,
    
    output [15:0] read0,
    output [15:0] read1,
    output [15:0] read2,
    output [15:0] read3,
    output [15:0] read4,
    output [15:0] read5,
    output [15:0] read6,
    output [15:0] read7,
    output [15:0] read8,
    output [15:0] read9,
    output [15:0] read10,
    output [15:0] read11,
    output [15:0] read12,
    output [15:0] read13,
    output [15:0] read14,
    output [15:0] read15
);

	wire [19:0] n_in1 [0:3], n_in2 [0:3], n_in3 [0:3];//1 - cw, 2 - ccw, 3 - SH
	wire	    n_vi1 [0:3], n_vi2 [0:3], n_vi3 [0:3];
	wire 	    n_ci1 [0:3], n_ci2 [0:3], n_ci3 [0:3];

	wire [19:0] n_o1  [0:3], n_o2  [0:3], n_o3  [0:3];
	wire 	    n_vo1 [0:3], n_vo2 [0:3], n_vo3 [0:3];
	wire 	    n_co1 [0:3], n_co2 [0:3], n_co3 [0:3];

    mininetwork0 cluster0(
	    	.clk(clk),
		    .rst(rst),
            .state(state0),

            .cluster(2'b00),

            .hub_ring_cw_out(n_o1[0]),
            .hub_ring_cw_ci(n_ci1[0]),
            .hub_ring_cw_vo(n_vo1[0]),

            .hub_ring_cw_in(n_in1[0]),
            .hub_ring_cw_co(n_co1[0]),
            .hub_ring_cw_vi(n_vi1[0]),

            .hub_ring_ccw_out(n_o2[0]),
            .hub_ring_ccw_ci(n_ci2[0]),
            .hub_ring_ccw_vo(n_vo2[0]),

            .hub_ring_ccw_in(n_in2[0]),
            .hub_ring_ccw_co(n_co2[0]),
            .hub_ring_ccw_vi(n_vi2[0]),

            .hub_down_from_SH_data(n_in3[0]),
            .hub_up_to_SH_co(n_co3[0]),
            .hub_down_from_SH_valid(n_vi3[0]),

            .hub_up_to_SH_data(n_o3[0]),
            .hub_down_from_SH_ci(n_ci3[0]),
            .hub_up_to_SH_valid(n_vo3[0]),

            .read0(read0),
            .read1(read1),
            .read2(read2),
            .read3(read3)
            );


    mininetwork1 cluster1(
	    	.clk(clk),
		    .rst(rst),
            .state(state1),

            .cluster(2'b01),

            .hub_ring_cw_out(n_o1[1]),
            .hub_ring_cw_ci(n_ci1[1]),
            .hub_ring_cw_vo(n_vo1[1]),

            .hub_ring_cw_in(n_in1[1]),
            .hub_ring_cw_co(n_co1[1]),
            .hub_ring_cw_vi(n_vi1[1]),

            .hub_ring_ccw_out(n_o2[1]),
            .hub_ring_ccw_ci(n_ci2[1]),
            .hub_ring_ccw_vo(n_vo2[1]),

            .hub_ring_ccw_in(n_in2[1]),
            .hub_ring_ccw_co(n_co2[1]),
            .hub_ring_ccw_vi(n_vi2[1]),

            .hub_down_from_SH_data(n_in3[1]),
            .hub_up_to_SH_co(n_co3[1]),
            .hub_down_from_SH_valid(n_vi3[1]),

            .hub_up_to_SH_data(n_o3[1]),
            .hub_down_from_SH_ci(n_ci3[1]),
            .hub_up_to_SH_valid(n_vo3[1]),

            .read0(read4),
            .read1(read5),
            .read2(read6),
            .read3(read7)
            );


    mininetwork2 cluster2(
	    	.clk(clk),
		    .rst(rst),
            .state(state2),

            .cluster(2'b10),

            .hub_ring_cw_out(n_o1[2]),
            .hub_ring_cw_ci(n_ci1[2]),
            .hub_ring_cw_vo(n_vo1[2]),

            .hub_ring_cw_in(n_in1[2]),
            .hub_ring_cw_co(n_co1[2]),
            .hub_ring_cw_vi(n_vi1[2]),

            .hub_ring_ccw_out(n_o2[2]),
            .hub_ring_ccw_ci(n_ci2[2]),
            .hub_ring_ccw_vo(n_vo2[2]),

            .hub_ring_ccw_in(n_in2[2]),
            .hub_ring_ccw_co(n_co2[2]),
            .hub_ring_ccw_vi(n_vi2[2]),

            .hub_down_from_SH_data(n_in3[2]),
            .hub_up_to_SH_co(n_co3[2]),
            .hub_down_from_SH_valid(n_vi3[2]),

            .hub_up_to_SH_data(n_o3[2]),
            .hub_down_from_SH_ci(n_ci3[2]),
            .hub_up_to_SH_valid(n_vo3[2]),

            .read0(read8),
            .read1(read9),
            .read2(read10),
            .read3(read11)
            );

    mininetwork3 cluster3(
	    	.clk(clk),
		    .rst(rst),
            .state(state3),

            .cluster(2'b11),

            .hub_ring_cw_out(n_o1[3]),
            .hub_ring_cw_ci(n_ci1[3]),
            .hub_ring_cw_vo(n_vo1[3]),

            .hub_ring_cw_in(n_in1[3]),
            .hub_ring_cw_co(n_co1[3]),
            .hub_ring_cw_vi(n_vi1[3]),

            .hub_ring_ccw_out(n_o2[3]),
            .hub_ring_ccw_ci(n_ci2[3]),
            .hub_ring_ccw_vo(n_vo2[3]),

            .hub_ring_ccw_in(n_in2[3]),
            .hub_ring_ccw_co(n_co2[3]),
            .hub_ring_ccw_vi(n_vi2[3]),

            .hub_down_from_SH_data(n_in3[3]),
            .hub_up_to_SH_co(n_co3[3]),
            .hub_down_from_SH_valid(n_vi3[3]),

            .hub_up_to_SH_data(n_o3[3]),
            .hub_down_from_SH_ci(n_ci3[3]),
            .hub_up_to_SH_valid(n_vo3[3]),

            .read0(read12),
            .read1(read13),
            .read2(read14),
            .read3(read15)
            );

	assign n_in1[0] = n_o1[3]; assign n_vi1[0] = n_vo1[3]; assign n_ci1[3] = n_co1[0];
	assign n_in1[1] = n_o1[0]; assign n_vi1[1] = n_vo1[0]; assign n_ci1[0] = n_co1[1];
	assign n_in1[2] = n_o1[1]; assign n_vi1[2] = n_vo1[1]; assign n_ci1[1] = n_co1[2];
	assign n_in1[3] = n_o1[2]; assign n_vi1[3] = n_vo1[2]; assign n_ci1[2] = n_co1[3];
	
	assign n_in2[0] = n_o2[1]; assign n_vi2[0] = n_vo2[1]; assign n_ci2[1] = n_co2[0];
	assign n_in2[1] = n_o2[2]; assign n_vi2[1] = n_vo2[2]; assign n_ci2[2] = n_co2[1];
	assign n_in2[2] = n_o2[3]; assign n_vi2[2] = n_vo2[3]; assign n_ci2[3] = n_co2[2];
	assign n_in2[3] = n_o2[0]; assign n_vi2[3] = n_vo2[0]; assign n_ci2[0] = n_co2[3];

	wire [19:0] shub_dn_d [0:3]; wire shub_dn_v [0:3]; wire cluster_ci [0:3];
	wire [19:0] shub_up_d [0:3]; wire shub_up_v [0:3]; wire shub_up_co [0:3];

	assign shub_up_d[0] = n_o3[0]; assign shub_up_v[0] = n_vo3[0]; assign n_ci3[0] = shub_up_co[0];
	assign shub_up_d[1] = n_o3[1]; assign shub_up_v[1] = n_vo3[1]; assign n_ci3[1] = shub_up_co[1];
	assign shub_up_d[2] = n_o3[2]; assign shub_up_v[2] = n_vo3[2]; assign n_ci3[2] = shub_up_co[2];
	assign shub_up_d[3] = n_o3[3]; assign shub_up_v[3] = n_vo3[3]; assign n_ci3[3] = shub_up_co[3];

	assign n_in3[0] = shub_dn_d[0]; assign n_vi3[0] = shub_dn_v[0]; assign cluster_ci[0] = n_co3[0];
	assign n_in3[1] = shub_dn_d[1]; assign n_vi3[1] = shub_dn_v[1]; assign cluster_ci[1] = n_co3[1];
	assign n_in3[2] = shub_dn_d[2]; assign n_vi3[2] = shub_dn_v[2]; assign cluster_ci[2] = n_co3[2];
	assign n_in3[3] = shub_dn_d[3]; assign n_vi3[3] = shub_dn_v[3]; assign cluster_ci[3] = n_co3[3];

	wire [19:0] shub_ring_cw_in_d = 20'b0;
	wire shub_ring_cw_in_v = 1'b0;
	wire shub_ring_cw_ci;
	wire [19:0] shub_ring_ccw_in_d = 20'b0;
	wire shub_ring_ccw_in_v = 1'b0;
	wire shub_ring_ccw_ci;

	assign shub_ring_cw_ci = 1'b1;
	assign shub_ring_ccw_ci = 1'b1;
	
	wire [19:0] sh_dn_d = 20'b0; wire sh_dn_v = 1'b0; wire sh_dn_ci;
	wire [19:0] sh_up_d; 	     wire sh_up_v;	  wire sh_up_co;
	assign sh_up_co = 1'b1;

	SuperHubTile u_hub (
				.clk (clk), .rst (rst),
				.ring_cw_in   (shub_ring_cw_in_d),
				.ring_cw_vi   (shub_ring_cw_in_v),
				.ring_cw_out  (),
				.ring_cw_vo   (),
				.ring_cw_ci   (shub_ring_cw_ci),
				.ring_cw_co   (),
				.ring_ccw_in  (shub_ring_ccw_in_d),
				.ring_ccw_vi  (shub_ring_ccw_in_v),
				.ring_ccw_out (),
				.ring_ccw_vo  (),
				.ring_ccw_ci  (shub_ring_ccw_ci),
				.ring_ccw_co  (),

				.up_to_SSH_data (sh_up_d),
				.up_to_SSH_valid (sh_up_v),
				.up_to_SSH_ci (sh_up_co),
				
				.down_from_SSH_data (sh_dn_d),
				.down_from_SSH_valid (sh_dn_v),
				.down_from_SSH_co (sh_dn_ci),
	
				.down_to_cluster0_data (shub_dn_d[0]), .down_to_cluster0_valid (shub_dn_v[0]), .cluster0_ci (cluster_ci[0]),
				.down_to_cluster1_data (shub_dn_d[1]), .down_to_cluster1_valid (shub_dn_v[1]), .cluster1_ci (cluster_ci[1]),
				.down_to_cluster2_data (shub_dn_d[2]), .down_to_cluster2_valid (shub_dn_v[2]), .cluster2_ci (cluster_ci[2]),
	            .down_to_cluster3_data (shub_dn_d[3]), .down_to_cluster3_valid (shub_dn_v[3]), .cluster3_ci (cluster_ci[3]),

				.up_from_cluster0_data (shub_up_d[0]), .up_from_cluster0_valid (shub_up_v[0]), .up_from_cluster0_co (shub_up_co[0]),
    		    .up_from_cluster1_data (shub_up_d[1]), .up_from_cluster1_valid (shub_up_v[1]), .up_from_cluster1_co (shub_up_co[1]),
    			.up_from_cluster2_data (shub_up_d[2]), .up_from_cluster2_valid (shub_up_v[2]), .up_from_cluster2_co (shub_up_co[2]),
    			.up_from_cluster3_data (shub_up_d[3]), .up_from_cluster3_valid (shub_up_v[3]), .up_from_cluster3_co (shub_up_co[3]),

    			.my_cluster (2'b00)
  );

endmodule