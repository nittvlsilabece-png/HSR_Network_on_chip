`timescale 1ns / 1ps

module Network_tb();

	reg clk;
	reg rst;
	integer i;
	integer fout0;
	integer fout1;
	integer fout2;
	integer fout3;
	integer fout4;
	integer fout5;
	integer fout6;
	integer fout7;
	integer fout8;
	integer fout9;
	integer fout10;
	integer fout11;
	integer fout12;
	integer fout13;
	integer fout14;
	integer fout15;
	reg [15:0] my_result;

	always #10 clk <= ~clk;

	initial begin
		clk <= 1'b0;
		rst <= 1'b0;
	end

	initial begin
        fout0   <= $fopen("data_out_0.txt", "w");
        fout1   <= $fopen("data_out_1.txt", "w");
        fout2   <= $fopen("data_out_2.txt", "w");
        fout3   <= $fopen("data_out_3.txt", "w");
        fout4   <= $fopen("data_out_4.txt", "w");
        fout5   <= $fopen("data_out_5.txt", "w");
        fout6   <= $fopen("data_out_6.txt", "w");
        fout7   <= $fopen("data_out_7.txt", "w");
        fout8   <= $fopen("data_out_8.txt", "w");
        fout9   <= $fopen("data_out_9.txt", "w");
        fout10  <= $fopen("data_out_10.txt", "w");
        fout11  <= $fopen("data_out_11.txt", "w");
        fout12  <= $fopen("data_out_12.txt", "w");
        fout13  <= $fopen("data_out_13.txt", "w");
        fout14  <= $fopen("data_out_14.txt", "w");
        fout15  <= $fopen("data_out_15.txt", "w");
        #200 rst <= 1'b1;
        #8000;
        for (i = 0; i < 30; i = i + 1) begin
            my_result = NoC.cluster0.u_node0.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout0, "%h", my_result);
            my_result = NoC.cluster0.u_node1.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout1, "%h", my_result);
            my_result = NoC.cluster0.u_node2.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout2, "%h", my_result);
            my_result = NoC.cluster0.u_node3.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout3, "%h", my_result);
            my_result = NoC.cluster1.u_node0.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout4, "%h", my_result);
            my_result = NoC.cluster1.u_node1.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout5, "%h", my_result);
            my_result = NoC.cluster1.u_node2.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout6, "%h", my_result);
            my_result = NoC.cluster1.u_node3.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout7, "%h", my_result);
            my_result = NoC.cluster2.u_node0.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout8, "%h", my_result);
            my_result = NoC.cluster2.u_node1.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout9, "%h", my_result);
            my_result = NoC.cluster2.u_node2.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout10, "%h", my_result);
            my_result = NoC.cluster2.u_node3.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout11, "%h", my_result);
            my_result = NoC.cluster3.u_node0.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout12, "%h", my_result);
            my_result = NoC.cluster3.u_node1.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout13, "%h", my_result);
            my_result = NoC.cluster3.u_node2.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout14, "%h", my_result);
            my_result = NoC.cluster3.u_node3.PE.datain_buffer.mem[i][19:4];
            $fdisplay(fout15, "%h", my_result);
        end

        $fclose(fout0);
        $fclose(fout1);
        $fclose(fout2);
        $fclose(fout3);
        $fclose(fout4);
        $fclose(fout5);
        $fclose(fout6);
        $fclose(fout7);
        $fclose(fout8);
        $fclose(fout9);
        $fclose(fout10);
        $fclose(fout11);
        $fclose(fout12);
        $fclose(fout13);
        $fclose(fout14);
        $fclose(fout15);
        $finish;
    end

    Network     NoC(
                    .clk    (clk),
                    .rst    (rst)
                );

endmodule