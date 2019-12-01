module stepper_controller(clk, enable, inverse_speed, step_clk);
	// Interface between main module and A4988 stepper driver
	// Assume clock runs at 50 MHz
	
	// Speed is in rotations / second
	
	input clk, enable;
	input [3:0] inverse_speed;
	reg step_clk;
	output step_clk;
	
	reg [31:0] step_counter;
	
	wire [31:0] counter_limit;
	assign counter_limit = 32'd125000 * inverse_speed;
	
	initial begin
		step_clk <= 1'b0;
		step_counter <= 32'b0;
	end
	
	always @(posedge clk) begin
		if (enable && counter_limit != 32'b0) begin
			step_counter <= step_counter + 1;
		end
		
		if (step_counter >= counter_limit) begin
			step_clk <= ~step_clk;
			step_counter <= 32'b0;
		end
	end
endmodule