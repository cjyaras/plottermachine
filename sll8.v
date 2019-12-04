module sll8(in, out);
	input [31:0] in;
	output [31:0] out;
	
	assign out[31:8] = in[23:0];
	assign out[7:0] = 0;

endmodule