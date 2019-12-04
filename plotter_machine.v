module plotter_machine(input clk, input rx, 
	output [0:6] h3, output [0:6] h2, output [0:6] h1, output [0:6] h0, 
	output reset, output x_step_clk, output x_dir, output y_step_clk, output y_dir, output error, output pwm);

	processor (
    // Control signals
    clk,                            // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                  // I: Data from port B of regfile
	);
	
	wire done;
	assign reset = ~done;
	
	wire [11:0] address_dmem;
   wire [31:0] data;
   wire wren;
   wire [31:0] q_dmem;
	
	uart_wrapper (clk, rx, wren, address_dmem, data, q_dmem, done);
	
	wire [11:0] address_imem;
	wire [31:0] q_imem;
	
	imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clk),                    // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );
	 
	 wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile(
        clk,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  reg1, reg2, reg3, reg5, reg6, reg8, reg9, reg10, reg11, reg17
	);
	
	wire [31:0] reg1, reg2, reg3, reg5, reg6, reg8, reg9, reg10, reg11, reg17;
	
	ascii_to_display hex3(clk, reg8[7:0], h3);
	ascii_to_display hex2(clk, reg9[7:0], h2);
	ascii_to_display hex1(clk, reg10[7:0], h1);
	ascii_to_display hex0(clk, reg11[7:0], h0);
	
	stepper_controller x_stepper(clk, reg3[3] && reg5[0], reg1, x_step_clk);
	stepper_controller y_stepper(clk, reg3[2] && reg5[0], reg2, y_step_clk);
	
	assign x_dir = reg3[1];
	assign y_dir = reg3[0];
	
	assign error = reg17[0];
	
	wire [31:0] counter_limit_up, counter_limit_down;
	
	assign counter_limit_up = 32'd25000;
	assign counter_limit_down = 32'd35000;
	
	servo_controller pen_mover(clk, reg6[0] ? counter_limit_down : counter_limit_up, pwm);
	
	
	
endmodule