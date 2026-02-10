`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2023 05:35:09 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output LEDA,
    output LEDB,
    output [4:0] LEDX,
    
    output a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,
    output [7:0]an
);

wire clock, BTN_A, BTN_B;
wire [6:0] SSD7, SSD6, SSD5, SSD4, SSD3, SSD2, SSD1, SSD0;

clk_divider clk_divider(clk, rst, clock);


debouncer debouncer_btna(clock, rst, BTNA, BTN_A);
debouncer debouncer_btnb(clock, rst, BTNB, BTN_B);

hockey hockey(clock, rst, BTN_A, BTN_B, DIRA, DIRB, YA, YB, LEDA, LEDB, LEDX, SSD7, SSD6, SSD5, SSD4, SSD3, SSD2, SSD1, SSD0);

ssd ssd(clk, rst, SSD7, SSD6, SSD5, SSD4, SSD3, SSD2, SSD1, SSD0, a_out, b_out, c_out, d_out, e_out, f_out, g_out, p_out, an);
	
endmodule
