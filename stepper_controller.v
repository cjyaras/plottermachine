module stepper_controller(input clk, input enable, input [31:0] counter_limit, output reg step_clk);
	// Interface between main module and A4988 stepper driver
	// Assume clock runs at 50 MHz
	
	reg [31:0] step_counter;
	
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