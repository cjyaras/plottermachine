module DX_latch(reset, next_pc_plus_1, next_instruction, next_A, next_B, clk, enable, curr_pc_plus_1, curr_instruction, curr_A, curr_B);
	input reset, clk, enable;
	input [31:0] next_pc_plus_1, next_instruction, next_A, next_B;
	output [31:0] curr_pc_plus_1, curr_instruction, curr_A, curr_B;
	
	register pc(.clk(clk), .ena(enable), .next(next_pc_plus_1), .curr(curr_pc_plus_1), .rst(reset));
	register ir(.clk(clk), .ena(enable), .next(next_instruction), .curr(curr_instruction), .rst(reset));
	register a(.clk(clk), .ena(enable), .next(next_A), .curr(curr_A), .rst(reset));
	register b(.clk(clk), .ena(enable), .next(next_B), .curr(curr_B), .rst(reset));

endmodule