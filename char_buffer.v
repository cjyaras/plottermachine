module char_buffer(next_char, CHAR_READY, EOF, select, curr_char, debug, index_out);
	input [5:0] next_char;
	input CHAR_READY, EOF;
	input [6:0] select;
	output [5:0] curr_char;
	output [7:0] debug;
	
	reg [599:0] buffer;
	
	wire [6:0] index;
	
	counter (CHAR_READY, index);
	
	output [6:0] index_out;
	assign index_out = index;
	
	assign curr_char = buffer[6*select +: 6];
	
	always @(CHAR_READY) begin
		buffer[6*index +: 6] = next_char;
	end
	
	assign debug[5:0] = next_char;
	assign debug[6] = CHAR_READY;
	assign debug[7] = EOF;
	
endmodule
