module character_reading(clk, EOF, next_character, CHAR_READY, select, curr_character, debug_output, index);

	input clk, EOF, CHAR_READY;
	input [5:0] next_character;
	input [3:0] select;
	output [5:0] curr_character;
	output [7:0] debug_output;
	
	output [11:0] index;
	
	reg [11:0] index;
	
	initial begin
		index = 12'b0;
	end

	always @(negedge CHAR_READY) begin
		index = index + 1b'1;
	end
	
	wire [31:0] dmem_output;
	
	//dmem ({7'b0, select}, clk, {26'b0, next_character}, 1, dmem_output);
	wire [11:0] select_extended;
	assign select_extended[11:4] = 8'b0;
	assign select_extended[3:0] = select;
//	wire [31:0] data;
//	assign data[31:4] = 28'b0;
//	assign data[3:0] = select;

	wire [31:0] data;
	assign data[31:6] = 26'b0;
	assign data[5:0] = next_character;
	
	assign curr_character = dmem_output[5:0];
	assign debug_output[5:0] = next_character;
	assign debug_output[6] = CHAR_READY;
	assign debug_output[7] = EOF;

	dmem (EOF ? select_extended : index, clk, data, CHAR_READY && ~EOF, dmem_output);
	

	
	
//	input clk, REACHED_END;
//	input [5:0] next_character;
//	input CHAR_READY;
//	input [13:0] choose;
//	output [7:0] curr_character;
//	
//	wire [7:0] extended_next_character;
//	assign extended_next_character[7] = 1'b0;
//	assign extended_next_character[6] = 1'b0;
//	assign extended_next_character[5:0] = next_character;
//	
//	reg [11:0] index;
//	reg [31:0] curr_word;
//	reg [2:0] curr_index_in_word;
//	
//	initial begin
//		index = 6'b0;
//		curr_word = 32'b0;
//		curr_index_in_word = 2'b0;
//	end
//	
//	always @(posedge CHAR_READY) begin
//		curr_word[8*curr_index_in_word +: 8] = extended_next_character;
//		curr_index_in_word = curr_index_in_word + 2'b1;
//	end
//	
//	always @(negedge CHAR_READY) begin
//		if (curr_index_in_word == 2'd3) begin
//			index = index + 6'b1;
//		end
//	end
//	
//	wire [31:0] data_mem_output;
//	
//	assign curr_character = data_mem_output[choose[1:0] * 8 +: 8];
//	
//	dmem (.address(REACHED_END ? choose[13:2] : index), .clock(Clk), .data(curr_word), .wren(CHAR_READY && ~REACHED_END), .q(data_mem_output));
//	
//	output [7:0] debug_output;
//	assign debug_output[7] = CHAR_READY;
//	assign debug_output[6] = REACHED_END;
//	assign debug_output[5:0] = next_character;
endmodule