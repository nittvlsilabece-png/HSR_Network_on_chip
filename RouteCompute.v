//datain  : 	{payload[15:0], dest_cluster[1:0], dest_local[1:0]} // 20 bits
//dataout :	{payload[15:0], dest_cluster[1:0], dest_local[1:0], target[2:0]} // 23 bits
//direction :	1 - CW, 2 - CCW, 3 - Star UP, 4 - Star DOWN (not used for leafs), 5 - PE 

module RouteCompute( 	input clk,
			input rst,
			input [19:0] datain,
			input in_valid,

			input [1:0] my_cluster,
			input [1:0] my_local,   //pos
			input is_hub,		// 0 - leaf, 1 - hub
			input is_superhub,	// 1 - super-hub
			
			output [22:0] dataout,
			output out_valid
		);

	reg [19:0] d_pipe;
	reg	   v_pipe;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			d_pipe <= 20'b0;
			v_pipe <= 1'b0;
		end
		else if (!in_valid) begin
                		d_pipe <= 20'b0;
                		v_pipe <= 1'b0;
            	end
            	else begin
                		d_pipe <= datain;
                		v_pipe <= in_valid;
		end
	end

	wire [15:0] payload 	= datain[19:4];
	wire [1:0] dest_cluster = datain[3:2];
	wire [1:0] dest_local 	= datain[1:0];

	reg [2:0] target;
	
	function [2:0] ring_dir;
		input [1:0] cur;
		input [1:0] dst;
		reg [2:0] cw, ccw;
		begin
			cw  = (dst >= cur) ? (dst - cur) : (4 + dst - cur);
			ccw = (cur >= dst) ? (cur - dst) : (4 + cur - dst);
			ring_dir = (cw <= ccw) ? 3'd1 : 3'd2; // 1 - CW, 2 - CCW
		end
	endfunction

	function [2:0] ring_min_dist;
		input [1:0] cur;
		input [1:0] dst;
		reg [2:0] cw, ccw;
		begin
			cw  = (dst >= cur) ? (dst - cur) : (4 + dst - cur);
			ccw = (cur >= dst) ? (cur - dst) : (4 + cur - dst);
			ring_min_dist = (cw <= ccw) ? cw : ccw; //just min dist
		end
	endfunction

	always @(posedge clk or negedge rst) begin
  		if (!rst) begin
    			target <= 3'b000;
  		end else if (is_superhub) begin
    			target <= 3'd4; // always Star_DOWN
  		end else if (is_hub) begin
   			 if (dest_cluster == my_cluster)
      				target <= 3'd4; // same cluster -> Star_DOWN
    			else begin
      				case (ring_min_dist(my_cluster, dest_cluster))
        				3'd1: target <= ring_dir(my_cluster, dest_cluster);
        				3'd2: target <= 3'd3; // STAR_UP
        				default: target <= 3'd3; // safe fallback
      				endcase
    				end
  			end else begin	// leaf
    				if (dest_cluster == my_cluster) begin
      					if (dest_local == my_local) begin
        					target <= 3'd5; // local PE
      					end else if (ring_min_dist(my_local, dest_local) == 3'd2) begin	// distance-2 tie-break by parity of my_local
        					target <= (my_local[0] == 1'b0) ? 3'd1 : 3'd2; // even->CW, odd->CCW
      					end else begin
        					target <= ring_dir(my_local, dest_local); // 1-hop case
      					end
    				end else begin
      					target <= 3'd3; // STAR_UP to hub
    				end
  			end
		end

	
	assign out_valid = v_pipe;
	assign dataout [22:7] = d_pipe[19:4];
	assign dataout [6:5] = d_pipe[3:2];
	assign dataout [4:3] = d_pipe[1:0];
	assign dataout [2:0] = target;

endmodule
			
