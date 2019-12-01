module plotter_machine(clk, move_up, move_down, move_left, move_right, inverse_speed_x, inverse_speed_y, dir_out_x, dir_out_y, step_clk_x, step_clk_y);
	input clk, move_up, move_down, move_left, move_right;
	input [3:0] inverse_speed_x, inverse_speed_y;
	output dir_out_x, dir_out_y, step_clk_x, step_clk_y;
	
	wire enable_x = ~move_left ^ ~move_right;
	wire enable_y = ~move_up ^ ~move_down;
	
	stepper_controller y_stepper(clk, enable_x, inverse_speed_x, step_clk_x);
	stepper_controller x_stepper(clk, enable_y, inverse_speed_y, step_clk_y);
	
	assign dir_out_x = ~move_left;
	assign dir_out_y = ~move_up;
endmodule