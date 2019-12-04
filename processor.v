/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
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
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 
	 
    /* YOUR CODE STARTS HERE */
	 
	 assign address_imem = curr_pc[11:0];
	 assign address_dmem = curr_XM_O[11:0];
	 
	 
	 /* Wire declarations */
	 
	 wire pc_enable;
	 wire [31:0] next_pc, curr_pc, pc_plus_1;
	 
	 wire [31:0] FD_pc_plus_1;
	 wire [31:0] next_FD_instruction;
	 wire [31:0] curr_FD_instruction;
	 wire FD_enable;
	 
	 wire [31:0] DX_pc_plus_1;
	 wire [31:0] next_DX_instruction;
	 wire [31:0] curr_DX_instruction;
	 wire DX_enable;
	 wire [31:0] next_DX_A, curr_DX_A;
	 wire [31:0] next_DX_B, curr_DX_B;
	 
	 wire [31:0] XM_pc_plus_1;
	 wire [31:0] next_XM_instruction;
	 wire [31:0] curr_XM_instruction;
	 wire XM_enable;
	 wire [31:0] next_XM_O, curr_XM_O;
	 wire [31:0] next_XM_B, curr_XM_B;
	 
	 wire [31:0] MW_pc_plus_1;
	 wire [31:0] next_MW_instruction;
	 wire [31:0] curr_MW_instruction;
	 wire MW_enable;
	 wire [31:0] next_MW_O, curr_MW_O;
	 wire [31:0] next_MW_D, curr_MW_D;
	 wire [31:0] next_ra, curr_ra;
	 wire ra_enable;
	 
	 wire [4:0] alu_op, alu_shift;
	 wire [31:0] alu_A, alu_B, alu_out;
	 wire ovf;
	 wire [31:0] mult_out;
	 wire doing_mult_at_DX;
	 wire read_after_lw;
	 
	 wire greater_than, not_equal;
	 
	 wire flush_FD, flush_DX, flush_XM;
	 
	 /*-------------------------------------------------------------*/
	 
	 /* Program Counter */
	 
	 register PC(.clk(clock), .rst(reset), .ena(pc_enable), .next(next_pc), .curr(curr_pc));
	 
	 
	 /* Pipeline Latches */
	 
	 FD_latch (.reset(reset), .clk(clock), .enable(FD_enable), .next_pc_plus_1(flush_FD ? 32'd0 : pc_plus_1), .curr_pc_plus_1(FD_pc_plus_1), .next_instruction(next_FD_instruction), .curr_instruction(curr_FD_instruction));
	 
	 
	 
	 DX_latch (.reset(reset), .clk(clock), .enable(DX_enable), .next_pc_plus_1(flush_DX || read_after_lw ? 32'd0 : FD_pc_plus_1), .curr_pc_plus_1(DX_pc_plus_1), .next_instruction(next_DX_instruction), .curr_instruction(curr_DX_instruction), 
	 .next_A(flush_DX || read_after_lw ? 32'd0 : next_DX_A), .curr_A(curr_DX_A), .next_B(flush_DX || read_after_lw ? 32'd0 : next_DX_B), .curr_B(curr_DX_B));
	 
	 
	 
	 XM_latch (.reset(reset), .clk(clock), .enable(XM_enable), .next_pc_plus_1(flush_XM ? 32'd0 : DX_pc_plus_1), .curr_pc_plus_1(XM_pc_plus_1), .next_instruction(next_XM_instruction), .curr_instruction(curr_XM_instruction), 
	 .next_O(flush_XM ? 32'd0 : next_XM_O), .curr_O(curr_XM_O), .next_B(flush_XM ? 32'd0 : next_XM_B), .curr_B(curr_XM_B));
	 
	 
	 
	 MW_latch (.reset(reset), .clk(clock), .enable(MW_enable), .next_pc_plus_1(XM_pc_plus_1), .curr_pc_plus_1(MW_pc_plus_1), .next_instruction(next_MW_instruction), .curr_instruction(curr_MW_instruction), 
	 .next_O(next_MW_O), .curr_O(curr_MW_O), .next_D(next_MW_D), .curr_D(curr_MW_D), .ra_enable(ra_enable), .next_ra(next_ra), .curr_ra(curr_ra));
	 
	 /* Decoders */
	 
	 reg_file_decoder(.FD_instruction(curr_FD_instruction), .MW_instruction(curr_MW_instruction), .MW_O(curr_MW_O), 
	 .MW_D(curr_MW_D), .MW_pc_plus_1(MW_pc_plus_1), .ctrl_readRegA(ctrl_readRegA), .ctrl_readRegB(ctrl_readRegB), 
	 .ctrl_writeReg(ctrl_writeReg), .data_writeReg(data_writeReg), .ctrl_writeEnable(ctrl_writeEnable));
	 
	 
	 
	 WD_bypass(.ctrl_writeEnable(ctrl_writeEnable), .ctrl_writeReg(ctrl_writeReg), .ctrl_readRegA(ctrl_readRegA), 
	 .ctrl_readRegB(ctrl_readRegB), .data_writeReg(data_writeReg), .data_readRegA(data_readRegA), 
	 .data_readRegB(data_readRegB), .next_DX_A(next_DX_A), .next_DX_B(next_DX_B));
	 
	 
	 
	 
	 alu_decoder(.DX_instruction(curr_DX_instruction), .DX_A(curr_DX_A), .DX_B(curr_DX_B), .XM_pc_plus_1(XM_pc_plus_1), .XM_instruction(curr_XM_instruction), 
	 .XM_O(curr_XM_O), .MW_instruction(curr_MW_instruction), .MW_O(curr_MW_O), .MW_D(curr_MW_D), .alu_op(alu_op), 
	 .alu_shift(alu_shift), .alu_A(alu_A), .alu_B(alu_B), .next_XM_B(next_XM_B));
	 
	 
	 
	 
	 control_decoder(.curr_pc_plus_1(pc_plus_1), .DX_pc_plus_1(DX_pc_plus_1), .XM_pc_plus_1(XM_pc_plus_1), .FD_instruction(curr_FD_instruction), 
	 .DX_instruction(curr_DX_instruction), .XM_instruction(curr_XM_instruction), .MW_instruction(curr_MW_instruction), 
	 .not_equal(not_equal), .greater_than(greater_than), .MW_ra(curr_ra), .alu_out(alu_out), .XM_O(curr_XM_O), .data_writeReg(data_writeReg), 
	 .next_DX_B(next_DX_B), .next_pc(next_pc), .flush_FD(flush_FD), .flush_DX(flush_DX), .flush_XM(flush_XM));
	 
	 
	 
	 
	 
	 stall_logic(.ovf(ovf), .curr_pc_instruction(q_imem), .curr_FD_instruction(curr_FD_instruction), .curr_DX_instruction(curr_DX_instruction), 
	 .curr_XM_instruction(curr_XM_instruction), .read_after_lw(read_after_lw), .flush_FD(flush_FD), .flush_DX(flush_DX), .flush_XM(flush_XM), 
	 .next_FD_instruction(next_FD_instruction), .next_DX_instruction(next_DX_instruction), .next_XM_instruction(next_XM_instruction), 
	 .next_MW_instruction(next_MW_instruction), .pc_enable(pc_enable), .FD_enable(FD_enable), .DX_enable(DX_enable), .XM_enable(XM_enable), .MW_enable(MW_enable));
	 
	 
	 
	 
	 
	 data_mem_decoder(.XM_instruction(curr_XM_instruction), .MW_instruction(curr_MW_instruction), .XM_B(curr_XM_B), .MW_D(curr_MW_D), .data_mem_D(data), .wren(wren));
	
	 ra_writer(.XM_instruction(curr_XM_instruction), .XM_pc_plus_1(XM_pc_plus_1), .next_MW_D(next_MW_D), .next_MW_O(next_MW_O), .ra_enable(ra_enable), .next_ra(next_ra));
	 
	 /* ALU */
	 
	 alu (.data_operandA(alu_A), .data_operandB(alu_B), .ctrl_ALUopcode(alu_op), .ctrl_shiftamt(alu_shift), .data_result(alu_out), .isNotEqual(not_equal), .isLessThan(greater_than), .overflow(ovf));
	 
	 /* Dedicated arithmetic */
	 
	 add_one pc_adder(curr_pc, pc_plus_1);
	 
	 mult (alu_A, alu_B, mult_out);
	 
	 /* Connections */
	 
	 compare (alu_op, 5'b00110, doing_mult_at_DX);
	 
	 assign next_MW_D = q_dmem;
	 assign next_XM_O = doing_mult_at_DX ? mult_out : alu_out;
	 assign next_MW_O = curr_XM_O;
	 
	 

endmodule
