module ascii_to_display(clk, in, out);
	input clk;
	input [7:0] in;
	output reg [6:0] out;
	
	always @(posedge clk) begin
		case (in)
			8'd102 : out <= 7'b1000111; // f (forward)
			8'd114 : out <= 7'b0000101; // r (right)
			8'd48  : out <= 7'h7E; 		 // 0
			8'd49  : out <= 7'h30;      // 1
			8'd50  : out <= 7'h6D;      // 2
			8'd51  : out <= 7'h79;      // 3
			8'd52  : out <= 7'h33;      // 4
			8'd53  : out <= 7'h5B;      // 5
			8'd54  : out <= 7'h5F;      // 6
			8'd55  : out <= 7'h70;      // 7
			8'd56  : out <= 7'h7F;      // 8
			8'd57  : out <= 7'h77;      // 9
		endcase
	end
endmodule