module InputBuffer (
    input   clk,
    input   rst,
    input   [22:0] data,            // 22:7 is data, 6:3 is address, 2:0 is target
    input   valid,                  // indicates whether the data signal be written to the buffer
    input   pop,                    // indicates whether the FIFO head data be popped. 1 means pop.
    output  [22:0] out              // FIFO header data
    );

    reg [4:0] state, next_state;    // Valid range is 0 to 16, representing valid data in the FIFO.
    localparam WRONG = 5'd0;

    always @(posedge clk or negedge rst) begin
        if (!rst)
            state <= 0;
        else
            state <= next_state;
    end

    // valid & pop   -> no-change (item given and taken instantly)
    // valid & !pop  -> +1
    // !valid & pop  -> -1
    // !valid & !pop -> no-change
    always @(*) begin
        case (state)
            0:
                next_state = valid ? (pop ? 0 : 1) : (pop ? WRONG : 0);
            1:
                next_state = valid ? (pop ? 1 : 2) : (pop ? 0 : 1);
            2:
                next_state = valid ? (pop ? 2 : 3) : (pop ? 1 : 2);
            3:
                next_state = valid ? (pop ? 3 : 4) : (pop ? 2 : 3);
            4:
                next_state = valid ? (pop ? 4 : 5) : (pop ? 3 : 4);
            5:
                next_state = valid ? (pop ? 5 : 6) : (pop ? 4 : 5);
            6:
                next_state = valid ? (pop ? 6 : 7) : (pop ? 5 : 6);
            7:
                next_state = valid ? (pop ? 7 : 8) : (pop ? 6 : 7);
            8:
                next_state = valid ? (pop ? 8 : 9) : (pop ? 7 : 8);
            9:
                next_state = valid ? (pop ? 9 : 10) : (pop ? 8 : 9);
            10:
                next_state = valid ? (pop ? 10 : 11) : (pop ? 9 : 10);
            11:
                next_state = valid ? (pop ? 11 : 12) : (pop ? 10 : 11);
            12:
                next_state = valid ? (pop ? 12 : 13) : (pop ? 11 : 12);
            13:
                next_state = valid ? (pop ? 13 : 14) : (pop ? 12 : 13);
            14:
                next_state = valid ? (pop ? 14 : 15) : (pop ? 13 : 14);
            15:
                next_state = valid ? (pop ? 15 : 16) : (pop ? 14 : 15);
            16:
                next_state = valid ? (pop ? 16 : WRONG) : (pop ? 15 : 16);
            default:
                next_state = 0;
        endcase
    end

    reg [22:0] fifo [15:0];          // FIFO[15] is the head (data output)

    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                {23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
        end
        else begin
            if (pop) begin
                if (valid) begin    // pop and write
                    case (state)
                        0:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        1:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        2:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        3:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        4:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], data, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        5:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], data, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        6:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], data, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        7:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], data, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        8:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], data,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        9:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        10:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        11:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        12:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], data, 23'b0, 23'b0, 23'b0, 23'b0};
                        13:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], data, 23'b0, 23'b0, 23'b0};
                        14:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], data, 23'b0, 23'b0};
                        15:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], data, 23'b0};
                        16:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0], data};
                        default:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                    endcase
                end
                else begin          // pop without writing
                    case (state)
                        2:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        3:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        4:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        5:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        6:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        7:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        8:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        9:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        10:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        11:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        12:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        13:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], 23'b0, 23'b0, 23'b0, 23'b0};
                        14:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], 23'b0, 23'b0, 23'b0};
                        15:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], 23'b0, 23'b0};
                        16:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7],
                                 fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0], 23'b0};
                        default:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                    endcase
                end
            end
            else begin
                if (valid) begin    // Does not pop but writes
                    case (state)
                        0:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        1:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        2:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        3:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], data, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        4:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], data, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        5:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], data, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        6:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], data, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        7:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], data,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        8:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        9:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 fifo[7], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        10:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 fifo[7], fifo[6], data, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        11:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 fifo[7], fifo[6], fifo[5], data, 23'b0, 23'b0, 23'b0, 23'b0};
                        12:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 fifo[7], fifo[6], fifo[5], fifo[4], data, 23'b0, 23'b0, 23'b0};
                        13:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], data, 23'b0, 23'b0};
                        14:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], data, 23'b0};
                        15:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                                 fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], data};
                        16:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                        default:
                            {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                             fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                                {23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0,
                                 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
                    endcase
                end
                else begin        // Neither pop nor write
                    {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                     fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <=
                        {fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8],
                         fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]};
                end
            end
        end
    end

    assign out = fifo[15];

endmodule
