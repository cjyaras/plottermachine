module FD_latch(reset, next_pc_plus_1, next_instruction, clk, enable, curr_pc_plus_1, curr_instruction);
	input reset, clk, enable;
	input [31:0] next_pc_plus_1, next_instruction;
	output [31:0] curr_pc_plus_1, curr_instruction;
	
	register pc_plus_1(.clk(clk), .ena(enable), .next(next_pc_plus_1), .curr(curr_pc_plus_1), .rst(reset));
	register ir(.clk(clk), .ena(enable), .next(next_instruction), .curr(curr_instruction), .rst(reset));

endmodule