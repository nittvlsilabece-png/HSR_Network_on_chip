`timescale 1ns / 1ps

module dataout_buf_1 (
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
        mem[0]  = 20'h01010; // payload=0x0001, dest_cluster=0, dest_local=0
        mem[1]  = 20'h01020; // payload=0x0002, dest_cluster=0, dest_local=0
        mem[2]  = 20'h01030; // payload=0x0003, dest_cluster=0, dest_local=0
        mem[3]  = 20'h01040; // payload=0x0004, dest_cluster=0, dest_local=0
        mem[4]  = 20'h01050; // payload=0x0005, dest_cluster=0, dest_local=0
        mem[5]  = 20'h01060; // payload=0x0006, dest_cluster=0, dest_local=0
        mem[6]  = 20'h01070; // payload=0x0007, dest_cluster=0, dest_local=0
        mem[7]  = 20'h01080; // payload=0x0008, dest_cluster=0, dest_local=0
        mem[8]  = 20'h01090; // payload=0x0009, dest_cluster=0, dest_local=0
        mem[9]  = 20'h010A0; // payload=0x000A, dest_cluster=0, dest_local=0
        mem[10] = 20'h010B0; // payload=0x000B, dest_cluster=0, dest_local=0
        mem[11] = 20'h010C0; // payload=0x000C, dest_cluster=0, dest_local=0
        mem[12] = 20'h010D0; // payload=0x000D, dest_cluster=0, dest_local=0
        mem[13] = 20'h010E0; // payload=0x000E, dest_cluster=0, dest_local=0
        mem[14] = 20'h010F0; // payload=0x000F, dest_cluster=0, dest_local=0
        mem[15] = 20'h01100; // payload=0x0010 (16), dest_cluster=0, dest_local=0
        mem[16] = 20'h01110; // payload=0x0011 (17), dest_cluster=0, dest_local=0
        mem[17] = 20'h01120; // payload=0x0012 (18), dest_cluster=0, dest_local=0
        mem[18] = 20'h01130; // payload=0x0013 (19), dest_cluster=0, dest_local=0
        mem[19] = 20'h01140; // payload=0x0014 (20), dest_cluster=0, dest_local=0
        mem[20] = 20'h01150; // payload=0x0015 (21), dest_cluster=0, dest_local=0
        mem[21] = 20'h01160; // payload=0x0016 (22), dest_cluster=0, dest_local=0
        mem[22] = 20'h01170; // payload=0x0017 (23), dest_cluster=0, dest_local=0
        mem[23] = 20'h01180; // payload=0x0018 (24), dest_cluster=0, dest_local=0
        mem[24] = 20'h01190; // payload=0x0019 (25), dest_cluster=0, dest_local=0
        mem[25] = 20'h011A0; // payload=0x001A (26), dest_cluster=0, dest_local=0
        mem[26] = 20'h011B0; // payload=0x001B (27), dest_cluster=0, dest_local=0
        mem[27] = 20'h011C0; // payload=0x001C (28), dest_cluster=0, dest_local=0
        mem[28] = 20'h011D0; // payload=0x001D (29), dest_cluster=0, dest_local=0
        mem[29] = 20'h011E0; // payload=0x001E (30), dest_cluster=0, dest_local=0
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
