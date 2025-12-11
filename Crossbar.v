module Crossbar (
                input clk,
                input rst,
                input [22:0] in1, in2, in3, in4, in5,
                input [4:0] cb_ctrl,                    // cb_ctrl[0] ~ in1, and so on; when ctrl is 1, it can be gated
                output reg [19:0] o1, o2, o3, o4, o5,
                output reg v1, v2, v3, v4, v5           //The valid signal for each output port; 1 indicates active.
                );

    wire [2:0] targ1, targ2, targ3, targ4, targ5;

    assign {targ1, targ2, targ3, targ4, targ5}          // Targ = 1–5 valid, other values invalid
        = {in1[2:0], in2[2:0], in3[2:0], in4[2:0], in5[2:0]};

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o1, v1} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5})
                20'bzzzz1_001_zzz_zzz_zzz_zzz: {o1, v1} <= {in1[22:3], 1'b1};
                20'bzzz1z_zzz_001_zzz_zzz_zzz: {o1, v1} <= {in2[22:3], 1'b1};
                20'bzz1zz_zzz_zzz_001_zzz_zzz: {o1, v1} <= {in3[22:3], 1'b1};
                20'bz1zzz_zzz_zzz_zzz_001_zzz: {o1, v1} <= {in4[22:3], 1'b1};
                20'b1zzzz_zzz_zzz_zzz_zzz_001: {o1, v1} <= {in5[22:3], 1'b1};
                default: {o1, v1} <= {o1, 1'b0};
        endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o2, v2} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5})
                20'bzzzz1_010_zzz_zzz_zzz_zzz: {o2, v2} <= {in1[22:3], 1'b1};
                20'bzzz1z_zzz_010_zzz_zzz_zzz: {o2, v2} <= {in2[22:3], 1'b1};
                20'bzz1zz_zzz_zzz_010_zzz_zzz: {o2, v2} <= {in3[22:3], 1'b1};
                20'bz1zzz_zzz_zzz_zzz_010_zzz: {o2, v2} <= {in4[22:3], 1'b1};
                20'b1zzzz_zzz_zzz_zzz_zzz_010: {o2, v2} <= {in5[22:3], 1'b1};
                default: {o2, v2} <= {o2, 1'b0};
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o3, v3} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5})
                20'bzzzz1_011_zzz_zzz_zzz_zzz: {o3, v3} <= {in1[22:3], 1'b1};
                20'bzzz1z_zzz_011_zzz_zzz_zzz: {o3, v3} <= {in2[22:3], 1'b1};
                20'bzz1zz_zzz_zzz_011_zzz_zzz: {o3, v3} <= {in3[22:3], 1'b1};
                20'bz1zzz_zzz_zzz_zzz_011_zzz: {o3, v3} <= {in4[22:3], 1'b1};
                20'b1zzzz_zzz_zzz_zzz_zzz_011: {o3, v3} <= {in5[22:3], 1'b1};
                default: {o3, v3} <= {o3, 1'b0};
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o4, v4} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5})
                20'bzzzz1_100_zzz_zzz_zzz_zzz: {o4, v4} <= {in1[22:3], 1'b1};
                20'bzzz1z_zzz_100_zzz_zzz_zzz: {o4, v4} <= {in2[22:3], 1'b1};
                20'bzz1zz_zzz_zzz_100_zzz_zzz: {o4, v4} <= {in3[22:3], 1'b1};
                20'bz1zzz_zzz_zzz_zzz_100_zzz: {o4, v4} <= {in4[22:3], 1'b1};
                20'b1zzzz_zzz_zzz_zzz_zzz_100: {o4, v4} <= {in5[22:3], 1'b1};
                default : {o4, v4} <= {o4, 1'b0};
            endcase
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            {o5, v5} <= {20'b0, 1'b0};
        end
        else begin
            casez ({cb_ctrl, targ1, targ2, targ3, targ4, targ5})
                20'bzzzz1_101_zzz_zzz_zzz_zzz : {o5, v5} <= {in1[22:3], 1'b1};
                20'bzzz1z_zzz_101_zzz_zzz_zzz : {o5, v5} <= {in2[22:3], 1'b1};
                20'bzz1zz_zzz_zzz_101_zzz_zzz : {o5, v5} <= {in3[22:3], 1'b1};
                20'bz1zzz_zzz_zzz_zzz_101_zzz : {o5, v5} <= {in4[22:3], 1'b1};
                20'b1zzzz_zzz_zzz_zzz_zzz_101 : {o5, v5} <= {in5[22:3], 1'b1};
                default : {o5, v5} <= {o5, 1'b0};
            endcase
        end
    end

endmodule