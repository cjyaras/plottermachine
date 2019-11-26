module single_bit_adder(x,y,c,s);
	input x,y,c;
	output s;
	
	xor xor1(s,x,y,c);
endmodule