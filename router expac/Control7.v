module Control7 (
                input vc1, vc2, vc3, vc4, vc5, vc6, vc7,
                input [2:0] sa1, sa2, sa3, sa4, sa5, sa6, sa7,
                output [6:0] pop_ctrl
                );
    
    reg ctr1, ctr2, ctr3, ctr4, ctr5, ctr6, ctr7;
    assign pop_ctrl = {ctr7, ctr6, ctr5, ctr4, ctr3, ctr2, ctr1};

    always @(*) begin
        case (sa1)
            3'b001:
                ctr1 = vc1;
            3'b010:
                ctr1 = vc2;
            3'b011:
                ctr1 = vc3;
            3'b100:
                ctr1 = vc4;
            3'b101:
                ctr1 = vc5;
            3'b110:
                ctr1 = vc6;
            3'b111:
                ctr1 = vc7;
            default:
                ctr1 = 0;
        endcase
    end

    always @(*) begin
        case (sa2)
            3'b001:
                ctr2 = vc1;
            3'b010:
                ctr2 = vc2;
            3'b011:
                ctr2 = vc3;
            3'b100:
                ctr2 = vc4;
            3'b101:
                ctr2 = vc5;
            3'b110:
                ctr2 = vc6;
            3'b111:
                ctr2 = vc7;
            default:
                ctr2 = 0;
        endcase
    end

    always @(*) begin
        case (sa3)
            3'b001:
                ctr3 = vc1;
            3'b010:
                ctr3 = vc2;
            3'b011:
                ctr3 = vc3;
            3'b100:
                ctr3 = vc4;
            3'b101:
                ctr3 = vc5;
            3'b110:
                ctr3 = vc6;
            3'b111:
                ctr3 = vc7;
            default:
                ctr3 = 0;
        endcase
    end

    always @(*) begin
        case (sa4)
            3'b001:
                ctr4 = vc1;
            3'b010:
                ctr4 = vc2;
            3'b011:
                ctr4 = vc3;
            3'b100:
                ctr4 = vc4;
            3'b101:
                ctr4 = vc5;
            3'b110:
                ctr4 = vc6;
            3'b111:
                ctr4 = vc7;
            default:
                ctr4 = 0;
        endcase
    end

    always @(*) begin
        case(sa5)
            3'b001:
                ctr5 = vc1;
            3'b010:
                ctr5 = vc2;
            3'b011:
                ctr5 = vc3;
            3'b100:
                ctr5 = vc4;
            3'b101:
                ctr5 = vc5;
            3'b110:
                ctr5 = vc6;
            3'b111:
                ctr5 = vc7;
            default:
                ctr5 = 0;
        endcase
    end


    always @(*) begin
        case(sa6)
            3'b001:
                ctr6 = vc1;
            3'b010:
                ctr6 = vc2;
            3'b011:
                ctr6 = vc3;
            3'b100:
                ctr6 = vc4;
            3'b101:
                ctr6 = vc5;
            3'b110:
                ctr6 = vc6;
            3'b111:
                ctr6 = vc7;
            default:
                ctr6 = 0;
        endcase
    end


    always @(*) begin
        case(sa7)
            3'b001:
                ctr7 = vc1;
            3'b010:
                ctr7 = vc2;
            3'b011:
                ctr7 = vc3;
            3'b100:
                ctr7 = vc4;
            3'b101:
                ctr7 = vc5;
            3'b110:
                ctr7 = vc6;
            3'b111:
                ctr7 = vc7;
            default:
                ctr7 = 0;
        endcase
    end
endmodule