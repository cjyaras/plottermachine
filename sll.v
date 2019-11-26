module sll(shamt, in, out);
	input [4:0] shamt;
	input [31:0] in;
	output [31:0] out;
	wire [31:0] w1, w2, w3, w4, w5, w6, w7, w8, w9;
	
	sll16 firstsll(in, w1);
	mux_2 firstmux(shamt[4], in, w1, w2);
	
	sll8 secondsll(w2, w3);
	mux_2 secondmux(shamt[3], w2, w3, w4);
	
	sll4 thirdsll(w4, w5);
	mux_2 thirdmux(shamt[2], w4, w5, w6);
	
	sll2 fourthsll(w6, w7);
	mux_2 fourthmux(shamt[1], w6, w7, w8);
	
	sll1 fifthsll(w8, w9);
	mux_2 fifthmux(shamt[0], w8, w9, out);
	
endmodule
	
	
	