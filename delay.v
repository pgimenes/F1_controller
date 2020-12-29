module delay (
	clk,
	N,
	trigger,
	time_out
);

parameter BIT_SZ = 14;

//--------- ports ----------------------------------
input clk;
input [BIT_SZ-1:0] N;
input trigger;
output time_out;

//--------- required declarations ------------------
reg [BIT_SZ-1:0] count;

reg time_out;

//--------- FSM with embedded counter --------------
reg [1:0] state;
parameter IDLE = 2'b00, COUNTING = 2'b01;
parameter TIME_OUT = 2'b10, WAIT_LOW = 2'b11;

initial state = IDLE;
initial count = N - 1'b1;

always @ (posedge clk) begin
	case (state)
		IDLE: begin
				count <= N - 1'b1;
				if (trigger == 1'b1)
					state <= COUNTING; end

		COUNTING: if (count == 0) begin
						count <= N - 1'b1;
						state <= TIME_OUT;
						end
					else
						count <= count - 1'b1;
		TIME_OUT: if (trigger == 1'b0)
						state <= IDLE;
					else
						state <= WAIT_LOW;
		WAIT_LOW: if (trigger==1'b0)
						state <= IDLE;
		default:  ;//do nothing
	endcase
end

always @ (*) begin
	case (state)
		IDLE: time_out = 1'b0;
		COUNTING: time_out = 1'b0;
		TIME_OUT: time_out = 1'b1;
		WAIT_LOW: time_out = 1'b0;
		default: ; // do nothing
	endcase
end

endmodule


