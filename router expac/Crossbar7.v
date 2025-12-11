module Crossbar7 (
                input clk,
                input rst,
                input [22:0] in1, in2, in3, in4, in5, in6, in7,
                input [6:0] cb_ctrl,                    // cb_ctrl[0] ~ in1, and so on; when ctrl is 1, it can be gated
                output reg [19:0] o1, o2, o3, o4, o5, o6, o7,
                output reg v1, v2, v3, v4, v5, v6, v7           //The valid signal for each output port; 1 indicates active.
                );

    wire [2:0] targ1, targ2, targ3, targ4, targ5, targ6, targ7;

    assign {targ1, targ2, targ3, targ4, targ5, targ6, targ7}          // Targ = 1–5 valid, other values invalid
        = {in1[2:0], in2[2:0], in3[2:0], in4[2:0], in5[2:0], in6[2:0], in7[2:0]};

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o1, v1} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5, targ6, targ7})
                28'bzzzzzz1_001_zzz_zzz_zzz_zzz_zzz_zzz: {o1, v1} <= {in1[22:3], 1'b1};
                28'bzzzzz1z_zzz_001_zzz_zzz_zzz_zzz_zzz: {o1, v1} <= {in2[22:3], 1'b1};
                28'bzzzz1zz_zzz_zzz_001_zzz_zzz_zzz_zzz: {o1, v1} <= {in3[22:3], 1'b1};
                28'bzzz1zzz_zzz_zzz_zzz_001_zzz_zzz_zzz: {o1, v1} <= {in4[22:3], 1'b1};
                28'bzz1zzzz_zzz_zzz_zzz_zzz_001_zzz_zzz: {o1, v1} <= {in5[22:3], 1'b1};
                28'bz1zzzzz_zzz_zzz_zzz_zzz_zzz_001_zzz: {o1, v1} <= {in6[22:3], 1'b1};
                28'b1zzzzzz_zzz_zzz_zzz_zzz_zzz_zzz_001: {o1, v1} <= {in7[22:3], 1'b1};
                default: {o1, v1} <= {o1, 1'b0};
        endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o2, v2} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5, targ6, targ7})
                28'bzzzzzz1_010_zzz_zzz_zzz_zzz_zzz_zzz: {o2, v2} <= {in1[22:3], 1'b1};
                28'bzzzzz1z_zzz_010_zzz_zzz_zzz_zzz_zzz: {o2, v2} <= {in2[22:3], 1'b1};
                28'bzzzz1zz_zzz_zzz_010_zzz_zzz_zzz_zzz: {o2, v2} <= {in3[22:3], 1'b1};
                28'bzzz1zzz_zzz_zzz_zzz_010_zzz_zzz_zzz: {o2, v2} <= {in4[22:3], 1'b1};
                28'bzz1zzzz_zzz_zzz_zzz_zzz_010_zzz_zzz: {o2, v2} <= {in5[22:3], 1'b1};
                28'bz1zzzzz_zzz_zzz_zzz_zzz_zzz_010_zzz: {o2, v2} <= {in6[22:3], 1'b1};
                28'b1zzzzzz_zzz_zzz_zzz_zzz_zzz_zzz_010: {o2, v2} <= {in7[22:3], 1'b1};
                default: {o2, v2} <= {o2, 1'b0};
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o3, v3} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5, targ6, targ7})
                28'bzzzzzz1_011_zzz_zzz_zzz_zzz_zzz_zzz: {o3, v3} <= {in1[22:3], 1'b1};
                28'bzzzzz1z_zzz_011_zzz_zzz_zzz_zzz_zzz: {o3, v3} <= {in2[22:3], 1'b1};
                28'bzzzz1zz_zzz_zzz_011_zzz_zzz_zzz_zzz: {o3, v3} <= {in3[22:3], 1'b1};
                28'bzzz1zzz_zzz_zzz_zzz_011_zzz_zzz_zzz: {o3, v3} <= {in4[22:3], 1'b1};
                28'bzz1zzzz_zzz_zzz_zzz_zzz_011_zzz_zzz: {o3, v3} <= {in5[22:3], 1'b1};
                28'bz1zzzzz_zzz_zzz_zzz_zzz_zzz_011_zzz: {o3, v3} <= {in6[22:3], 1'b1};
                28'b1zzzzzz_zzz_zzz_zzz_zzz_zzz_zzz_011: {o3, v3} <= {in7[22:3], 1'b1};
                default: {o3, v3} <= {o3, 1'b0};
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o4, v4} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5, targ6, targ7})
                28'bzzzzzz1_100_zzz_zzz_zzz_zzz_zzz_zzz: {o4, v4} <= {in1[22:3], 1'b1};
                28'bzzzzz1z_zzz_100_zzz_zzz_zzz_zzz_zzz: {o4, v4} <= {in2[22:3], 1'b1};
                28'bzzzz1zz_zzz_zzz_100_zzz_zzz_zzz_zzz: {o4, v4} <= {in3[22:3], 1'b1};
                28'bzzz1zzz_zzz_zzz_zzz_100_zzz_zzz_zzz: {o4, v4} <= {in4[22:3], 1'b1};
                28'bzz1zzzz_zzz_zzz_zzz_zzz_100_zzz_zzz: {o4, v4} <= {in5[22:3], 1'b1};
                28'bz1zzzzz_zzz_zzz_zzz_zzz_zzz_100_zzz: {o4, v4} <= {in6[22:3], 1'b1};
                28'b1zzzzzz_zzz_zzz_zzz_zzz_zzz_zzz_100: {o4, v4} <= {in7[22:3], 1'b1};
                default : {o4, v4} <= {o4, 1'b0};
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o5, v5} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5, targ6, targ7})
                28'bzzzzzz1_101_zzz_zzz_zzz_zzz_zzz_zzz : {o5, v5} <= {in1[22:3], 1'b1};
                28'bzzzzz1z_zzz_101_zzz_zzz_zzz_zzz_zzz : {o5, v5} <= {in2[22:3], 1'b1};
                28'bzzzz1zz_zzz_zzz_101_zzz_zzz_zzz_zzz : {o5, v5} <= {in3[22:3], 1'b1};
                28'bzzz1zzz_zzz_zzz_zzz_101_zzz_zzz_zzz : {o5, v5} <= {in4[22:3], 1'b1};
                28'bzz1zzzz_zzz_zzz_zzz_zzz_101_zzz_zzz : {o5, v5} <= {in5[22:3], 1'b1};
                28'bz1zzzzz_zzz_zzz_zzz_zzz_zzz_101_zzz : {o5, v5} <= {in6[22:3], 1'b1};
                28'b1zzzzzz_zzz_zzz_zzz_zzz_zzz_zzz_101:  {o5, v5} <= {in7[22:3], 1'b1};
                default : {o5, v5} <= {o5, 1'b0};
            endcase
        end
    end

always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o6, v6} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5, targ6, targ7})
                28'bzzzzzz1_110_zzz_zzz_zzz_zzz_zzz_zzz : {o6, v6} <= {in1[22:3], 1'b1};
                28'bzzzzz1z_zzz_110_zzz_zzz_zzz_zzz_zzz : {o6, v6} <= {in2[22:3], 1'b1};
                28'bzzzz1zz_zzz_zzz_110_zzz_zzz_zzz_zzz : {o6, v6} <= {in3[22:3], 1'b1};
                28'bzzz1zzz_zzz_zzz_zzz_110_zzz_zzz_zzz : {o6, v6} <= {in4[22:3], 1'b1};
                28'bzz1zzzz_zzz_zzz_zzz_zzz_110_zzz_zzz : {o6, v6} <= {in5[22:3], 1'b1};
                28'bz1zzzzz_zzz_zzz_zzz_zzz_zzz_110_zzz : {o6, v6} <= {in6[22:3], 1'b1};
                28'b1zzzzzz_zzz_zzz_zzz_zzz_zzz_zzz_110:  {o6, v6} <= {in7[22:3], 1'b1};
                default : {o6, v6} <= {o6, 1'b0};
            endcase
        end
    end


always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o7, v7} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5, targ6, targ7})
                28'bzzzzzz1_111_zzz_zzz_zzz_zzz_zzz_zzz : {o7, v7} <= {in1[22:3], 1'b1};
                28'bzzzzz1z_zzz_111_zzz_zzz_zzz_zzz_zzz : {o7, v7} <= {in2[22:3], 1'b1};
                28'bzzzz1zz_zzz_zzz_111_zzz_zzz_zzz_zzz : {o7, v7} <= {in3[22:3], 1'b1};
                28'bzzz1zzz_zzz_zzz_zzz_111_zzz_zzz_zzz : {o7, v7} <= {in4[22:3], 1'b1};
                28'bzz1zzzz_zzz_zzz_zzz_zzz_111_zzz_zzz : {o7, v7} <= {in5[22:3], 1'b1};
                28'bz1zzzzz_zzz_zzz_zzz_zzz_zzz_111_zzz : {o7, v7} <= {in6[22:3], 1'b1};
                28'b1zzzzzz_zzz_zzz_zzz_zzz_zzz_zzz_111:  {o7, v7} <= {in7[22:3], 1'b1};
                default : {o7, v7} <= {o7, 1'b0};
            endcase
        end
    end

endmodule