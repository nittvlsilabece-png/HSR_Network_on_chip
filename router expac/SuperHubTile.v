module SuperHubTile (
    input clk,
    input rst,

    // Ring side
    input  [19:0] ring_cw_in,
    input         ring_cw_vi,
    output [19:0] ring_cw_out,
    output        ring_cw_vo,
    input         ring_cw_ci,
    output        ring_cw_co,

    input  [19:0] ring_ccw_in,
    input         ring_ccw_vi,
    output [19:0] ring_ccw_out,
    output        ring_ccw_vo,
    input         ring_ccw_ci,
    output        ring_ccw_co,

    // Vertical link up
    output [19:0] up_to_SSH_data,
    output        up_to_SSH_valid,
    input         up_to_SSH_ci,
    // Vertical link down
    input  [19:0] down_from_SSH_data,
    input         down_from_SSH_valid,
    output        down_from_SSH_co,

    // Clusters downwards
    output [19:0] down_to_cluster0_data,
    output        down_to_cluster0_valid,
    input         cluster0_ci,
    output [19:0] down_to_cluster1_data,
    output        down_to_cluster1_valid,
    input         cluster1_ci,
    output [19:0] down_to_cluster2_data,
    output        down_to_cluster2_valid,
    input         cluster2_ci,
    output [19:0] down_to_cluster3_data,
    output        down_to_cluster3_valid,
    input         cluster3_ci,

    // Clusters upwards
    input  [19:0] up_from_cluster0_data,
    input         up_from_cluster0_valid,
    output        up_from_cluster0_co,
    input  [19:0] up_from_cluster1_data,
    input         up_from_cluster1_valid,
    output        up_from_cluster1_co,
    input  [19:0] up_from_cluster2_data,
    input         up_from_cluster2_valid,
    output        up_from_cluster2_co,
    input  [19:0] up_from_cluster3_data,
    input         up_from_cluster3_valid,
    output        up_from_cluster3_co,

    input  [1:0] my_cluster
);

    wire [19:0] router_o1, router_o2, router_o3, router_o4, router_o5, router_o6, router_o7;
    wire        router_vo1, router_vo2, router_vo3, router_vo4, router_vo5, router_vo6, router_vo7;
    wire        router_co1, router_co2, router_co3, router_co4, router_co5, router_co6, router_co7;

    Router7 router (
        .clk (clk),
        .rst (rst),

        // 1: CW ring
        .in1 (ring_cw_in),
        .vi1 (ring_cw_vi),
        .ci1 (ring_cw_ci),

        // 2: CCW ring
        .in2 (ring_ccw_in),
        .vi2 (ring_ccw_vi),
        .ci2 (ring_ccw_ci),

        // 3: vertical link
        .in3 (down_from_SSH_data),
        .vi3 (down_from_SSH_valid),
        .ci3 (up_to_SSH_ci),

        // 4–7: clusters
        .in4 (up_from_cluster0_data),
        .vi4 (up_from_cluster0_valid),
        .ci4 (cluster0_ci),

        .in5 (up_from_cluster1_data),
        .vi5 (up_from_cluster1_valid),
        .ci5 (cluster1_ci),

        .in6 (up_from_cluster2_data),
        .vi6 (up_from_cluster2_valid),
        .ci6 (cluster2_ci),

        .in7 (up_from_cluster3_data),
        .vi7 (up_from_cluster3_valid),
        .ci7 (cluster3_ci),

        .o1 (router_o1), .vo1 (router_vo1), .co1 (ring_cw_co),
        .o2 (router_o2), .vo2 (router_vo2), .co2 (ring_ccw_co),
        .o3 (router_o3), .vo3 (router_vo3), .co3 (down_from_SSH_co),
        .o4 (router_o4), .vo4 (router_vo4), .co4 (up_from_cluster0_co),
        .o5 (router_o5), .vo5 (router_vo5), .co5 (up_from_cluster1_co),
        .o6 (router_o6), .vo6 (router_vo6), .co6 (up_from_cluster2_co),
        .o7 (router_o7), .vo7 (router_vo7), .co7 (up_from_cluster3_co),

        .my_cluster  (my_cluster),
        .my_local    (2'd0),
        .is_hub      (1'b1),
        .is_superhub (1'b1)
    );

    // Ring outputs
    assign ring_cw_out  = router_o1;
    assign ring_cw_vo   = router_vo1;

    assign ring_ccw_out = router_o2;
    assign ring_ccw_vo  = router_vo2;

    // Upwards to system-level SH
    assign up_to_SSH_data  = router_o3;
    assign up_to_SSH_valid = router_vo3;

    // Downwards to clusters
    assign down_to_cluster0_data  = router_o4;
    assign down_to_cluster0_valid = router_vo4;

    assign down_to_cluster1_data  = router_o5;
    assign down_to_cluster1_valid = router_vo5;

    assign down_to_cluster2_data  = router_o6;
    assign down_to_cluster2_valid = router_vo6;

    assign down_to_cluster3_data  = router_o7;
    assign down_to_cluster3_valid = router_vo7;

endmodule
