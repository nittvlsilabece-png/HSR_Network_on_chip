 module Router7 ( 
	input clk,						//clock
	input rst,						//reseta
	input [19:0] in1, in2, in3, in4, in5, in6, in7,		//payload	(input)
	input vi1, vi2, vi3, vi4, vi5, vi6, vi7,				//valid		(input)
	input ci1, ci2, ci3, ci4, ci5, ci6, ci7,	 			//credit	(input)
	input [1:0] my_cluster, my_local,
	input is_hub, is_superhub,
	output [19:0] o1, o2, o3, o4, o5, o6, o7,			//payload	(output)
	output vo1, vo2, vo3, vo4, vo5,	vo6, vo7,			//valid		(output)
	output co1, co2, co3, co4, co5, co6, co7			//credit	(output)
	);

	wire [19:0] in [6:0]; 					//internal wires for 7 payloads
	wire valid [6:0];						//internal wires for 5 valids
	reg [19:0] in_pipe [6:0];				//pipelined inputs
	reg valid_pipe [6:0]; 					//pipelined valids

	assign valid[0] = vi1;					//assigning inputs to internal wires
	assign valid[1] = vi2;
	assign valid[2] = vi3;
	assign valid[3] = vi4;
	assign valid[4] = vi5;
	assign valid[5] = vi6;
	assign valid[6] = vi7;

	assign in[0] = in1;
	assign in[1] = in2;
	assign in[2] = in3;
	assign in[3] = in4;
	assign in[4] = in5;
	assign in[5] = in6;
	assign in[6] = in7;

	integer i;						//buffered inputs

	always @ (posedge clk or negedge rst) begin	
		if(!rst) begin
			for (i = 0; i < 7; i = i + 1)begin
				in_pipe[i] <= 0;
				valid_pipe[i] <= 0;
			end
		end
		else begin
			for(i = 0; i < 7; i = i + 1)begin
				in_pipe[i] <= in[i];
				valid_pipe[i] <= valid[i];
			end
		end
	end

	//route computation

	wire [22:0] in_RC [6:0]; 				//data from RC to IB
	wire valid_RC [6:0];					//valid from RC to IB

	genvar j;

	generate 
		for (j = 0; j < 7; j = j + 1) begin : route
		RouteCompute7 RC(.clk(clk), .rst(rst), .datain(in_pipe[j]),
						.in_valid(valid_pipe[j]), .my_cluster(my_cluster), .my_local(my_local), 
						.is_hub (is_hub), .is_superhub (is_superhub),
						.dataout(in_RC[j]), .out_valid(valid_RC[j]));
						//clk, rst, datain, in_valid, pos		-> inputs to RC
						//dataout, out_valid 			  	-> outputs from RC
		end
	endgenerate

	//input buffer (FIFO)

	wire [6:0] pop_ctrl;					
	wire [22:0] fifo_out [6:0];					//data from IB to fifo_out pipeline reg	
	reg  [22:0] fifo_out_reg [6:0];					//output from fifo_out pipeline reg

	generate for(j = 0; j < 7; j = j + 1) begin : buffer
		InputBuffer7 IB(.clk(clk), .rst(rst), .data(in_RC[j]),
			 	.valid(valid_RC[j]),
				.pop  ((fifo_out[j][2:0] != 0 && fifo_out_reg[j][2:0] == 0) ? 1'b1 : pop_ctrl[j]), 
				.out  (fifo_out[j]));
				//clk, rst, data, valid, pop			-> input
				//out						-> output
				//for pop [2:0] check -> check for target (any packet after RC will have [2:0] in range of 1 to 5 only if not it implies reg is empty so load)
		end
	endgenerate

	generate for(j = 0; j < 7; j = j + 1) begin : VCSA
		always @ (posedge clk or negedge rst) begin
			if (!rst) begin
				fifo_out_reg[j] <= 0;
			end
			else begin
				fifo_out_reg[j] <= (fifo_out_reg[j][2:0] == 0) ? fifo_out[j] : pop_ctrl[j] ? fifo_out[j] : fifo_out_reg[j];
			end
		end
	end
	endgenerate

	//virtual channels and switch allocations
	wire vc1, vc2, vc3, vc4, vc5, vc6, vc7;

	VCAlloc7 VCA(
				.clk(clk),
				.rst(rst),
				.targ1(fifo_out_reg[0][2:0]==0 ? fifo_out[0][2:0] : pop_ctrl[0] ? fifo_out[0][2:0] : fifo_out_reg[0][2:0]),
				.targ2(fifo_out_reg[1][2:0]==0 ? fifo_out[1][2:0] : pop_ctrl[1] ? fifo_out[1][2:0] : fifo_out_reg[1][2:0]),
				.targ3(fifo_out_reg[2][2:0]==0 ? fifo_out[2][2:0] : pop_ctrl[2] ? fifo_out[2][2:0] : fifo_out_reg[2][2:0]),
				.targ4(fifo_out_reg[3][2:0]==0 ? fifo_out[3][2:0] : pop_ctrl[3] ? fifo_out[3][2:0] : fifo_out_reg[3][2:0]),
				.targ5(fifo_out_reg[4][2:0]==0 ? fifo_out[4][2:0] : pop_ctrl[4] ? fifo_out[4][2:0] : fifo_out_reg[4][2:0]),
				.targ6(fifo_out_reg[5][2:0]==0 ? fifo_out[5][2:0] : pop_ctrl[5] ? fifo_out[5][2:0] : fifo_out_reg[5][2:0]),
				.targ7(fifo_out_reg[6][2:0]==0 ? fifo_out[6][2:0] : pop_ctrl[6] ? fifo_out[6][2:0] : fifo_out_reg[6][2:0]),
				.cred1(ci1),
				.cred2(ci2),
				.cred3(ci3),
				.cred4(ci4),
				.cred5(ci5),
				.cred6(ci6),
				.cred7(ci7),
				.alloc1(vc1),
				.alloc2(vc2),
				.alloc3(vc3),
				.alloc4(vc4),
				.alloc5(vc5),
				.alloc6(vc6),
				.alloc7(vc7)
	);

	wire [2:0] to1, to2, to3, to4, to5, to6, to7;

	SwitchAlloc7 SA(
					.clk(clk),
					.rst(rst),
					.targ_pack({
				     fifo_out_reg[6][2:0]==0 ? fifo_out[6][2:0] : pop_ctrl[6] ? fifo_out[6][2:0] : fifo_out_reg[6][2:0],
				     fifo_out_reg[5][2:0]==0 ? fifo_out[5][2:0] : pop_ctrl[5] ? fifo_out[5][2:0] : fifo_out_reg[5][2:0],
				     fifo_out_reg[4][2:0]==0 ? fifo_out[4][2:0] : pop_ctrl[4] ? fifo_out[4][2:0] : fifo_out_reg[4][2:0],
                                     fifo_out_reg[3][2:0]==0 ? fifo_out[3][2:0] : pop_ctrl[3] ? fifo_out[3][2:0] : fifo_out_reg[3][2:0],
                                     fifo_out_reg[2][2:0]==0 ? fifo_out[2][2:0] : pop_ctrl[2] ? fifo_out[2][2:0] : fifo_out_reg[2][2:0],
                                     fifo_out_reg[1][2:0]==0 ? fifo_out[1][2:0] : pop_ctrl[1] ? fifo_out[1][2:0] : fifo_out_reg[1][2:0],
                                     fifo_out_reg[0][2:0]==0 ? fifo_out[0][2:0] : pop_ctrl[0] ? fifo_out[0][2:0] : fifo_out_reg[0][2:0]
					}),
					.pop_ctrl (pop_ctrl),
					.to1(to1),
					.to2(to2),
					.to3(to3),
					.to4(to4),
					.to5(to5),
					.to6(to6),
					.to7(to7)
	);

	Control7 Ctr (
				.vc1(vc1),
				.vc2(vc2),
				.vc3(vc3),
				.vc4(vc4),
				.vc5(vc5),
				.vc6(vc6),
				.vc7(vc7),
				.sa1(to1),
				.sa2(to2),
				.sa3(to3),
				.sa4(to4),
				.sa5(to5),
				.sa6(to6),
				.sa7(to7),
				.pop_ctrl(pop_ctrl)
	);

	//switch transform stage

	Crossbar7 ST(
				.clk(clk),
				.rst(rst),
				.in1(fifo_out_reg[0]),
				.in2(fifo_out_reg[1]),
				.in3(fifo_out_reg[2]),
				.in4(fifo_out_reg[3]),
				.in5(fifo_out_reg[4]),
				.in6(fifo_out_reg[5]),
				.in7(fifo_out_reg[6]),
				.cb_ctrl(pop_ctrl),
				.o1(o1),
				.o2(o2),
				.o3(o3),
				.o4(o4),
				.o5(o5),
				.o6(o6),
				.o7(o7),
				.v1(vo1),
				.v2(vo2),
				.v3(vo3),
				.v4(vo4),
				.v5(vo5),
				.v6(vo6),
				.v7(vo7)
	);

	assign co1 = pop_ctrl[0];
	assign co2 = pop_ctrl[1];
	assign co3 = pop_ctrl[2];
	assign co4 = pop_ctrl[3];
	assign co5 = pop_ctrl[4];
	assign co6 = pop_ctrl[5];
	assign co7 = pop_ctrl[6];

endmodule