module VCAlloc7 (
		input clk,
		input rst,
		input [2:0] targ1, targ2, targ3, targ4, targ5, targ6, targ7,
		input cred1, cred2, cred3, cred4, cred5, cred6, cred7,				// credit_in, from downstream, 1 indicates popping one data item
		output reg alloc1, alloc2, alloc3, alloc4, alloc5, alloc6, alloc7		// Allocation for the output port buffer
		);

	reg [2:0] count1, count2, count3, count4, count5, count6, count7;					// Counts the valid data in the corresponding output port buffer, with a maximum of 4.

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
				if (targ1==1 || targ2==1 || targ3==1 || targ4==1 || targ5==1 || targ6==1 || targ7==1) begin
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
				if (targ1==2 || targ2==2 || targ3==2 || targ4==2 || targ5==2 || targ6==2 || targ7==2) begin
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
				if (targ1==3 || targ2==3 || targ3==3 || targ4==3 || targ5==3 || targ6==3 || targ7==3) begin
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
				if (targ1==4 || targ2==4 || targ3==4 || targ4==4 || targ5==4 || targ6==4 || targ7==4) begin
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


	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			{count5, alloc5} <= {3'b0, 1'b0};
		end
		else begin
			if (count5 == 4) begin
				alloc5 <= 0;
				count5 <= cred5 ? (count5 - 1) : count5;
			end
			else begin
				if (targ1==5 || targ2==5 || targ3==5 || targ4==5 || targ5==5 || targ6==5 || targ7==5) begin
					alloc5 <= 1;
					count5 <= cred5 ? count5 : (count5 + 1);
				end
				else begin
					alloc5 <= 0;
					count5 <= cred5 ? ((count5 == 0) ? count5 : (count5 - 1)) : count5;
				end
			end
		end
	end

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			{count6, alloc6} <= {3'b0, 1'b0};
		end
		else begin
			if (count6 == 4) begin
				alloc6 <= 0;
				count6 <= cred6 ? (count6 - 1) : count6;
			end
			else begin
				if (targ1==6 || targ2==6 || targ3==6 || targ4==6 || targ5==6 || targ6==6 || targ7==6) begin
					alloc6 <= 1;
					count6 <= cred6 ? count6 : (count6 + 1);
				end
				else begin
					alloc6 <= 0;
					count6 <= cred6 ? ((count6 == 0) ? count6 : (count6 - 1)) : count6;
				end
			end
		end
	end

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			{count7, alloc7} <= {3'b0, 1'b0};
		end
		else begin
			if (count7 == 4) begin
				alloc7 <= 0;
				count7 <= cred7 ? (count7 - 1) : count7;
			end
			else begin
				if (targ1==7 || targ2==7 || targ3==7 || targ4==7 || targ5==7 || targ6==7 || targ7==7) begin
					alloc7 <= 1;
					count7 <= cred7 ? count7 : (count7 + 1);
				end
				else begin
					alloc7 <= 0;
					count7 <= cred7 ? ((count7 == 0)? count7 : (count7 - 1)) : count7;
				end
			end
		end
	end

endmodule