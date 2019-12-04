module decode_opcode(opcode, R_type_alu, addi, sw, lw, j, bne, jal, jr, blt, bex, setx);
	input [4:0] opcode;
	output R_type_alu, addi, sw, lw, j, bne, jal, jr, blt, bex, setx;
	
	assign R_type_alu = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
	assign addi = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];
	assign sw = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && opcode[0];
	assign lw = ~opcode[4] && opcode[3] && ~opcode[2] && ~opcode[1] && ~opcode[0];
	assign j = ~opcode[4] && ~opcode[3] && ~opcode[2] && ~opcode[1] && opcode[0];
	assign bne = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && ~opcode[0];
	assign jal = ~opcode[4] && ~opcode[3] && ~opcode[2] && opcode[1] && opcode[0];
	assign jr = ~opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && ~opcode[0];
	assign blt = ~opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
	assign bex = opcode[4] && ~opcode[3] && opcode[2] && opcode[1] && ~opcode[0];
	assign setx = opcode[4] && ~opcode[3] && opcode[2] && ~opcode[1] && opcode[0];

endmodule