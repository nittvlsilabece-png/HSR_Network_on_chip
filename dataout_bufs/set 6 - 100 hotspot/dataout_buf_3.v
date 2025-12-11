`timescale 1ns / 1ps

module dataout_buf_3 (
    input         clk,
    input         rst,       // active-low
    input         enable,
    output [19:0] dataout,
    output reg    out_valid
);

    localparam DEPTH = 30;
    localparam LAST  = DEPTH-1;

    reg  [19:0] mem [0:DEPTH-1];
    reg  [4:0]  addr;
    reg         active;
    reg         done;
    reg  [19:0] dataout_reg;

    // ------------------------------------------------------------------------
    // ROM initialization
    // ------------------------------------------------------------------------
    // You can put your injection pattern here. Example:
    //   - create a file "dataout_buf_0.mem" with one 20-bit hex word per line,
    //   - add it to the project, and Vivado will use it for both sim + synth.
    //
    // Example file entries (20-bit hex):
    // 00000
    // 01011
    // 02022
    // ...
    //
    initial begin : blk
        integer i;
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 20'h00000;
        mem[0]  = 20'h03010; // payload=0x0301, dest_local=0
        mem[1]  = 20'h03020; // payload=0x0302, dest_local=1
        mem[2]  = 20'h03030; // payload=0x0303, dest_local=2
        mem[3]  = 20'h03040; // payload=0x0304, dest_local=3
        mem[4]  = 20'h03050; // payload=0x0305, dest_local=0
        mem[5]  = 20'h03060; // payload=0x0306, dest_local=1
        mem[6]  = 20'h03070; // payload=0x0307, dest_local=2
        mem[7]  = 20'h03080; // payload=0x0308, dest_local=3
        mem[8]  = 20'h03090; // payload=0x0309, dest_local=0
        mem[9]  = 20'h030A0; // payload=0x030A, dest_local=1
        mem[10] = 20'h030B0; // payload=0x030B, dest_local=2
        mem[11] = 20'h030C0; // payload=0x030C, dest_local=3
        mem[12] = 20'h030D0; // payload=0x030D, dest_local=0
        mem[13] = 20'h030E0; // payload=0x030E, dest_local=1
        mem[14] = 20'h030F0; // payload=0x030F, dest_local=2
        mem[15] = 20'h03100; // payload=0x0310, dest_local=3
        mem[16] = 20'h03110; // payload=0x0311, dest_local=0
        mem[17] = 20'h03120; // payload=0x0312, dest_local=1
        mem[18] = 20'h03130; // payload=0x0313, dest_local=2
        mem[19] = 20'h03140; // payload=0x0314, dest_local=3
        mem[20] = 20'h03150; // payload=0x0315, dest_local=0
        mem[21] = 20'h03160; // payload=0x0316, dest_local=1
        mem[22] = 20'h03170; // payload=0x0317, dest_local=2
        mem[23] = 20'h03180; // payload=0x0318, dest_local=3
        mem[24] = 20'h03190; // payload=0x0319, dest_local=0
        mem[25] = 20'h031A0; // payload=0x031A, dest_local=1
        mem[26] = 20'h031B0; // payload=0x031B, dest_local=2
        mem[27] = 20'h031C0; // payload=0x031C, dest_local=3
        mem[28] = 20'h031D0; // payload=0x031D, dest_local=0
        mem[29] = 20'h031E0; // payload=0x031E, dest_local=1
end

    // ------------------------------------------------------------------------
    // Control + streaming logic
    // ------------------------------------------------------------------------
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            addr        <= 5'd0;
            active      <= 1'b0;
            done        <= 1'b0;
            dataout_reg <= 20'h00000;
            out_valid   <= 1'b0;
        end else begin
            // By default, no valid unless we explicitly set it
            out_valid <= 1'b0;

            if (!done) begin
                // Start a new burst when enable goes high and we're idle
                if (enable && !active) begin
                    active <= 1'b1;
                    addr   <= 5'd0;
                end

                if (enable && active) begin
                    // Drive current word
                    dataout_reg <= mem[addr];
                    out_valid   <= 1'b1;

                    // Advance address / finish after last word
                    if (addr == LAST[4:0]) begin
                        active <= 1'b0;
                        done   <= 1'b1;
                    end else begin
                        addr <= addr + 5'd1;
                    end
                end
            end
            // If done == 1, we stay idle and out_valid stays 0
        end
    end

    assign dataout = dataout_reg;

endmodule
