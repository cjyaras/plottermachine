module ascii_to_display(clk, in, out);
	input clk;
	input [7:0] in;
	output reg [6:0] out;
	
	always @(posedge clk) begin
		case (in)
			8'd102 : out <= ~7'b1000111; // f (forward)
			8'd114 : out <= ~7'b0000101; // r (right)
			8'd108 : out <= ~7'b0001110; // l (left)
			8'd0   : out <= ~7'h7E; 	  // 0
			8'd1   : out <= ~7'h30;      // 1
			8'd2   : out <= ~7'h6D;      // 2
			8'd3   : out <= ~7'h79;      // 3
			8'd4   : out <= ~7'h33;      // 4
			8'd5   : out <= ~7'h5B;      // 5
			8'd6   : out <= ~7'h5F;      // 6
			8'd7   : out <= ~7'h70;      // 7
			8'd8   : out <= ~7'h7F;      // 8
			8'd9   : out <= ~7'h7B;      // 9
			default : out <= ~7'b1001111; // E
		endcase
	end
endmodule