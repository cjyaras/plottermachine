module sra4(in, out);
	input [31:0] in;
	output [31:0] out;
	
	assign out[27:0] = in[31:4];
	assign out[31] = in[31];
	assign out[30] = in[31];
	assign out[29] = in[31];
	assign out[28] = in[31];

endmodule