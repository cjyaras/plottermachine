module mux_4(select, in0, in1, in2, in3, out);
	input [1:0] select;
	input [31:0] in0, in1, in2, in3;
	output [31:0] out;
	wire [31:0] w1, w2;
	
	mux_2 lowermux(select[0], in0, in1, w1);
	mux_2 uppermux(select[0], in2, in3, w2);
	mux_2 finalmux(select[1], w1, w2, out);
endmodule