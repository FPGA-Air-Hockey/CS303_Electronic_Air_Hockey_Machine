`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2024 11:17:44 PM
// Design Name: 
// Module Name: hockey_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hockey_sim(

    );

parameter HP = 5;       // Half period of our clock signal
parameter FP = (2*HP);  // Full period of our clock signal

//Inputs
reg clk, rst, BTN_A, BTN_B;
reg [1:0] DIR_A;
reg [1:0] DIR_B;
reg [2:0] Y_in_A;
reg [2:0] Y_in_B;

//Outputs
wire [2:0] X_COORD, Y_COORD;

//Instantiate the UUT
hockey UUT(clk, rst, BTN_A, BTN_B, DIR_A, DIR_B, Y_in_A, Y_in_B, X_COORD,Y_COORD);

// This always statement automatically cycles between clock high and clock low in HP (Half Period) time. Makes writing test-benches easier.
always #HP clk = ~clk;

//Initialize inputs
initial begin
	// $dumpfile("hockey.vcd"); //  * Our waveform is saved under this file.
    // $dumpvars(0,hockey_tb); // * Get the variables from the module.
    
    // $display("Simulation started.");
    
    clk = 0; 
    rst = 0;
    BTN_A = 0;
	BTN_B = 0;
	DIR_A = 0;
	DIR_B = 0;
    Y_in_A = 0;
    Y_in_B = 0;
    
	#FP;
	rst=1;
	#FP;
	rst=0;
	
	// Here, you are asked to write your test scenario.
	BTN_A = 1'b1;
	#10;
	BTN_A = 1'b0;
	#30;
	BTN_A = 1'b1;
	Y_in_A = 3'b010;
	DIR_A = 2'b00;
	#10;
	BTN_A = 1'b0;
	#120;						//puck movement time
	BTN_B = 1'b1;
	Y_in_B = 3'b011;		//not equal to Y_COORD, should be goal for A
	#20;
	BTN_B = 1'b0;
	#40;

	BTN_B = 1'b1;
	Y_in_B = 3'b010;
	DIR_B = 2'b00;
	#10;
	BTN_B = 1'b0;
	#120;
	BTN_A = 1'b1;
	Y_in_A = 3'b010;		// equal to Y_COORD
	#10;
	BTN_A = 1'b0;
	#90;					//puck movement time
	BTN_B = 1'b1;
	Y_in_B = 3'b010;
	DIR_B = 2'b00;
	#10;
	BTN_B = 1'b0;
	#90;
	BTN_A = 1'b1;
	Y_in_A = 3'b000;
	#20;
	BTN_A = 1'b0;
	#40;

	BTN_A = 1'b1;
	Y_in_A = 3'b010;
	DIR_A = 2'b00;
	#10;
	BTN_A = 1'b0;
	#120;
	BTN_B = 1'b1;
	Y_in_B = 3'b000;
	#20;
	BTN_B = 1'b0;
	#40;

	BTN_B = 1'b1;
	Y_in_B = 3'b010;
	DIR_B = 2'b00;
	#10;
	BTN_B = 1'b0;
	#120;
	BTN_A = 1'b1;
	Y_in_A = 3'b010;		// equal to Y_COORD
	#10;
	BTN_A = 1'b0;
	#90;					//puck movement time
	BTN_B = 1'b1;
	Y_in_B = 3'b010;
	//DIR_B = 2'b00;
	#10;
	BTN_B = 1'b0;
	#90;
	BTN_A = 1'b1;
	Y_in_A = 3'b010;		// equal to Y_COORD
	#10;
	BTN_A = 1'b0;
	#90;					//puck movement time
	BTN_B = 1'b1;
	Y_in_B = 3'b000;
	#20;
	BTN_B = 1'b0;
	#40;
	#100;
	
    // $display("Simulation finished.");
    // $finish(); // Finish simulation.

end
    
endmodule
