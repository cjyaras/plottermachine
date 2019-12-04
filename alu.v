module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	
	wire [31:0] w0,w1,w2,w3,w4,w5,w6,w7;
	wire [31:0] not_data_operandB;
	//wire overflow_add,overflow_sub;
	
	cla_adder my_add_sub(data_operandA,
								ctrl_ALUopcode[0] ? not_data_operandB : data_operandB,
								ctrl_ALUopcode[0],
								w0,
								overflow);
	assign w1 = w0;
								
	
	//cla_adder my_add(data_operandA,data_operandB,0,w0,overflow_add);
	not_gate my_not(data_operandB,not_data_operandB);
	//cla_adder my_sub(data_operandA,not_data_operandB,1,w1,overflow_sub);
	
	and_gate my_and(data_operandA,data_operandB,w2);
	or_gate my_or(data_operandA,data_operandB,w3);
	
	sll my_sll(ctrl_shiftamt,data_operandA,w4);
	sra my_sra(ctrl_shiftamt,data_operandA,w5);
	
	mux_8 alu_select(ctrl_ALUopcode[2:0],w0,w1,w2,w3,w4,w5,w6,w7,data_result);
	//assign overflow = ctrl_ALUopcode[0] ? overflow_sub : overflow_add;
	or (isNotEqual,w1[0],w1[1],w1[2],w1[3],w1[4],w1[5],w1[6],w1[7],w1[8],
						w1[9],w1[10],w1[11],w1[12],w1[13],w1[14],w1[15],w1[16],
						w1[17],w1[18],w1[19],w1[20],w1[21],w1[22],w1[23],w1[24],
						w1[25],w1[26],w1[27],w1[28],w1[29],w1[30],w1[31]);
	
	wire a0,a1,a2;
	not (a0,data_operandB[31]);
	and (a1,data_operandA[31],a0);
	//and (a2,overflow_sub,a1);
	and (a2,overflow,a1);
	
	wire a3,a4;
	//not (a3, overflow_sub);
	not (a3, overflow);
	and (a4,w1[31],a3);
	
	or(isLessThan,a2,a4);

endmodule
