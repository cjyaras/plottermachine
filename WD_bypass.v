module WD_bypass(ctrl_writeEnable, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB, data_writeReg, data_readRegA, data_readRegB, next_DX_A, next_DX_B);
	input [4:0] ctrl_writeEnable, ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg, data_readRegA, data_readRegB;
	output [31:0] next_DX_A, next_DX_B;
	
	wire A_eq_out, B_eq_out;
	compare (ctrl_readRegA, ctrl_writeReg, A_eq_out);
	compare (ctrl_readRegB, ctrl_writeReg, B_eq_out);
	
	wire A_zero, B_zero;
	compare (ctrl_readRegA, 5'd0, A_zero);
	compare (ctrl_readRegB, 5'd0, B_zero);
	
	assign next_DX_A = A_zero ? 32'd0 : A_eq_out && ctrl_writeEnable ? data_writeReg : data_readRegA;
	assign next_DX_B = B_zero ? 32'd0 : B_eq_out && ctrl_writeEnable ? data_writeReg : data_readRegB;
	
endmodule