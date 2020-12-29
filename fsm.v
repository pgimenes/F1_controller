module fsm (
	clk,
	tick,
	trigger,
	time_out,
	en_lfsr,
	start_delay,
	ledr
);

// ----------- ports ----------------------
input clk, tick, trigger, time_out;
output en_lfsr, start_delay;
output [9:0] ledr;

//------------ declarations ----------------
reg [3:0] state;
parameter IDLE = 4'b0000, 
START = 4'b0001,
L0 = 4'b0010,
L1 = 4'b0011,
L2 = 4'b0100,
L3 = 4'b0101,
L4 = 4'b0110,
L5 = 4'b0111,
L6 = 4'b1000,
L7 = 4'b1001,
L8 = 4'b1010,
L9 = 4'b1011,

DELAY = 4'b1100,
RACE = 4'b1101;


initial state = IDLE;

reg [9:0] ledr;
initial ledr = 10'b0000000000;

reg en_lfsr, start_delay; // these get assigned within an always block
initial en_lfsr = 1'b0;
initial start_delay = 1'b0;

//------------ FSM -------------------------

// state transitions
always @ (posedge clk) begin
	case (state)
		IDLE: if (trigger == 1'b1) state <= START;
		START: if (tick == 1'b1) state <= L0;
		L0: if (tick == 1'b1) state <= L1;
		L1: if (tick == 1'b1) state <= L2;
		L2: if (tick == 1'b1) state <= L3;
		L3: if (tick == 1'b1) state <= L4;
		L4: if (tick == 1'b1) state <= L5;
		L5: if (tick == 1'b1) state <= L6;
		L6: if (tick == 1'b1) state <= L7;
		L7: if (tick == 1'b1) state <= L8;
		L8: if (tick == 1'b1) state <= L9;
		L9: if (tick == 1'b1) state <= DELAY;
		DELAY: if (time_out == 1'b1) state <= RACE;
		RACE: if (trigger == 1'b1) state <= START;
		default: state <= IDLE;
	endcase
end

// shift register embedded in 'DELAY' state to light LED's
/*
always @ (posedge tick) begin
	if (state == FLICK)
		if (ledr == 10'b0000000000)
			ledr = 10'b1000000000;
		else
			ledr = {ledr[9], ledr[9:1]}; // arithmetic right shift
	if (state == RACE)
		ledr = 10'b0000000000;
end
*/

// corresponding outputs to each state
always @ (*) begin	
	case (state)
		IDLE: begin
			ledr = 10'b0000000000;
			en_lfsr = 1'b0;
			start_delay = 1'b0; end
		
		START: begin
			ledr = 10'b0000000000;
			en_lfsr = 1'b1; 
		end
		
		L0 : begin
			ledr = 10'b1000000000;
			en_lfsr = 1'b0;
		end
		L1 : ledr = 10'b1100000000;
		L2 : ledr = 10'b1110000000;
		L3 : ledr = 10'b1111000000;
		L4 : ledr = 10'b1111100000;
		L5 : ledr = 10'b1111110000;
		L6 : ledr = 10'b1111111000;
		L7 : ledr = 10'b1111111100;
		L8 : ledr = 10'b1111111110;
		L9 : ledr = 10'b1111111111;
		
		DELAY: begin
			ledr = 10'b1111111111;
			start_delay = 1'b1; end
		
		RACE: begin
			start_delay = 1'b0;
			ledr = 10'b0000000000;
			end
		
		default: ;
	endcase
end

endmodule