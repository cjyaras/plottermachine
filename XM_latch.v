module XM_latch(reset, next_pc_plus_1, next_instruction, next_O, next_B, clk, enable, curr_pc_plus_1, curr_instruction, curr_O, curr_B);
	input reset, clk, enable;
	input [31:0] next_pc_plus_1, next_instruction, next_O, next_B;
	output [31:0] curr_pc_plus_1, curr_instruction, curr_O, curr_B;
	
	register pc(.clk(clk), .ena(enable), .next(next_pc_plus_1), .curr(curr_pc_plus_1), .rst(reset));
	register ir(.clk(clk), .ena(enable), .next(next_instruction), .curr(curr_instruction), .rst(reset));
	register o(.clk(clk), .ena(enable), .next(next_O), .curr(curr_O), .rst(reset));
	register b(.clk(clk), .ena(enable), .next(next_B), .curr(curr_B), .rst(reset));

endmodule