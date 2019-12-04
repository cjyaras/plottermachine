module control_decoder(curr_pc_plus_1, DX_pc_plus_1, XM_pc_plus_1, FD_instruction, DX_instruction, XM_instruction, MW_instruction, not_equal, greater_than, MW_ra, alu_out, XM_O, data_writeReg, next_DX_B, next_pc, flush_FD, flush_DX, flush_XM);

	input [31:0] curr_pc_plus_1, DX_pc_plus_1, XM_pc_plus_1, MW_ra, alu_out, XM_O, data_writeReg, next_DX_B;

	input [31:0] FD_instruction, DX_instruction, XM_instruction, MW_instruction;
	input not_equal, greater_than;
	
	output [31:0] next_pc;
	output flush_FD, flush_DX, flush_XM;

	wire R_type_alu_FD, addi_FD, sw_FD, lw_FD, j_FD, bne_FD, jal_FD, jr_FD, blt_FD, bex_FD, setx_FD;
	decode_opcode (FD_instruction[31:27], R_type_alu_FD, addi_FD, sw_FD, lw_FD, j_FD, bne_FD, jal_FD, jr_FD, blt_FD, bex_FD, setx_FD);
	
	wire R_type_alu_DX, addi_DX, sw_DX, lw_DX, j_DX, bne_DX, jal_DX, jr_DX, blt_DX, bex_DX, setx_DX;
	decode_opcode (DX_instruction[31:27], R_type_alu_DX, addi_DX, sw_DX, lw_DX, j_DX, bne_DX, jal_DX, jr_DX, blt_DX, bex_DX, setx_DX);
	
	wire R_type_alu_XM, addi_XM, sw_XM, lw_XM, j_XM, bne_XM, jal_XM, jr_XM, blt_XM, bex_XM, setx_XM;
	decode_opcode (XM_instruction[31:27], R_type_alu_XM, addi_XM, sw_XM, lw_XM, j_XM, bne_XM, jal_XM, jr_XM, blt_XM, bex_XM, setx_XM);
	
	wire R_type_alu_MW, addi_MW, sw_MW, lw_MW, j_MW, bne_MW, jal_MW, jr_MW, blt_MW, bex_MW, setx_MW;
	decode_opcode (MW_instruction[31:27], R_type_alu_MW, addi_MW, sw_MW, lw_MW, j_MW, bne_MW, jal_MW, jr_MW, blt_MW, bex_MW, setx_MW);
	
	wire less_than;
	assign less_than = not_equal && !greater_than;
	
	wire [31:0] T_FD;
	assign T_FD[26:0] = FD_instruction[26:0];
	assign T_FD[27] = 1'b0;
	assign T_FD[28] = 1'b0;
	assign T_FD[29] = 1'b0;
	assign T_FD[30] = 1'b0;
	assign T_FD[31] = 1'b0;
	
	wire [31:0] T_DX;
	assign T_DX[26:0] = DX_instruction[26:0];
	assign T_DX[27] = 1'b0;
	assign T_DX[28] = 1'b0;
	assign T_DX[29] = 1'b0;
	assign T_DX[30] = 1'b0;
	assign T_DX[31] = 1'b0;
	
	wire [31:0] N_DX;
	sign_extender (DX_instruction[16:0], N_DX);
	
	wire branch_taken_DX;
	assign branch_taken_DX = (bne_DX && not_equal) || (blt_DX && less_than);
	
	wire [31:0] DX_pc_plus_1_plus_N;
	cla_adder (.x(DX_pc_plus_1), .y(N_DX), .c0(0), .s(DX_pc_plus_1_plus_N));	
	
	wire DX_writes_to_r31, XM_writes_to_r31, MW_writes_to_r31;
	compare (DX_instruction[26:22], 5'd31, DX_writes_to_r31);
	compare (XM_instruction[26:22], 5'd31, XM_writes_to_r31);
	compare (MW_instruction[26:22], 5'd31, MW_writes_to_r31);
	
	wire [31:0] correct_ra_value;
	
	// Check each stage of pipeline starting from execute stage for new value of r31
	
	assign correct_ra_value = ((R_type_alu_DX || addi_DX) && DX_writes_to_r31) ? alu_out : jal_DX ? DX_pc_plus_1 : ((R_type_alu_XM || addi_XM) && XM_writes_to_r31) ? XM_O : jal_XM ? XM_pc_plus_1 : ((R_type_alu_MW || addi_MW || lw_MW) && MW_writes_to_r31) ? data_writeReg : next_DX_B; 
	
	wire lw_DX_rd_eq_jr_FD_rd;
	compare (DX_instruction[26:22], FD_instruction[26:22], lw_DX_rd_eq_jr_FD_rd);
	
	wire lw_XM_rd_eq_jr_FD_rd;
	compare (XM_instruction[26:22], FD_instruction[26:22], lw_XM_rd_eq_jr_FD_rd);
	
	assign next_pc = jr_XM ? MW_ra : bex_DX && not_equal ? T_DX : branch_taken_DX ? DX_pc_plus_1_plus_N : j_FD || jal_FD ? T_FD : jr_FD && !(lw_DX_rd_eq_jr_FD_rd && lw_DX) && !(lw_XM_rd_eq_jr_FD_rd && lw_XM) ? correct_ra_value : curr_pc_plus_1;
	
	// Need to flush FD on all jumps at decode, branches (if taken) at execute and jr at memory
	assign flush_FD = j_FD || jal_FD || (jr_FD && !(lw_DX_rd_eq_jr_FD_rd && lw_DX) && !(lw_XM_rd_eq_jr_FD_rd && lw_XM)) || branch_taken_DX || jr_XM || (bex_DX && not_equal);
	
	// Need to flush DX if jr is done at either decode (to not jump again) or memory, or branch is taken at execute
	assign flush_DX = (jr_FD && !(lw_DX_rd_eq_jr_FD_rd && lw_DX) && !(lw_XM_rd_eq_jr_FD_rd && lw_XM)) || jr_XM || branch_taken_DX || (bex_DX && not_equal);
	
	// Need to flush XM if jr is done at memory
	assign flush_XM = jr_XM;

endmodule