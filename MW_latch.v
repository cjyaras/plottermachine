module MW_latch(reset, next_pc_plus_1, next_instruction, next_O, next_D, next_ra, clk, enable, ra_enable, curr_pc_plus_1, curr_instruction, curr_O, curr_D, curr_ra);
	input reset, clk, enable, ra_enable;
	input [31:0] next_pc_plus_1, next_instruction, next_O, next_D, next_ra;
	output [31:0] curr_pc_plus_1, curr_instruction, curr_O, curr_D, curr_ra;
	
	register pc(.clk(clk), .ena(enable), .next(next_pc_plus_1), .curr(curr_pc_plus_1), .rst(reset));
	register ir(.clk(clk), .ena(enable), .next(next_instruction), .curr(curr_instruction), .rst(reset));
	register o(.clk(clk), .ena(enable), .next(next_O), .curr(curr_O), .rst(reset));
	register d(.clk(clk), .ena(enable), .next(next_D), .curr(curr_D), .rst(reset));
	register ra(.clk(clk), .ena(enable && ra_enable), .next(next_ra), .curr(curr_ra), .rst(reset));

endmodule