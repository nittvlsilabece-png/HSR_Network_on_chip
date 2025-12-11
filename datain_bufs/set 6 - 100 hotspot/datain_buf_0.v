`timescale 1ns / 1ps

module datain_buf_0 (
    input         clk,
    input         rst,        // active-low
    input         in_valid,
    input  [19:0] datain,
    output        state,
    output [15:0] read
);

    // Match old depth
    localparam DEPTH = 128;
    localparam LAST  = DEPTH-1;

    reg  [19:0] mem [0:DEPTH-1];  // stored flits (for inspection only)
    reg  [6:0]  addr;
    reg         state_reg;

    assign state = state_reg;

    // *** NEW: read shows current incoming payload, not memory ***
    assign read  = datain[19:4];

    integer i;
    initial begin
        // not strictly necessary, but avoids Xs when probing mem[]
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 20'h00000;
        addr      = 7'd0;
        state_reg = 1'b0;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            addr      <= 7'd0;
            state_reg <= 1'b0;
        end else begin
            if (in_valid) begin
                // store incoming flit for later inspection
                mem[addr] <= datain;

                // simple "buffer full" flag when we wrap
                if (addr == LAST[6:0]) begin
                    addr      <= 7'd0;
                    state_reg <= 1'b1;
                end else begin
                    addr <= addr + 7'd1;
                end
            end
        end
    end

endmodule
