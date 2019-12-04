module uart_wrapper(input clk, input rx, input wren, input [11:0] address_dmem, input [31:0] data, output [31:0] q_dmem, output reg done);
	
	wire data_ready;
	wire [7:0] uart_q;
	
	reg [11:0] index;
	
	initial begin
		done <= 0;
		index <= 12'b0;
		delay <= 8'b0;
	end
	
	reg [7:0] delay;

	always @(posedge data_ready) begin
		index <= (uart_q == 8'd10) ? 12'b0 : index + 1;
		if (uart_q == 8'd11)
			delay <= 1;
		else if (uart_q == 8'd10)
			delay <= 0;
	end
	
	always @(posedge clk) begin
			if (delay == 1)
				done <= 1;
			else if (delay == 0)
				done <= 0;
	end
	
	uart_rx receiver(clk, rx, data_ready, uart_q);
	dmem my_dmem(done ? address_dmem : index, ~clk, done ? q_dmem : {24'b0, uart_q}, done ? wren : data_ready, q_dmem);
	
endmodule