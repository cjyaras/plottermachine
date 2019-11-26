module data_mem_decoder(XM_instruction, MW_instruction, XM_B, MW_D, data_mem_D, wren);
	input [31:0] XM_instruction, MW_instruction, XM_B, MW_D;
	output [31:0] data_mem_D;
	output wren;
	
	// write enable only when sw is on
	assign wren = !XM_instruction[31] && !XM_instruction[30] && XM_instruction[29] && XM_instruction[28] && XM_instruction[27];
	
	// if XM is sw and MW is lw, then bypass MW_D, otherwise pass XM_B
	
	wire rds_equal;
	
	compare (XM_instruction[26:22], MW_instruction[26:22], rds_equal);
	
	assign data_mem_D = (!XM_instruction[31] && !XM_instruction[30] && XM_instruction[29] && XM_instruction[28] && XM_instruction[27]) && (!MW_instruction[31] && MW_instruction[30] && !MW_instruction[29] && !MW_instruction[28] && !MW_instruction[27]) && rds_equal ? MW_D : XM_B;

endmodule