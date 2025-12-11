`timescale 1ns / 1ps

module Node2 (
		input clk,
		input rst,
		input [19:0] in1, in2, in3, in4, 
		input vi1, vi2, vi3, vi4,
		input ci1, ci2, ci3, ci4,
		input [1:0] my_cluster, my_local,
		input is_hub, is_superhub,
		output [19:0] o1, o2, o3, o4,
		output vo1, vo2, vo3, vo4,
		output co1, co2, co3, co4,
		output [15:0] read
		);
	
	wire [19:0] inject;
	wire inject_valid;
	wire [19:0] eject;
	wire eject_valid;
	wire credit;
	
	Router Router_0 (
			.clk (clk),
			.rst (rst),
			.in1 (in1), .in2 (in2), .in3 (in3), .in4 (in4), .in5 (inject),
			.vi1 (vi1), .vi2 (vi2), .vi3 (vi3), .vi4 (vi4), .vi5 (inject_valid),
			.ci1 (ci1), .ci2 (ci2), .ci3 (ci3), .ci4 (ci4),
			.my_cluster (my_cluster), .my_local (my_local),
			.is_hub (is_hub), .is_superhub (is_superhub),
			.o1 (o1), .o2 (o2), .o3 (o3), .o4 (o4), .o5 (eject),
			.vo1 (vo1), .vo2 (vo2), .vo3 (vo3), .vo4 (vo4), .vo5 (eject_valid),
			.co1 (co1), .co2 (co2), .co3 (co3), .co4 (co4), .co5 (credit)
			);

	ProcessingElement2 PE (
				.clk (clk),
				.rst (rst),
				.datain (eject),
				.in_valid (eject_valid),
				.ci (credit),
				.dataout (inject),
				.out_valid (inject_valid),
				.read (read)
				);
endmodule
