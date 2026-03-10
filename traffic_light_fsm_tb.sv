`timescale 1ns/1ps

module traffic_light_fsm_tb ();
	
	logic clk;
	logic rst;
	logic TAORB;
	logic [5:0] led;
	
	traffic_light_fsm DUT (
		.clk(clk), // .port(signal) like .clk(clk_tb)
		.rst(rst),
		.TAORB(TAORB),
		.led(led)
	);
	
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	initial begin
	
		rst = 1;
		TAORB = 1;	
		#20;
		rst = 0;
		#20;
		
		TAORB = 0;
		#80;
		
		TAORB = 1;
		#80;
		$stop;
	
	end
	
endmodule