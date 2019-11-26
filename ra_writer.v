module ra_writer(XM_instruction, XM_pc_plus_1, next_MW_D, next_MW_O, ra_enable, next_ra);
	input [31:0] XM_instruction, XM_pc_plus_1, next_MW_D, next_MW_O;
	output ra_enable;
	output [31:0] next_ra;
	
	wire R_type_alu_XM, addi_XM, sw_XM, lw_XM, j_XM, bne_XM, jal_XM, jr_XM, blt_XM, bex_XM, setx_XM;
	decode_opcode (XM_instruction[31:27], R_type_alu_XM, addi_XM, sw_XM, lw_XM, j_XM, bne_XM, jal_XM, jr_XM, blt_XM, bex_XM, setx_XM);
	
	assign next_ra = jal_XM ? XM_pc_plus_1 : lw_XM ? next_MW_D : next_MW_O;
	
	wire rd_is_ra;	
	
	compare (XM_instruction[26:22], 5'b11111, rd_is_ra); 
	
	assign ra_enable = (rd_is_ra && (R_type_alu_XM || addi_XM || lw_XM)) || jal_XM;
	
endmodule
