module challenge4_top (
	input MAX10_CLK1_50,
	input [1:0] KEY,
	
	output [9:0] LEDR,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4
	);
	
//----------------- declarations -----------------
	wire tick_ms, tick_halfs;
	wire time_out; // from delay mod
	wire en_lfsr;
	wire start_delay;
	wire [13:0] prbs;
	wire [3:0] bcd4, bcd3, bcd2, bcd1, bcd0;
	
// ---------------- modules ----------------------
	// TIMING
	clktick_16 first (MAX10_CLK1_50, 1'b1, 16'd49999, tick_ms); // ticks every milisecond
	clktick_16 second (tick_ms, 1'b1, 16'd499, tick_halfs); // ticks every half sec
	

	fsm controller (tick_ms, tick_halfs, ~KEY[1], time_out, en_lfsr, start_delay, LEDR);
	lfsr rand_seq (tick_ms, en_lfsr, prbs);
	delay del (tick_ms, prbs, start_delay, time_out);
	
	// DISPLAY RAND NUMBERs
	bin2bcd_16 conv ({2'b00, prbs}, bcd0, bcd1, bcd2, bcd3, bcd4);
	
	hex_to_7seg disp0 (HEX0[6:0], bcd0);
	hex_to_7seg disp1 (HEX1[6:0], bcd1);
	hex_to_7seg disp2 (HEX2[6:0], bcd2);
	hex_to_7seg disp3 (HEX3[6:0], bcd3);
	hex_to_7seg disp4 (HEX4[6:0], bcd4);
	
	
	
	assign HEX0[7] = 1'b1;
	assign HEX1[7] = 1'b1;
	assign HEX2[7] = 1'b1;
	assign HEX3[7] = 1'b0;
	assign HEX4[7] = 1'b1;
	
	
endmodule