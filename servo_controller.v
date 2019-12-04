module servo_controller(input clk, input [31:0] counter_limit, output reg pwm);
	
	reg [31:0] counter;
	
	initial begin
		pwm <= 0;
		counter <= 32'b0;
	end
	
	always @(posedge clk) begin
		if (0 <= counter && counter <= counter_limit) begin
			pwm <= 1;
			counter <= counter + 1;
		end else if (counter_limit < counter && counter <= 1000000) begin
			pwm <= 0;
			counter <= counter + 1;
		end else begin
			counter <= 32'b0;
		end
	end
	
	
endmodule