// Packing a two-dimensional array into a one-dimensional array
`define PACK_ARRAY(PK_WIDTH, PK_LEN, PK_SRC, PK_DEST) \
        generate \
        genvar pk_idx; \
        for (pk_idx = 0; pk_idx  < (PK_LEN); pk_idx = pk_idx + 1) \
        begin \
                assign PK_DEST[((PK_WIDTH)*pk_idx + ((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; \
        end \
        endgenerate

// Expand a one-dimensional array into a two-dimensional array
`define UNPACK_ARRAY(PK_WIDTH, PK_LEN, PK_DEST, PK_SRC) \
        generate \
        genvar unpk_idx; \
        for (unpk_idx = 0; unpk_idx < (PK_LEN); unpk_idx = unpk_idx + 1) \
        begin \
            assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx + (PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; \
        end \
        endgenerate

module SwitchAlloc7 (
                    input clk,
                    input rst,
                    input [20:0] targ_pack,                             // 3 target bits for 7 inputs (3 * 7)
                    input [6:0]  pop_ctrl,                              // No need for UNPACK; pop_ctrl[0] is equivalent to pop[0]
                    output [2:0] to1, to2, to3, to4, to5, to6, to7      // Propagation direction for each input; 0 indicates no propagation
                    );

    wire [2:0] ti [6:0];                                    // temp wire for unpacking targ_pack

    `UNPACK_ARRAY(3,7,ti,targ_pack)                         // targ_pack[2:0] corresponds to ti[0]

    reg [2:0] count [6:0];                                  // Records which input each output buffer receives; 0 indicates no input is received

    integer i;                                              // counter to implement an aging / round robin like arbiter with priorities from 1 to 7 (resets on a pop)
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 7; i = i + 1)
                count[i] <= 1;
        end
        else begin
            for (i = 0; i < 7; i = i + 1) begin
                if(pop_ctrl[i])
                    count[i] <= 1;
                else if(count[i] == 7)                  // aging counter till 7 (arbitary) implying 7 -> max priority
                    count[i] <= count[i];
                else
                    count[i] <= count[i] + 1;
            end
        end
    end

    reg [2:0] prio [6:0][6:0];      // The first index is out, the second index is in
    integer j;
    always @(*) begin
        for (i = 0; i < 7; i = i + 1) begin
            for (j = 0; j < 7; j = j + 1) begin
                prio[i][j] = (ti[j] == (i+1)) ? pop_ctrl[j] ? 1 : count[j] : 0; // if (ti[input] is required) -> check if popping in this cycle then assign low priority else assign age count priority.
            end
        end
    end

    reg [2:0] to [6:0];
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 7; i = i + 1) begin
                to[i] <= 0;
            end
        end
        else begin
            case (ti[0])        // Note: target remains 1–7
                1:
                    to[0] <= (prio[0][0] >= prio[0][1] && prio[0][0] >= prio[0][2] && prio[0][0] >= prio[0][3] && prio[0][0] >= prio[0][4] && prio[0][0] >= prio[0][5] && prio[0][0] >= prio[0][6]) ? 1 : 0;
                2:
                    to[0] <= (prio[1][0] >= prio[1][1] && prio[1][0] >= prio[1][2] && prio[1][0] >= prio[1][3] && prio[1][0] >= prio[1][4] && prio[1][0] >= prio[1][5] && prio[1][0] >= prio[1][6]) ? 2 : 0;
                3:
                    to[0] <= (prio[2][0] >= prio[2][1] && prio[2][0] >= prio[2][2] && prio[2][0] >= prio[2][3] && prio[2][0] >= prio[2][4] && prio[2][0] >= prio[2][5] && prio[2][0] >= prio[2][6]) ? 3 : 0;
                4:
                    to[0] <= (prio[3][0] >= prio[3][1] && prio[3][0] >= prio[3][2] && prio[3][0] >= prio[3][3] && prio[3][0] >= prio[3][4] && prio[3][0] >= prio[3][5] && prio[3][0] >= prio[3][6]) ? 4 : 0;
                5:
                    to[0] <= (prio[4][0] >= prio[4][1] && prio[4][0] >= prio[4][2] && prio[4][0] >= prio[4][3] && prio[4][0] >= prio[4][4] && prio[4][0] >= prio[4][5] && prio[4][0] >= prio[4][6]) ? 5 : 0;
                6:
                    to[0] <= (prio[5][0] >= prio[5][1] && prio[5][0] >= prio[5][2] && prio[5][0] >= prio[5][3] && prio[5][0] >= prio[5][4] && prio[5][0] >= prio[5][5] && prio[5][0] >= prio[5][6]) ? 6 : 0;
                7:
                    to[0] <= (prio[6][0] >= prio[6][1] && prio[6][0] >= prio[6][2] && prio[6][0] >= prio[6][3] && prio[6][0] >= prio[6][4] && prio[6][0] >= prio[6][5] && prio[6][0] >= prio[6][6]) ? 7 : 0;
                default:
                    to[0] <= 0;
            endcase
            case (ti[1])        // Note: target remains 1–7
                1:
                    to[1] <= (prio[0][0] <  prio[0][1] && prio[0][1] >= prio[0][2] && prio[0][1] >= prio[0][3] && prio[0][1] >= prio[0][4] && prio[0][1] >= prio[0][5] && prio[0][1] >= prio[0][6]) ? 1 : 0;
                2:
                    to[1] <= (prio[1][0] <  prio[1][1] && prio[1][1] >= prio[1][2] && prio[1][1] >= prio[1][3] && prio[1][1] >= prio[1][4] && prio[1][1] >= prio[1][5] && prio[1][1] >= prio[1][6]) ? 2 : 0;
                3:
                    to[1] <= (prio[2][0] <  prio[2][1] && prio[2][1] >= prio[2][2] && prio[2][1] >= prio[2][3] && prio[2][1] >= prio[2][4] && prio[2][1] >= prio[2][5] && prio[2][1] >= prio[2][6]) ? 3 : 0;
                4:
                    to[1] <= (prio[3][0] <  prio[3][1] && prio[3][1] >= prio[3][2] && prio[3][1] >= prio[3][3] && prio[3][1] >= prio[3][4] && prio[3][1] >= prio[3][5] && prio[3][1] >= prio[3][6]) ? 4 : 0;
                5:
                    to[1] <= (prio[4][0] <  prio[4][1] && prio[4][1] >= prio[4][2] && prio[4][1] >= prio[4][3] && prio[4][1] >= prio[4][4] && prio[4][1] >= prio[4][5] && prio[4][1] >= prio[4][6]) ? 5 : 0;
                6:
                    to[1] <= (prio[5][0] <  prio[5][1] && prio[5][1] >= prio[5][2] && prio[5][1] >= prio[5][3] && prio[5][1] >= prio[5][4] && prio[5][1] >= prio[5][5] && prio[5][1] >= prio[5][6]) ? 6 : 0;
                7: 
                    to[1] <= (prio[6][0] <  prio[6][1] && prio[6][1] >= prio[6][2] && prio[6][1] >= prio[6][3] && prio[6][1] >= prio[6][4] && prio[6][1] >= prio[6][5] && prio[6][1] >= prio[6][6]) ? 7 : 0;
                default:
                    to[1] <= 0;
            endcase
            case (ti[2])        // Note: target remains 1–7
                1:
                    to[2] <= (prio[0][0] <  prio[0][2] && prio[0][1] <  prio[0][2] && prio[0][2] >= prio[0][3] && prio[0][2] >= prio[0][4] && prio[0][2] >= prio[0][5] && prio[0][2] >= prio[0][6]) ? 1 : 0;
                2:
                    to[2] <= (prio[1][0] <  prio[1][2] && prio[1][1] <  prio[1][2] && prio[1][2] >= prio[1][3] && prio[1][2] >= prio[1][4] && prio[1][2] >= prio[1][5] && prio[1][2] >= prio[1][6]) ? 2 : 0;
                3:
                    to[2] <= (prio[2][0] <  prio[2][2] && prio[2][1] <  prio[2][2] && prio[2][2] >= prio[2][3] && prio[2][2] >= prio[2][4] && prio[2][2] >= prio[2][5] && prio[2][2] >= prio[2][6]) ? 3 : 0;
                4:
                    to[2] <= (prio[3][0] <  prio[3][2] && prio[3][1] <  prio[3][2] && prio[3][2] >= prio[3][3] && prio[3][2] >= prio[3][4] && prio[3][2] >= prio[3][5] && prio[3][2] >= prio[3][6]) ? 4 : 0;
                5:
                    to[2] <= (prio[4][0] <  prio[4][2] && prio[4][1] <  prio[4][2] && prio[4][2] >= prio[4][3] && prio[4][2] >= prio[4][4] && prio[4][2] >= prio[4][5] && prio[4][2] >= prio[4][6]) ? 5 : 0;
                6:
                    to[2] <= (prio[5][0] <  prio[5][2] && prio[5][1] <  prio[5][2] && prio[5][2] >= prio[5][3] && prio[5][2] >= prio[5][4] && prio[5][2] >= prio[5][5] && prio[5][2] >= prio[5][6]) ? 6 : 0;
                7:
                    to[2] <= (prio[6][0] <  prio[6][2] && prio[6][1] <  prio[6][2] && prio[6][2] >= prio[6][3] && prio[6][2] >= prio[6][4] && prio[6][2] >= prio[6][5] && prio[6][2] >= prio[6][6]) ? 7 : 0;
                default:
                    to[2] <= 0;
            endcase            
            case (ti[3])        // Note: target remains 1–7
                1:
                    to[3] <= (prio[0][0] <  prio[0][3] && prio[0][1] <  prio[0][3] && prio[0][2] <  prio[0][3] && prio[0][3] >= prio[0][4] && prio[0][3] >= prio[0][5] && prio[0][3] >= prio[0][6]) ? 1 : 0;
                2:
                    to[3] <= (prio[1][0] <  prio[1][3] && prio[1][1] <  prio[1][3] && prio[1][2] <  prio[1][3] && prio[1][3] >= prio[1][4] && prio[1][3] >= prio[1][5] && prio[1][3] >= prio[1][6]) ? 2 : 0;
                3:
                    to[3] <= (prio[2][0] <  prio[2][3] && prio[2][1] <  prio[2][3] && prio[2][2] <  prio[2][3] && prio[2][3] >= prio[2][4] && prio[2][3] >= prio[2][5] && prio[2][3] >= prio[2][6]) ? 3 : 0;
                4:
                    to[3] <= (prio[3][0] <  prio[3][3] && prio[3][1] <  prio[3][3] && prio[3][2] <  prio[3][3] && prio[3][3] >= prio[3][4] && prio[3][3] >= prio[3][5] && prio[3][3] >= prio[3][6]) ? 4 : 0;
                5:
                    to[3] <= (prio[4][0] <  prio[4][3] && prio[4][1] <  prio[4][3] && prio[4][2] <  prio[4][3] && prio[4][3] >= prio[4][4] && prio[4][3] >= prio[4][5] && prio[4][4] >= prio[4][6]) ? 5 : 0;
                6: 
                    to[3] <= (prio[5][0] <  prio[5][3] && prio[5][1] <  prio[5][3] && prio[5][2] <  prio[5][3] && prio[5][3] >= prio[5][4] && prio[5][3] >= prio[5][5] && prio[5][4] >= prio[5][6]) ? 6 : 0;
                7: 
                    to[3] <= (prio[6][0] <  prio[6][3] && prio[6][1] <  prio[6][3] && prio[6][2] <  prio[6][3] && prio[6][3] >= prio[6][4] && prio[6][3] >= prio[6][5] && prio[6][4] >= prio[6][6]) ? 7 : 0;
                default:
                    to[3] <= 0;
            endcase      
            case (ti[4])        // Note: target remains 1–7
                1:
                    to[4] <= (prio[0][0] <  prio[0][4] && prio[0][1] <  prio[0][4] && prio[0][2] <  prio[0][4] && prio[0][3] <  prio[0][4] && prio[0][4] >= prio[0][5] && prio[0][4] >= prio[0][6]) ? 1 : 0;
                2:
                    to[4] <= (prio[1][0] <  prio[1][4] && prio[1][1] <  prio[1][4] && prio[1][2] <  prio[1][4] && prio[1][3] <  prio[1][4] && prio[1][4] >= prio[1][5] && prio[1][4] >= prio[1][6]) ? 2 : 0;
                3:
                    to[4] <= (prio[2][0] <  prio[2][4] && prio[2][1] <  prio[2][4] && prio[2][2] <  prio[2][4] && prio[2][3] <  prio[2][4] && prio[2][4] >= prio[2][5] && prio[2][4] >= prio[2][6]) ? 3 : 0;
                4:
                    to[4] <= (prio[3][0] <  prio[3][4] && prio[3][1] <  prio[3][4] && prio[3][2] <  prio[3][4] && prio[3][3] <  prio[3][4] && prio[3][4] >= prio[3][5] && prio[3][4] >= prio[3][6]) ? 4 : 0;
                5:
                    to[4] <= (prio[4][0] <  prio[4][4] && prio[4][1] <  prio[4][4] && prio[4][2] <  prio[4][4] && prio[4][3] <  prio[4][4] && prio[4][4] >= prio[4][5] && prio[4][4] >= prio[4][6]) ? 5 : 0;
                6: 
                    to[4] <= (prio[5][0] <  prio[5][4] && prio[5][1] <  prio[5][4] && prio[5][2] <  prio[5][4] && prio[5][3] <  prio[5][4] && prio[5][4] >= prio[5][5] && prio[5][4] >= prio[5][6]) ? 6 : 0;
                7:
                    to[4] <= (prio[6][0] <  prio[6][4] && prio[6][1] <  prio[6][4] && prio[6][2] <  prio[6][4] && prio[6][3] <  prio[6][4] && prio[6][4] >= prio[6][5] && prio[6][4] >= prio[6][6]) ? 7 : 0;
                default:
                    to[4] <= 0;
            endcase      
            case (ti[5])
                1:
                    to[5] <= (prio[0][0] <  prio[0][5] && prio[0][1] <  prio[0][5] && prio[0][2] <  prio[0][5] && prio[0][3] <  prio[0][5] && prio[0][4] <  prio[0][5] && prio[0][5] >= prio[0][6]) ? 1 : 0;
                2:
                    to[5] <= (prio[1][0] <  prio[1][5] && prio[1][1] <  prio[1][5] && prio[1][2] <  prio[1][5] && prio[1][3] <  prio[1][5] && prio[1][4] <  prio[1][5] && prio[1][5] >= prio[1][6]) ? 2 : 0;
                3:
                    to[5] <= (prio[2][0] <  prio[2][5] && prio[2][1] <  prio[2][5] && prio[2][2] <  prio[2][5] && prio[2][3] <  prio[2][5] && prio[2][4] <  prio[2][5] && prio[2][5] >= prio[2][6]) ? 3 : 0;
                4:
                    to[5] <= (prio[3][0] <  prio[3][5] && prio[3][1] <  prio[3][5] && prio[3][2] <  prio[3][5] && prio[3][3] <  prio[3][5] && prio[3][4] <  prio[3][5] && prio[3][5] >= prio[3][6]) ? 4 : 0;
                5:
                    to[5] <= (prio[4][0] <  prio[4][5] && prio[4][1] <  prio[4][5] && prio[4][2] <  prio[4][5] && prio[4][3] <  prio[4][5] && prio[4][4] <  prio[4][5] && prio[4][5] >= prio[4][6]) ? 5 : 0;
                6:
                    to[5] <= (prio[5][0] <  prio[5][5] && prio[5][1] <  prio[5][5] && prio[5][2] <  prio[5][5] && prio[5][3] <  prio[5][5] && prio[5][4] <  prio[5][5] && prio[5][5] >= prio[5][6]) ? 6 : 0;
                7: 
                    to[5] <= (prio[6][0] <  prio[6][5] && prio[6][1] <  prio[6][5] && prio[6][2] <  prio[6][5] && prio[6][3] <  prio[6][5] && prio[6][4] <  prio[6][5] && prio[6][5] >= prio[6][6]) ? 7 : 0;
                default:
                    to[5] <= 0;
            endcase
            case (ti[6])
                1: 
                    to[6] <= (prio[0][0] <  prio[0][6] && prio[0][1] <  prio[0][6] && prio[0][2] <  prio[0][6] && prio[0][3] <  prio[0][6] && prio[0][4] <  prio[0][6] && prio[0][5] <  prio[0][6]) ? 1 : 0;
                2:
                    to[6] <= (prio[1][0] <  prio[1][6] && prio[1][1] <  prio[1][6] && prio[1][2] <  prio[1][6] && prio[1][3] <  prio[1][6] && prio[1][4] <  prio[1][6] && prio[1][5] <  prio[1][6]) ? 2 : 0;
                3: 
                    to[6] <= (prio[2][0] <  prio[2][6] && prio[2][1] <  prio[2][6] && prio[2][2] <  prio[2][6] && prio[2][3] <  prio[2][6] && prio[2][4] <  prio[2][6] && prio[2][5] <  prio[2][6]) ? 3 : 0;
                4:
                    to[6] <= (prio[3][0] <  prio[3][6] && prio[3][1] <  prio[3][6] && prio[3][2] <  prio[3][6] && prio[3][3] <  prio[3][6] && prio[3][4] <  prio[3][6] && prio[3][5] <  prio[3][6]) ? 4 : 0;
                5:
                    to[6] <= (prio[4][0] <  prio[4][6] && prio[4][1] <  prio[4][6] && prio[4][2] <  prio[4][6] && prio[4][3] <  prio[4][6] && prio[4][4] <  prio[4][6] && prio[4][5] <  prio[4][6]) ? 5 : 0;
                6:
                    to[6] <= (prio[5][0] <  prio[5][6] && prio[5][1] <  prio[5][6] && prio[5][2] <  prio[5][6] && prio[5][3] <  prio[5][6] && prio[5][4] <  prio[5][6] && prio[5][5] <  prio[5][6]) ? 6 : 0;
                7: 
                    to[6] <= (prio[6][0] <  prio[6][6] && prio[6][1] <  prio[6][6] && prio[6][2] <  prio[6][6] && prio[6][3] <  prio[6][6] && prio[6][4] <  prio[6][6] && prio[6][5] <  prio[6][6]) ? 7 : 0;
                default:
                    to[6] <= 0;
            endcase
        end
    end
    
    assign to1 = to[0];
    assign to2 = to[1];
    assign to3 = to[2];
    assign to4 = to[3];
    assign to5 = to[4];
    assign to6 = to[5];
    assign to7 = to[6];

endmodule
