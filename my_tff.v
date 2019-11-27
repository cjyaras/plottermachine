module my_tff(clk, rstn, t, q);

	input clk, rstn, t;
	output q;
	
	reg q;
	
	always @(posedge clk) begin
		if (!rstn)
			q <= 0;
		else
			if (t)
				q <= ~q;
			else
				q <= q;
	end
endmodule