module InputBuffer (
    input         clk,
    input         rst,
    input  [22:0] data,    // 22:7 is data, 6:3 is address, 2:0 is target
    input         valid,   // write request
    input         pop,     // pop request (1 = pop head)
    output [22:0] out      // FIFO head data
);
    // --------------------------------------------------------------------
    // Configuration: depth = 12 entries
    // --------------------------------------------------------------------
    localparam integer DEPTH = 14;

    // state = occupancy: 0 .. DEPTH
    reg [3:0] state, state_next;

    // fifo[11] is head, fifo[0] is tail
    reg [22:0] fifo      [0:DEPTH-1];
    reg [22:0] fifo_next [0:DEPTH-1];

    integer i;
    integer occ;

    // --------------------------------------------------------------------
    // Next-state and data-path logic
    // --------------------------------------------------------------------
    always @* begin
        // Default: hold
        state_next = state;
        for (i = 0; i < DEPTH; i = i + 1)
            fifo_next[i] = fifo[i];

        occ = state;  // current occupancy (0..DEPTH)

        // 1) Handle pop first (if any data present)
        if (pop && (occ > 0)) begin
            // shift all valid entries one step toward the head (index DEPTH-1)
            // valid entries currently in [DEPTH-1 .. DEPTH-occ]
            for (i = DEPTH-1; i > DEPTH-occ; i = i - 1)
                fifo_next[i] = fifo_next[i-1];

            // clear old tail slot
            fifo_next[DEPTH-occ] = 23'b0;

            occ = occ - 1;
        end

        // 2) Handle write (if there is room after any pop)
        if (valid && (occ < DEPTH)) begin
            // with occ entries, valid indices are [DEPTH-1 .. DEPTH-occ]
            // new tail index is DEPTH-(occ+1)
            fifo_next[DEPTH-(occ+1)] = data;
            occ = occ + 1;
        end

        // 3) Optional: mimic your "WRONG" behavior on pure overflow:
        //    if FIFO is already full (occ == DEPTH) and we see valid=1, pop=0,
        //    treat it as an error and clear.
        if (!pop && valid && (state == DEPTH)) begin
            occ = 0;
            for (i = 0; i < DEPTH; i = i + 1)
                fifo_next[i] = 23'b0;
        end

        state_next = occ[3:0];
    end

    // --------------------------------------------------------------------
    // Registers
    // --------------------------------------------------------------------
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= 0;
            for (i = 0; i < DEPTH; i = i + 1)
                fifo[i] <= 23'b0;
        end
        else begin
            state <= state_next;
            for (i = 0; i < DEPTH; i = i + 1)
                fifo[i] <= fifo_next[i];
        end
    end

    // Head of FIFO
    assign out = fifo[DEPTH-1];

endmodule
