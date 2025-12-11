`timescale 1ns / 1ps

module dataout_buf_10 (
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
    // dataout_buf_10  (node 10: cluster 2, local 2)
    mem[0]  = 20'h0A000;  // src 10 -> dest 0
    mem[1]  = 20'h0A011;  // src 10 -> dest 1
    mem[2]  = 20'h0A022;  // src 10 -> dest 2
    mem[3]  = 20'h0A033;  // src 10 -> dest 3
    mem[4]  = 20'h0A044;  // src 10 -> dest 4
    mem[5]  = 20'h0A055;  // src 10 -> dest 5
    mem[6]  = 20'h0A066;  // src 10 -> dest 6
    mem[7]  = 20'h0A077;  // src 10 -> dest 7
    mem[8]  = 20'h0A088;  // src 10 -> dest 8
    mem[9]  = 20'h0A099;  // src 10 -> dest 9
    mem[10] = 20'h0A0BB;  // src 10 -> dest 11
    mem[11] = 20'h0A0CC;  // src 10 -> dest 12
    mem[12] = 20'h0A0DD;  // src 10 -> dest 13
    mem[13] = 20'h0A0EE;  // src 10 -> dest 14
    mem[14] = 20'h0A0FF;  // src 10 -> dest 15
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
