module reg_file_decoder(FD_instruction, MW_instruction, MW_O, MW_D, MW_pc_plus_1, ctrl_readRegA, ctrl_readRegB, ctrl_writeReg, data_writeReg, ctrl_writeEnable);

	input [31:0] FD_instruction, MW_instruction, MW_O, MW_D, MW_pc_plus_1;
	output [4:0] ctrl_readRegA, ctrl_readRegB, ctrl_writeReg;
	output [31:0] data_writeReg;
	output ctrl_writeEnable;
	
	wire R_type_alu_FD, addi_FD, sw_FD, lw_FD, j_FD, bne_FD, jal_FD, jr_FD, blt_FD, bex_FD, setx_FD;
	wire R_type_alu_MW, addi_MW, sw_MW, lw_MW, j_MW, bne_MW, jal_MW, jr_MW, blt_MW, bex_MW, setx_MW;
	
	decode_opcode (FD_instruction[31:27], R_type_alu_FD, addi_FD, sw_FD, lw_FD, j_FD, bne_FD, jal_FD, jr_FD, blt_FD, bex_FD, setx_FD);
	decode_opcode (MW_instruction[31:27], R_type_alu_MW, addi_MW, sw_MW, lw_MW, j_MW, bne_MW, jal_MW, jr_MW, blt_MW, bex_MW, setx_MW);
	
	wire [31:0] T_MW;
	assign T_MW[26:0] = MW_instruction[26:0];
	assign T_MW[27] = 1'b0;
	assign T_MW[28] = 1'b0;
	assign T_MW[29] = 1'b0;
	assign T_MW[30] = 1'b0;
	assign T_MW[31] = 1'b0;
	
	
	// reg A is $rs, unless bex ($r30)
	
	assign ctrl_readRegA = bex_FD ? 5'd30 : FD_instruction[21:17];
	
	// reg B is $rt, unless sw ($rd), bne ($rd), jr ($rd), blt ($rd), bex ($r0)
	
	assign ctrl_readRegB = bex_FD ? 5'd0 : (sw_FD || bne_FD || jr_FD || blt_FD) ? FD_instruction[26:22] : FD_instruction[16:12];
	
	// writeReg is $rd (MW), unless jal ($r31) or setx($r30)
	
	assign ctrl_writeReg = setx_MW ? 5'd30 : jal_MW ? 5'd31 : MW_instruction[26:22];
	
	// data_writeReg is O, unless lw (D), jal (PC+1 of MW)
	
	assign data_writeReg = setx_MW ? T_MW : lw_MW ? MW_D : jal_MW ? MW_pc_plus_1 : MW_O;
	
	// ctrl_writeEnable is 0, unless R_type_alu, addi, lw, jal, setx
	
	assign ctrl_writeEnable = (R_type_alu_MW || addi_MW || lw_MW || jal_MW || setx_MW) ? 1'b1 : 1'b0;
	
endmodule