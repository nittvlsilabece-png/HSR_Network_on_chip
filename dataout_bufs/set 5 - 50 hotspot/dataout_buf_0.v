`timescale 1ns / 1ps

module dataout_buf_0 (
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
	mem[0]  = 20'h00010;
        mem[1]  = 20'h00020; // payload=0x0102, dest_cluster=0, dest_local=1
        mem[2]  = 20'h00030; // payload=0x0103, dest_cluster=0, dest_local=1
        mem[3]  = 20'h00040; // payload=0x0104, dest_cluster=0, dest_local=1
        mem[4]  = 20'h00050; // payload=0x0105, dest_cluster=0, dest_local=1
        mem[5]  = 20'h00060; // payload=0x0106, dest_cluster=0, dest_local=1
        mem[6]  = 20'h00070; // payload=0x0107, dest_cluster=0, dest_local=1
        mem[7]  = 20'h00080; // payload=0x0108, dest_cluster=0, dest_local=1
        mem[8]  = 20'h00090; // payload=0x0109, dest_cluster=0, dest_local=1
        mem[9]  = 20'h000A0; // payload=0x010A, dest_cluster=0, dest_local=1
        mem[10] = 20'h000B0; // payload=0x010B, dest_cluster=0, dest_local=1
        mem[11] = 20'h000C0; // payload=0x010C, dest_cluster=0, dest_local=1
        mem[12] = 20'h000D0; // payload=0x010D, dest_cluster=0, dest_local=1
        mem[13] = 20'h000E0; // payload=0x010E, dest_cluster=0, dest_local=1
        mem[14] = 20'h000F0; // payload=0x010F, dest_cluster=0, dest_local=1
        mem[15] = 20'h00101; // payload=0x0110 (16), dest_cluster=0, dest_local=1
        mem[16] = 20'h00111; // payload=0x0111 (17), dest_cluster=0, dest_local=1
        mem[17] = 20'h00121; // payload=0x0112 (18), dest_cluster=0, dest_local=1
        mem[18] = 20'h00131; // payload=0x0113 (19), dest_cluster=0, dest_local=1
        mem[19] = 20'h00141; // payload=0x0114 (20), dest_cluster=0, dest_local=1
        mem[20] = 20'h00152; // payload=0x0115 (21), dest_cluster=0, dest_local=1
        mem[21] = 20'h00162; // payload=0x0116 (22), dest_cluster=0, dest_local=1
        mem[22] = 20'h00172; // payload=0x0117 (23), dest_cluster=0, dest_local=1
        mem[23] = 20'h00182; // payload=0x0118 (24), dest_cluster=0, dest_local=1
        mem[24] = 20'h00192; // payload=0x0119 (25), dest_cluster=0, dest_local=1
        mem[25] = 20'h001A3; // payload=0x011A (26), dest_cluster=0, dest_local=1
        mem[26] = 20'h001B3; // payload=0x011B (27), dest_cluster=0, dest_local=1
        mem[27] = 20'h001C3; // payload=0x011C (28), dest_cluster=0, dest_local=1
        mem[28] = 20'h001D3; // payload=0x011D (29), dest_cluster=0, dest_local=1
        mem[29] = 20'h001E3; // payload=0x011E (30), dest_cluster=0, dest_local=1
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
