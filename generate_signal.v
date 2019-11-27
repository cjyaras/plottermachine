module generate_signal(clk, out, data, led);
	input clk, data;
	output out, led;
	
	reg state;
	reg [31:0] counter;
	
	initial begin
		state = 1'b0;
		counter = 32'b0;
	end
	
	always @(posedge clk) begin
		if (counter == 32'd50000000) begin
			state <= ~state;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	
	assign led = data;
	
	assign out = state;
endmodule