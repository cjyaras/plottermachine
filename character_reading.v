module character_reading(clk, REACHED_END, next_character, CHAR_READY, choose, curr_character, debug_output);
	input clk, REACHED_END;
	input [5:0] next_character;
	input CHAR_READY;
	input [13:0] choose;
	output [7:0] curr_character;
	
	wire [7:0] extended_next_character;
	assign extended_next_character[7] = 1'b0;
	assign extended_next_character[6] = 1'b0;
	assign extended_next_character[5:0] = next_character;
	
	reg [11:0] index;
	reg [31:0] curr_word;
	reg [2:0] curr_index_in_word;
	
	initial begin
		index = 6'b0;
		curr_word = 32'b0;
		curr_index_in_word = 2'b0;
	end
	
	always @(posedge CHAR_READY) begin
		curr_word[8*curr_index_in_word +: 8] = extended_next_character;
		curr_index_in_word = curr_index_in_word + 2'b1;
	end
	
	always @(negedge CHAR_READY) begin
		if (curr_index_in_word == 2'd3) begin
			index = index + 6'b1;
		end
	end
	
	wire [31:0] data_mem_output;
	
	assign curr_character = data_mem_output[choose[1:0] * 8 +: 8];
	
	dmem (.address(REACHED_END ? choose[13:2] : index), .clock(Clk), .data(curr_word), .wren(CHAR_READY && ~REACHED_END), .q(data_mem_output));
	
	output [6:0] debug_output;
	assign debug_output[6] = REACHED_END;
	assign debug_output[5:0] = next_character;
endmodule