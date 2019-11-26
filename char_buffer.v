module char_buffer(next_character, CHAR_READY, index, curr_character, END_OF_BUFFER);
	input [7:0] next_character;
	input CHAR_READY;
	input [6:0] index;
	output [7:0] curr_character;
	output END_OF_BUFFER;
	
	reg [799:0] buffer;
	reg END_OF_BUFFER;
	reg [6:0] curr_write_location;
	
	assign curr_character = buffer[8*index +: 8];
	
	initial begin
		buffer <= 800'b0;
		END_OF_BUFFER = 1'b0;
	end
	
	always @(posedge CHAR_READY) begin
		if (next_character != 8'b0) begin
			buffer[8*index +: 8] <= next_character;
		end
		
		else begin
			END_OF_BUFFER <= 1;
		end
	end
	
endmodule
