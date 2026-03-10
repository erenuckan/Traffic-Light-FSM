module traffic_light_fsm (
		
		input logic clk,
		input logic rst,
		input logic TAORB, 				// Traffic A or B, which one has right of way (1:A 0:B)
		output reg [5:0] led 			// bits 5 4 3 for A, bits 2 1 0 for B (Green, Yellow, Red)
		
);

	// Enumaration of State Type
	typedef enum bit [1:0] {
		
		GREENRED 	= 2'b00,
		YELLOWRED 	= 2'b01,
		REDGREEN 	= 2'b10,
		REDYELLOW	= 2'b11
		
	} state_t;
	
	state_t state_reg, state_next; 	// State register and Next state
	logic [2:0] TIMER; 					// TIMER counter for states YELLOWRED and REDYELLOW
	
	// State Transition Sequential Block
	always_ff @ (posedge(clk) or posedge(rst)) 
	begin
		
		if (rst) begin
			state_reg 	<= GREENRED;	// Reset to S0
		end
		else begin
			state_reg 	<= state_next;
		end
	end
	
	// TIMER Counter Sequential Block
	always_ff @ (posedge(clk) or posedge(rst))
	begin
		if (rst) begin
			TIMER <= 3'b000;
		end
		else begin
			if ((state_reg == YELLOWRED) || (state_reg == REDYELLOW)) begin
				TIMER <= TIMER + 1; 
			end
			else begin
				TIMER <= 3'b000;
			end
		end
	end
	
	// Output / Next State Logic Combinational Block
	always_comb 
	begin
	
		led = 6'b000000;
		state_next = state_reg; // state_next is output of next state logic
		
		case(state_reg)
		
			GREENRED: begin 
				led = 6'b100001; // A = Green, B = Red  
				if (!TAORB) begin
					state_next = YELLOWRED;
				end
				else begin
					state_next = GREENRED;
				end
			end
			
			YELLOWRED: begin
				led = 6'b010001;
				if ((~TAORB) && (TIMER < 4)) begin // Counting starts from 0
					state_next = YELLOWRED;
				end
				else if ((~TAORB) && (TIMER == 4)) begin
					state_next = REDGREEN;
				end
			end
			
			REDGREEN: begin
				led = 6'b001100;
				if (TAORB) begin
					state_next = REDYELLOW;
				end
				else begin
					state_next = REDGREEN;
				end
			end
			
			REDYELLOW: begin
				led = 6'b001010;
				if ((TAORB) && (TIMER < 4)) begin
					state_next = REDYELLOW;
				end
				else if ((TAORB) && (TIMER == 4)) begin
					state_next = GREENRED;
				end
			end
			
			default: begin
				state_next = GREENRED;
			end
			
		endcase	
	end
endmodule	
