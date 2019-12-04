module alu_decoder(DX_instruction, DX_A, DX_B, XM_pc_plus_1, XM_instruction, XM_O, MW_instruction, MW_O, MW_D, alu_op, alu_shift, alu_A, alu_B, next_XM_B);
	input [31:0] DX_instruction, DX_A, DX_B;
	input [31:0] XM_pc_plus_1, XM_instruction, XM_O;
	input [31:0] MW_instruction, MW_O, MW_D;
	
	output [4:0] alu_op, alu_shift;
	output [31:0] alu_A, alu_B;
	output [31:0] next_XM_B;
	
	wire R_type_alu_DX, addi_DX, sw_DX, lw_DX, j_DX, bne_DX, jal_DX, jr_DX, blt_DX, bex_DX, setx_DX;
	wire R_type_alu_XM, addi_XM, sw_XM, lw_XM, j_XM, bne_XM, jal_XM, jr_XM, blt_XM, bex_XM, setx_XM;
	wire R_type_alu_MW, addi_MW, sw_MW, lw_MW, j_MW, bne_MW, jal_MW, jr_MW, blt_MW, bex_MW, setx_MW;
	
	wire [31:0] N;
	
	sign_extender(DX_instruction[16:0], N);
	
	decode_opcode (DX_instruction[31:27], R_type_alu_DX, addi_DX, sw_DX, lw_DX, j_DX, bne_DX, jal_DX, jr_DX, blt_DX, bex_DX, setx_DX);
	decode_opcode (XM_instruction[31:27], R_type_alu_XM, addi_XM, sw_XM, lw_XM, j_XM, bne_XM, jal_XM, jr_XM, blt_XM, bex_XM, setx_XM);
	decode_opcode (MW_instruction[31:27], R_type_alu_MW, addi_MW, sw_MW, lw_MW, j_MW, bne_MW, jal_MW, jr_MW, blt_MW, bex_MW, setx_MW);
	
	// alu_op will be from instruction, unless addi (00000), sw (00000), lw (00000), branch (00001)
	
	assign alu_op = (addi_DX || sw_DX || lw_DX) ? 5'b00000 : blt_DX || bne_DX ? 5'b00001 : DX_instruction[6:2];
	
	// alu_shift comes from instruction
	
	assign alu_shift = DX_instruction[11:7];
	
	// alu_A is DX_A, unless we have bypassing from M (then it is XM_O), or otherwise if we have bypassing from W (then it is either MW_O or MW_D depending on instruction)
	
	wire XMrd_eq_DXrs, MWrd_eq_DXrs;
	compare (XM_instruction[26:22], DX_instruction[21:17], XMrd_eq_DXrs);
	compare (MW_instruction[26:22], DX_instruction[21:17], MWrd_eq_DXrs);
	
	wire XMrd_eq_DXrt, MWrd_eq_DXrt;
	compare (XM_instruction[26:22], DX_instruction[16:12], XMrd_eq_DXrt);
	compare (MW_instruction[26:22], DX_instruction[16:12], MWrd_eq_DXrt);
	
	wire XMrd_eq_DXrd, MWrd_eq_DXrd;
	compare (XM_instruction[26:22], DX_instruction[26:22], XMrd_eq_DXrd);
	compare (MW_instruction[26:22], DX_instruction[26:22], MWrd_eq_DXrd);
	
	// Bypassing for r30 only occurs when setx is ahead in pipeline (practically only case)
	
	wire [31:0] T_XM;
	assign T_XM[26:0] = XM_instruction[26:0];
	assign T_XM[27] = 1'b0;
	assign T_XM[28] = 1'b0;
	assign T_XM[29] = 1'b0;
	assign T_XM[30] = 1'b0;
	assign T_XM[31] = 1'b0;
	
	wire [31:0] T_MW;
	assign T_MW[26:0] = MW_instruction[26:0];
	assign T_MW[27] = 1'b0;
	assign T_MW[28] = 1'b0;
	assign T_MW[29] = 1'b0;
	assign T_MW[30] = 1'b0;
	assign T_MW[31] = 1'b0;
	
	// Needed to bypassing from jal only for sw
	wire DXrd_eq_r31;
	
	
	assign alu_A = bex_DX && setx_XM ? T_XM : bex_DX && setx_MW ? T_MW : XMrd_eq_DXrs && (R_type_alu_XM || addi_XM) ? XM_O : MWrd_eq_DXrs && (R_type_alu_MW || addi_MW) ? MW_O : MWrd_eq_DXrs && lw_MW ? MW_D : DX_A;
	
	// alu_B is DX_B, unless same bypassing as above, or unless addi (N), sw (N), lw (N)
	
	assign alu_B = DXrd_eq_r31 && sw_DX && jal_XM ? XM_pc_plus_1 : XMrd_eq_DXrd && (R_type_alu_XM || addi_XM) && (bne_DX || blt_DX) ? XM_O : MWrd_eq_DXrd && (R_type_alu_MW || addi_MW) && (bne_DX || blt_DX) ? MW_O : MWrd_eq_DXrd && lw_MW ? MW_D : (addi_DX || sw_DX || lw_DX) ? N : XMrd_eq_DXrt && (R_type_alu_XM || addi_XM) && R_type_alu_DX ? XM_O : MWrd_eq_DXrt && (R_type_alu_MW || addi_MW) && R_type_alu_DX ? MW_O : MWrd_eq_DXrt && lw_MW && R_type_alu_DX ? MW_D : DX_B;
	
	assign next_XM_B = XMrd_eq_DXrd && (R_type_alu_XM || addi_XM) ? XM_O : MWrd_eq_DXrd && (R_type_alu_MW || addi_MW) ? MW_O : MWrd_eq_DXrd && lw_MW ? MW_D : DX_B;
	
	
endmodule