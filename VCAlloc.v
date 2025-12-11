module VCAlloc (
		input clk,
		input rst,
		input [2:0] targ1, targ2, targ3, targ4, targ5,
		input cred1, cred2, cred3, cred4,					// credit_in, from downstream, 1 indicates popping one data item
		output reg alloc1, alloc2, alloc3, alloc4, alloc5			// Allocation for the output port buffer
		);

	reg [2:0] count1, count2, count3, count4;					// Counts the valid data in the corresponding output port buffer, with a maximum of 4.

	always @(posedge clk or negedge rst) begin					// N,S,E,W - need buffers and credit system
		if(!rst) begin
			{count1, alloc1} <= {3'b0, 1'b0};
		end
		else begin
			if (count1 == 4) begin
				alloc1 <= 0;						// cannot alloc since count is max
				count1 <= cred1 ? (count1 - 1) : count1;		// if credit in received, count reduced
			end
			else begin
				if (targ1==1 || targ2==1 || targ3==1 || targ4==1 || targ5==1) begin
					alloc1 <= 1;							// count isn't max so can alloc
					count1 <= cred1 ? count1 : (count1 + 1);			// if no credit in, increase pressure else maintain
				end
				else begin													
					alloc1 <= 0;								//no requester hence no alloc
					count1 <= cred1 ? (count1 == 0) ? count1 : (count1 - 1) : count1;	// if a credit arrives and count1>0, decrement; else hold.
				end
			end
		end
	end
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			{count2, alloc2} <= {3'b0, 1'b0}; 
		end
		else begin
			if (count2 == 4) begin
				alloc2 <= 0;
				count2 <= cred2 ? (count2 - 1) : count2;
			end
			else begin
				if (targ1==2 || targ2==2 || targ3==2 || targ4==2 || targ5==2) begin
					alloc2 <= 1;
					count2 <= cred2 ? count2 : (count2 + 1);
				end
				else begin
					alloc2 <= 0;
					count2 <= cred2 ? (count2 == 0) ? count2 : (count2 - 1) : count2;
				end
			end
		end
	end
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			{count3, alloc3} <= {3'b0, 1'b0};
		end
		else begin
			if (count3 == 4) begin
				alloc3 <= 0;
				count3 <= cred3 ? (count3 - 1): count3;
			end
			else begin
				if (targ1==3 || targ2==3 || targ3==3 || targ4==3 || targ5==3) begin
					alloc3 <= 1;
					count3 <= cred3 ? count3 : (count3 + 1);
				end
				else begin
					alloc3 <= 0;
					count3 <= cred3 ? (count3 == 0) ? count3 : (count3 - 1) : count3;
				end
			end
		end
	end

	always @(posedge clk or negedge rst) begin
    		if(!rst) begin
        		{count4, alloc4} <= {3'b0, 1'b0};
    		end
    		else begin
        		if (count4 == 4) begin
            			alloc4 <= 0;
            			count4 <= cred4 ? (count4 - 1) : count4;
        		end
        		else begin
            			if (targ1==4 || targ2==4 || targ3==4 || targ4==4 || targ5==4) begin
                			alloc4 <= 1;
                			count4 <= cred4 ? count4 : (count4 + 1);
            			end
            			else begin
                			alloc4 <= 0; 
                			count4 <= cred4 ? ((count4 == 0) ? count4 : (count4 - 1)) : count4;
           			end
        		end
    		end
	end


	always @(posedge clk or negedge rst) begin		// PE - Local delivery so doesn't need Buffer and credit system
		if(!rst) begin
			alloc5 <= 1'b0;
		end
		else begin
			if (targ1==5 || targ2==5 || targ3==5 || targ4==5 || targ5==5) begin
				alloc5 <= 1;
			end
			else begin
				alloc5 <= 0;
			end
		end
	end

endmodule