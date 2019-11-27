module receive_data(clk, data, select, slow_clk, out, debug, index_out);
	input clk;
	input data;
	input [3:0] select;
	output slow_clk;
	output out;
	output debug;
	output [3:0] index_out;
	
	reg slow_clk;
	reg [31:0] counter;
	
	initial begin
		slow_clk <= 0;
		counter <= 32'b0;
		index <= 12'b0;
	end
	
	always @(posedge clk) begin
		if (counter == 32'd25000000) begin
			slow_clk <= ~slow_clk;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
	
	reg [11:0] index;
	
	reg done;
	
	always @(posedge slow_clk) begin
		index <= index + 1;
		
		if (index > 12) begin
			done <= 1;
		end
	end
	
	wire [31:0] out_full;
	assign out = out_full[0];
	
	dmem(done ? {8'b0, select} : index, ~slow_clk, {31'b0, data}, 1, out_full);
	
	assign debug = data;
	assign index_out = index[3:0];

endmodule