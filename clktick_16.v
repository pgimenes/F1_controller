module clktick_16 (
	clkin,
	enable,
	N,
	tick
	);
	
	parameter N_BIT = 16;
	
	input clkin;
	input enable;
	input [N_BIT-1:0] N;
	output tick;
	
	initial tick = 1'b0;
	reg [N_BIT-1:0] count;
	reg tick;
	
	always @ (posedge clkin)
		if (enable == 1'b1)
			if (count == 0) begin
				tick <= 1'b1;
				count <= N;
				end
			else begin
				tick <= 1'b0;
				count <= count - 1'b1;
				end
	
endmodule