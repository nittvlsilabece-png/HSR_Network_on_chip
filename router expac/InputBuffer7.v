module InputBuffer7 (
	input	clk,
	input	rst,
	input	[22:0] data,				// 22:7 is data, 6:3 is address, 2:0 is target
	input	valid,					// indicates whether the data signal be written to the buffer
	input	pop,					// indicates whether the FIFO head data be popped. 1 means pop.
	output	[22:0] out				// FIFO header data
	);

	reg [2:0] state, next_state;			// Valid range is 0 to 4, representing valid data in the FIFO.
	localparam WRONG = 3'd0;

	always @(posedge clk or negedge rst) begin
		if(!rst)
			state <= 0;
		else begin
			state <= next_state;
		end
	end

	always @(*) begin				// valid & pop -> no-change (item given and taken instantly), valid & !pop -> +1, !valid & pop -> -1, !valid & !pop -> no-change (nothing happens)
		case (state)
			0: 
				next_state = valid ? 1 : pop ? WRONG : 0;			
			1:
				next_state = valid ? pop ? 1 : 2 : pop ? 0 : 1;
			2:	
				next_state = valid ? pop ? 2 : 3 : pop ? 1 : 2;
			3:
				next_state = valid ? pop ? 3 : 4 : pop ? 2 : 3;
			4:
				next_state = valid ? pop ? 4 : 5 : pop ? 3 : 4;
			5:
				next_state = valid ? pop ? 5 : WRONG : pop ? 4 : 5;
			default:
				next_state = 0;
		endcase
	end

	reg [22:0] fifo [4:0];				// FIFO[3] is the head (data output)

	always @ (posedge clk or negedge rst) begin
		if (!rst) begin
			{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
		end
		else begin
			if (pop) begin
				if (valid) begin	// pop and write
					case (state)
						0: 
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {data, 23'b0, 23'b0, 23'b0, 23'b0};  //pop doesn't work because there is no data in the FIFO to pop
						1:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {data, 23'b0, 23'b0, 23'b0, 23'b0};  //incoming data is popped - right behavior
						2:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], data, 23'b0, 23'b0, 23'b0};
						3:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], fifo[2], data, 23'b0, 23'b0};
						4:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], fifo[2], fifo[1], data, 23'b0};
						5:
						    {fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], fifo[2], fifo[1], fifo[0], data};
						default:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
					endcase
				end
				else begin		// pop without writing
					case(state)
						2:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], 23'b0, 23'b0, 23'b0, 23'b0};
						3:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], fifo[2], 23'b0, 23'b0, 23'b0};
						4:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], fifo[2], fifo[1], 23'b0, 23'b0};
						5:
						    {fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[3], fifo[2], fifo[1], fifo[0], 23'b0};
						default:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
					endcase
				end
			end
			else begin
				if(valid) begin		// Does not pop but writes
					case(state)
						0:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {data, 23'b0, 23'b0, 23'b0, 23'b0};
						1:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[4], data, 23'b0, 23'b0, 23'b0};
						2:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[4], fifo[3], data, 23'b0, 23'b0};
						3:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[4], fifo[3], fifo[2], data, 23'b0};
						4:
						    {fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[4], fifo[3], fifo[2], fifo[1], data};
						default:
							{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {23'b0, 23'b0, 23'b0, 23'b0, 23'b0};
					endcase
				end
				else begin		// Neither pop nor write
					{fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]} <= {fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]};
				end
			end
		end
	end
	
	assign out = fifo[4];

endmodule
	

	