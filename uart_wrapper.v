module uart_wrapper(input clk, input rx, input [3:0] select, output [7:0] dmem_q, output reg done, output reg [11:0] index);
	
	wire data_ready;
	wire [7:0] uart_q;
	
	initial begin
		done <= 0;
		index <= 12'b0;
		delay <= 8'b0;
	end
	
	reg [7:0] delay;

	always @(posedge data_ready) begin
		index <= (uart_q == 8'd2) ? 12'b0 : index + 1;
		if (uart_q == 8'd4)
			delay <= 1;
		else if (uart_q == 8'd2)
			delay <= 0;
	end
	
	always @(posedge clk) begin
			if (delay == 1)
				done <= 1;
			else if (delay == 0)
				done <= 0;
	end
		
	
	wire [31:0] dmem_output;
	
	assign dmem_q = dmem_output[7:0];
	
	uart_rx receiver(clk, rx, data_ready, uart_q);
	dmem my_dmem(done ? {8'b0, select} : index, ~clk, {24'b0, uart_q}, data_ready, dmem_output);
	
endmodule