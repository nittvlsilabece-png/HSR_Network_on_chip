`timescale 1ns / 1ps

module dataout_buf_2 (
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
        mem[0]  = 20'h02010; // payload=0x0201, dest_local=0
        mem[1]  = 20'h02020; // payload=0x0202, dest_local=1
        mem[2]  = 20'h02030; // payload=0x0203, dest_local=2
        mem[3]  = 20'h02040; // payload=0x0204, dest_local=3
        mem[4]  = 20'h02050; // payload=0x0205, dest_local=0
        mem[5]  = 20'h02060; // payload=0x0206, dest_local=1
        mem[6]  = 20'h02070; // payload=0x0207, dest_local=2
        mem[7]  = 20'h02080; // payload=0x0208, dest_local=3
        mem[8]  = 20'h02090; // payload=0x0209, dest_local=0
        mem[9]  = 20'h020A0; // payload=0x020A, dest_local=1
        mem[10] = 20'h020B0; // payload=0x020B, dest_local=2
        mem[11] = 20'h020C0; // payload=0x020C, dest_local=3
        mem[12] = 20'h020D0; // payload=0x020D, dest_local=0
        mem[13] = 20'h020E0; // payload=0x020E, dest_local=1
        mem[14] = 20'h020F0; // payload=0x020F, dest_local=2
        mem[15] = 20'h02100; // payload=0x0210, dest_local=3
        mem[16] = 20'h02110; // payload=0x0211, dest_local=0
        mem[17] = 20'h02120; // payload=0x0212, dest_local=1
        mem[18] = 20'h02130; // payload=0x0213, dest_local=2
        mem[19] = 20'h02140; // payload=0x0214, dest_local=3
        mem[20] = 20'h02150; // payload=0x0215, dest_local=0
        mem[21] = 20'h02160; // payload=0x0216, dest_local=1
        mem[22] = 20'h02170; // payload=0x0217, dest_local=2
        mem[23] = 20'h02180; // payload=0x0218, dest_local=3
        mem[24] = 20'h02190; // payload=0x0219, dest_local=0
        mem[25] = 20'h021A0; // payload=0x021A, dest_local=1
        mem[26] = 20'h021B0; // payload=0x021B, dest_local=2
        mem[27] = 20'h021C0; // payload=0x021C, dest_local=3
        mem[28] = 20'h021D0; // payload=0x021D, dest_local=0
        mem[29] = 20'h021E0; // payload=0x021E, dest_local=1
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
