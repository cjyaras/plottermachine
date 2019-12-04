module regfile(
	clock, ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA,
	data_readRegB, reg1, reg2, reg3, reg5, reg6, reg8, reg9, reg10, reg11, reg17
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;
	output [31:0] data_readRegA, data_readRegB;

	reg[31:0] registers[31:0]; 
	
	always @(posedge clock or posedge ctrl_reset)
	begin
		if(ctrl_reset)
			begin
				integer i;
				for(i = 0; i < 32; i = i + 1)
					begin
						registers[i] = 32'd0;
					end
			end
		else
			if(ctrl_writeEnable && ctrl_writeReg != 5'd0)
				registers[ctrl_writeReg] = data_writeReg;
	end
	
	assign data_readRegA = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegA) ? 32'bz : registers[ctrl_readRegA];
	assign data_readRegB = ctrl_writeEnable && (ctrl_writeReg == ctrl_readRegB) ? 32'bz : registers[ctrl_readRegB];
	
	// Expose more registers here
	
	output [31:0] reg1, reg2, reg3, reg5, reg6, reg8, reg9, reg10, reg11, reg17;
	
	assign reg1 = registers[1];
	assign reg2 = registers[2];
	assign reg3 = registers[3];
	
	assign reg5 = registers[5];
	assign reg6 = registers[6];
	
	assign reg8 = registers[8];
	assign reg9 = registers[9];
	assign reg10 = registers[10];
	assign reg11 = registers[11];
	
	assign reg17 = registers[17];
	
endmodule
