`timescale 1ns / 1ps

module datain_buf (
    input         clk,
    input         rst,      // active-low
    input         in_valid,
    input  [19:0] datain,
    output [15:0] read
);

    localparam DEPTH = 40;
    localparam LAST  = DEPTH-1;

    reg  [5:0]  addr;
    reg  [19:0] mem [0:DEPTH-1];
   
    integer i;
    initial begin
        // not strictly necessary, but avoids Xs when probing mem[]
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 20'h00000;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            addr <= 6'd0;
        end else begin
            if (in_valid) begin
                mem[addr] <= datain;
                if (addr == LAST[5:0])
                    addr <= 6'd0;
                else
                    addr <= addr + 6'd1;
            end
        end
    end

    assign read = datain[19:4];

endmodule
