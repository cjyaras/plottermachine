module register(clk, rst, ena, next, curr);

	input clk, rst, ena;
	input [31:0] next;
	output [31:0] curr;
	
	dffe dff0(.d(next[0]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[0]));
	dffe dff1(.d(next[1]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[1]));
	dffe dff2(.d(next[2]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[2]));
	dffe dff3(.d(next[3]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[3]));
	dffe dff4(.d(next[4]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[4]));
	dffe dff5(.d(next[5]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[5]));
	dffe dff6(.d(next[6]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[6]));
	dffe dff7(.d(next[7]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[7]));
	dffe dff8(.d(next[8]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[8]));
	dffe dff9(.d(next[9]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[9]));
	dffe dff10(.d(next[10]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[10]));
	dffe dff11(.d(next[11]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[11]));
	dffe dff12(.d(next[12]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[12]));
	dffe dff13(.d(next[13]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[13]));
	dffe dff14(.d(next[14]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[14]));
	dffe dff15(.d(next[15]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[15]));
	dffe dff16(.d(next[16]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[16]));
	dffe dff17(.d(next[17]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[17]));
	dffe dff18(.d(next[18]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[18]));
	dffe dff19(.d(next[19]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[19]));
	dffe dff20(.d(next[20]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[20]));
	dffe dff21(.d(next[21]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[21]));
	dffe dff22(.d(next[22]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[22]));
	dffe dff23(.d(next[23]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[23]));
	dffe dff24(.d(next[24]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[24]));
	dffe dff25(.d(next[25]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[25]));
	dffe dff26(.d(next[26]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[26]));
	dffe dff27(.d(next[27]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[27]));
	dffe dff28(.d(next[28]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[28]));
	dffe dff29(.d(next[29]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[29]));
	dffe dff30(.d(next[30]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[30]));
	dffe dff31(.d(next[31]), .clk(clk), .clrn(~rst), .ena(ena), .q(curr[31]));

	
endmodule