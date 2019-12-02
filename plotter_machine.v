module plotter_machine(input clk, input not_enable, input dir_x_in, input dir_y_in, output step_clk_x, output step_clk_y, output dir_x, output dir_y);
	
	wire [31:0] counter_limit_x = 32'd144337;
	wire [31:0] counter_limit_y = 32'd250000;
	
	assign dir_x = dir_x_in;
	assign dir_y = dir_y_in;
	
	stepper_controller y_stepper(clk, ~not_enable, counter_limit_x, step_clk_x);
	stepper_controller x_stepper(clk, ~not_enable, counter_limit_y, step_clk_y);
	
endmodule