module eight_bit_block_adder(x,y,c0,s,P,G,c7_);
	input c0;
	input [7:0] x,y;
	output [7:0] s;
	output P,G;
	output c7_;
	
	wire [7:0] p,g;
	
	wire c1,c2,c3,c4,c5,c6,c7;
	
	wire w11;
	wire w21,w22;
	wire w31,w32,w33;
	wire w41,w42,w43,w44;
	wire w51,w52,w53,w54,w55;
	wire w61,w62,w63,w64,w65,w66;
	wire w71,w72,w73,w74,w75,w76,w77;
	wire w81,w82,w83,w84,w85,w86,w87;
	
	and (g[0],x[0],y[0]);
	and (g[1],x[1],y[1]);
	and (g[2],x[2],y[2]);
	and (g[3],x[3],y[3]);
	and (g[4],x[4],y[4]);
	and (g[5],x[5],y[5]);
	and (g[6],x[6],y[6]);
	and (g[7],x[7],y[7]);
	
	or (p[0],x[0],y[0]);
	or (p[1],x[1],y[1]);
	or (p[2],x[2],y[2]);
	or (p[3],x[3],y[3]);
	or (p[4],x[4],y[4]);
	or (p[5],x[5],y[5]);
	or (p[6],x[6],y[6]);
	or (p[7],x[7],y[7]);
	
	and (w11,p[0],c0);
	or (c1,g[0],w11);
	
	and (w21,p[1],g[0]);
	and (w22,p[0],p[1],c0);
	or (c2,g[1],w21,w22);
	
	and (w31,p[2],g[1]);
	and (w32,p[2],p[1],g[0]);
	and (w33,p[2],p[1],p[0],c0);
	or (c3,g[2],w31,w32,w33);
	
	and (w41,p[3],g[2]);
	and (w42,p[3],p[2],g[1]);
	and (w43,p[3],p[2],p[1],g[0]);
	and (w44,p[3],p[2],p[1],p[0],c0);
	or (c4,g[3],w41,w42,w43,w44);
	
	and (w51,p[4],g[3]);
	and (w52,p[4],p[3],g[2]);
	and (w53,p[4],p[3],p[2],g[1]);
	and (w54,p[4],p[3],p[2],p[1],g[0]);
	and (w55,p[4],p[3],p[2],p[1],p[0],c0);
	or (c5,g[4],w51,w52,w53,w54,w55);
	
	and (w61,p[5],g[4]);
	and (w62,p[5],p[4],g[3]);
	and (w63,p[5],p[4],p[3],g[2]);
	and (w64,p[5],p[4],p[3],p[2],g[1]);
	and (w65,p[5],p[4],p[3],p[2],p[1],g[0]);
	and (w66,p[5],p[4],p[3],p[2],p[1],p[0],c0);
	or (c6,g[5],w61,w62,w63,w64,w65,w66);
	
	and (w71,p[6],g[5]);
	and (w72,p[6],p[5],g[4]);
	and (w73,p[6],p[5],p[4],g[3]);
	and (w74,p[6],p[5],p[4],p[3],g[2]);
	and (w75,p[6],p[5],p[4],p[3],p[2],g[1]);
	and (w76,p[6],p[5],p[4],p[3],p[2],p[1],g[0]);
	and (w77,p[6],p[5],p[4],p[3],p[2],p[1],p[0],c0);
	or (c7,g[6],w71,w72,w73,w74,w75,w76,w77);
	
	and (w81,p[7],g[6]);
	and (w82,p[7],p[6],g[5]);
	and (w83,p[7],p[6],p[5],g[4]);
	and (w84,p[7],p[6],p[5],p[4],g[3]);
	and (w85,p[7],p[6],p[5],p[4],p[3],g[2]);
	and (w86,p[7],p[6],p[5],p[4],p[3],p[2],g[1]);
	and (w87,p[7],p[6],p[5],p[4],p[3],p[2],p[1],g[0]);
	or (G,g[7],w81,w82,w83,w84,w85,w86,w87);
	
	and (P,p[7],p[6],p[5],p[4],p[3],p[2],p[1],p[0]);
	
	single_bit_adder bit0(x[0],y[0],c0,s[0]);
	single_bit_adder bit1(x[1],y[1],c1,s[1]);
	single_bit_adder bit2(x[2],y[2],c2,s[2]);
	single_bit_adder bit3(x[3],y[3],c3,s[3]);
	single_bit_adder bit4(x[4],y[4],c4,s[4]);
	single_bit_adder bit5(x[5],y[5],c5,s[5]);
	single_bit_adder bit6(x[6],y[6],c6,s[6]);
	single_bit_adder bit7(x[7],y[7],c7,s[7]);
	
	assign c7_ = c7;
	
endmodule