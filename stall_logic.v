module stall_logic(ovf, curr_pc_instruction, curr_FD_instruction, curr_DX_instruction, curr_XM_instruction, read_after_lw, flush_FD, flush_DX, flush_XM, next_FD_instruction, next_DX_instruction, next_XM_instruction, next_MW_instruction, pc_enable, FD_enable, DX_enable, XM_enable, MW_enable);
	input ovf;
	input [31:0] curr_pc_instruction, curr_FD_instruction, curr_DX_instruction, curr_XM_instruction;
	input flush_FD, flush_DX, flush_XM;
	output [31:0] next_FD_instruction, next_DX_instruction, next_XM_instruction, next_MW_instruction;
	output pc_enable, FD_enable, DX_enable, XM_enable, MW_enable;
	output read_after_lw;
	
	wire [31:0] nop;
	assign nop = 32'd0;
	
	wire [4:0] alu_op;
	assign alu_op = curr_DX_instruction[6:2];
	
	wire add, sub;
	compare (alu_op, 5'b00000, add);
	compare (alu_op, 5'b00001, sub);
	
	
	wire [26:0] setx_T;
	assign setx_T = addi_DX ? 27'd2 : R_type_alu_DX && add ? 27'd1 : R_type_alu_DX && sub ? 27'd3 : 27'd0;
	
	wire [31:0] setx;
	assign setx[31:27] = 5'b10101;
	assign setx[26:0] = setx_T;
	
	wire R_type_alu_FD, addi_FD, sw_FD, lw_FD, j_FD, bne_FD, jal_FD, jr_FD, blt_FD, bex_FD, setx_FD;
	decode_opcode (curr_FD_instruction[31:27], R_type_alu_FD, addi_FD, sw_FD, lw_FD, j_FD, bne_FD, jal_FD, jr_FD, blt_FD, bex_FD, setx_FD);
	
	wire DXrd_eq_FDrs, DXrd_eq_FDrt, DXrd_eq_FDrd;
	compare (curr_DX_instruction[26:22], curr_FD_instruction[21:17], DXrd_eq_FDrs);
	compare (curr_DX_instruction[26:22], curr_FD_instruction[16:12], DXrd_eq_FDrt);
	compare (curr_DX_instruction[26:22], curr_FD_instruction[26:22], DXrd_eq_FDrd);
	
	assign read_after_lw	= lw_DX && ((R_type_alu_FD && (DXrd_eq_FDrs || DXrd_eq_FDrt)) || ((addi_FD || lw_FD || sw_FD) && (DXrd_eq_FDrs)) || ((bne_FD || blt_FD) && (DXrd_eq_FDrs || DXrd_eq_FDrd)));
	
	assign pc_enable = ~read_after_lw; 
	assign FD_enable = pc_enable;
	
	assign DX_enable = 1'b1;
	assign XM_enable = 1'b1;
	assign MW_enable = 1'b1;
	
	wire R_type_alu_DX, addi_DX, sw_DX, lw_DX, j_DX, bne_DX, jal_DX, jr_DX, blt_DX, bex_DX, setx_DX;
	decode_opcode (curr_DX_instruction[31:27], R_type_alu_DX, addi_DX, sw_DX, lw_DX, j_DX, bne_DX, jal_DX, jr_DX, blt_DX, bex_DX, setx_DX);
	
	assign next_FD_instruction = flush_FD ? nop : curr_pc_instruction;
	assign next_DX_instruction = flush_DX || read_after_lw ? nop : curr_FD_instruction;
	// When ovf occurs, replace next XM with setx
	assign next_XM_instruction = flush_XM ? nop : ovf && (R_type_alu_DX || addi_DX) ? setx : curr_DX_instruction;
	assign next_MW_instruction = curr_XM_instruction;

endmodule