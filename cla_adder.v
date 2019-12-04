module cla_adder(x,y,c0,s,ovf);
	input [31:0] x,y;
	input c0;
	output [31:0] s;
	output ovf;
	
	wire w11;
	wire w21,w22;
	wire w31,w32,w33;
	wire w41,w42,w43,w44;
	
	wire c8,c16,c24,c32;
	wire [3:0] prevc;
	wire P0,P1,P2,P3;
	wire G0,G1,G2,G3;

	eight_bit_block_adder block0(x[7:0],y[7:0],c0,s[7:0],P0,G0,prevc[0]);
	eight_bit_block_adder block1(x[15:8],y[15:8],c8,s[15:8],P1,G1,prevc[1]);
	eight_bit_block_adder block2(x[23:16],y[23:16],c16,s[23:16],P2,G2,prevc[2]);
	eight_bit_block_adder block3(x[31:24],y[31:24],c24,s[31:24],P3,G3,prevc[3]);
	
	and (w11,P0,c0);
	or (c8,G0,w11);
	
	and (w21,P1,G0);
	and (w22,P1,P0,c0);
	or (c16,G1,w21,w22);
	
	and (w31,P2,G1);
	and (w32,P2,P1,G0);
	and (w33,P2,P1,P0,c0);
	or (c24,G2,w31,w32,w33);
	
	and (w41,P3,G2);
	and (w42,P3,P2,G1);
	and (w43,P3,P2,P1,G0);
	and (w44,P3,P2,P1,P0,c0);
	or (c32,G3,w41,w42,w43,w44);
	
	xor (ovf,prevc[3],c32);
	
	
endmodule