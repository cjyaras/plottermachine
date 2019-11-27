module counter(clk, out);
	input clk;
	output [6:0] out;
	
	reg [6:0] cnt;
	
	initial begin
		cnt <= 7'b0;
	end
	
	always @(posedge clk) begin
		cnt <= cnt + 1;
	end
	
	assign out = cnt;
	
//	my_tff tff0(clk, 1, 1, out[0]);
//	my_tff tff1(~out[0], 1, 1, out[1]);
//	my_tff tff2(~out[1], 1, 1, out[2]);
//	my_tff tff3(~out[2], 1, 1, out[3]);
//	my_tff tff4(~out[3], 1, 1, out[4]);
//	my_tff tff5(~out[4], 1, 1, out[5]);
//	my_tff tff6(~out[5], 1, 1, out[6]);
endmodule