module add_one(x, s);
	input [31:0] x;
	output [31:0] s;
	cla_adder (.x(x), .y(32'b1), .c0(0), .s(s));
endmodule