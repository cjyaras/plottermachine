module servo_controller(input clk, input [31:0] counter_limit, output reg pwm);
	// duty width is in ms
	
	reg [31:0] counter;
	
	initial begin
		pwm <= 1;
		counter <= 32'b0;
	end
	
	always @(posedge clk) begin
		if (counter > 32'd1000000) begin
			pwm <= 1;
			counter <= 32'b0;
		end else if (counter > counter_limit) begin
			pwm <= 0;
		end
	end
	
	
endmodule