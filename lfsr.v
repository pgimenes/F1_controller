module lfsr (
	clk,
	en,
	prbs
);

parameter BIT_SZ = 6;

//------------------ ports ------------------------
input clk;
input en;
output [13:0] prbs;

//------------------ declarations ----------------
reg [5:0] sreg;
initial sreg = 6'b111111;

wire [5:0] new_val = {sreg[4:0], sreg[5] ^ sreg[1]};

always @ (posedge clk) begin
	if (en == 1)
		sreg <= new_val;
end

assign prbs = sreg * 8'd250 + 14'd250;

endmodule