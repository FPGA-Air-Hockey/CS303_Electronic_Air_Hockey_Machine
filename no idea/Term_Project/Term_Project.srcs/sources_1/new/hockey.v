`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2024 11:12:09 PM
// Design Name: 
// Module Name: hockey
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


module hockey(

input clk,
input rst,

input BTN_A,
input BTN_B,

input [1:0] DIR_A,
input [1:0] DIR_B,

input [2:0] Y_in_A,
input [2:0] Y_in_B,

/*output reg LEDA,
output reg LEDB,
output reg [4:0] LEDX,

output reg [6:0] SSD7,
output reg [6:0] SSD6,
output reg [6:0] SSD5,
output reg [6:0] SSD4, 
output reg [6:0] SSD3,
output reg [6:0] SSD2,
output reg [6:0] SSD1,
output reg [6:0] SSD0   */

output reg [2:0] X_COORD,
output reg [2:0] Y_COORD

);

reg turn;
reg [1:0] timer, dirY, scoreA, scoreB;
reg [3:0] state;

//states: 
//general
parameter IDLE = 4'b0000, DISP = 4'b0001, END_STATE = 4'b1010;
//turn A
parameter HIT_A = 4'b0010, SEND_B = 4'b0011, RESP_B = 4'b0100, GOAL_A = 4'b0101;
// //turn B
parameter HIT_B = 4'b0110, SEND_A = 4'b0111, RESP_A = 4'b1000, GOAL_B = 4'b1001;

always @(posedge clk or posedge rst)
begin
//your code goes here
    if(rst)
    begin
        state <= IDLE;
        turn <= 0;
        dirY <= 0;
        scoreA <= 0;
        scoreB <= 0;
        timer <= 0;
        X_COORD <= 0;
        Y_COORD <= 0;
    end
    else
    begin
        case(state)
            IDLE:
            begin
                if(BTN_A==1 && BTN_B==0)
                begin
                    state <= DISP;
                    turn <= 0;
                end
                else if(BTN_A==0 && BTN_B==1)
                begin
                    state <= DISP;
                    turn <= 1;
                end
                else
                begin
                    state <= IDLE;
                end
            end
            DISP:
            begin
                if(timer < 2)
                begin
                    state <= DISP;
                    timer <= timer + 1;
                end
                else
                begin
                    if (turn == 1)
                    begin
                        state <= HIT_B;
                    end
                    else
                    begin
                        state <= HIT_A;
                    end
                    timer <= 0;
                end
            end
            HIT_A:
            begin
                if (BTN_A && Y_in_A < 5)
                begin
                    state <= SEND_B;
                    X_COORD <= 0;
                    Y_COORD <= Y_in_A;
                    dirY <= DIR_A;
                end
                else
                begin
                    state <= HIT_A;
                end
            end
            HIT_B:
            begin
                if (BTN_B && Y_in_B < 5)
                begin
                    state <= SEND_A;
                    X_COORD <= 4;
                    Y_COORD <= Y_in_B;
                    dirY <= DIR_B;
                end
                else
                begin
                    state <= HIT_B;
                end
            end
            SEND_A:
            begin
                if (timer < 2)          //spend two seconds for every puck move
                begin
                    state <= SEND_A;
                    timer <= timer + 1;
                end
                else
                begin
                    timer <= 0;
                    if (dirY == 2'b10)
                    begin
                        if (Y_COORD == 0)
                        begin
                            dirY <= 2'b01;
                            Y_COORD <= Y_COORD + 1;
                        end
                        else
                        begin
                            Y_COORD <= Y_COORD - 1;
                        end
                    end
                    else if (dirY == 2'b01)
                    begin
                        if (Y_COORD == 4)
                        begin
                            dirY <= 2'b10;
                            Y_COORD <= Y_COORD - 1;
                        end
                        else
                        begin
                            Y_COORD <= Y_COORD + 1;
                        end
                    end
                    else
                    //when dirY == 2'b00 or in error case of 2'b11, direction sets to 0
                    begin
                        Y_COORD <= Y_COORD;
                        dirY <= 2'b00;
                    end
                    if (X_COORD > 1)
                    begin
                        state <= SEND_A;
                        X_COORD <= X_COORD - 1;
                    end
                    else
                    begin
                        X_COORD <= 0;
                        state <= RESP_A;
                    end
                end
            end
            SEND_B:
            begin
                if (timer < 2)          //spend two seconds for every puck move
                begin
                    state <= SEND_B;
                    timer <= timer + 1;
                end
                else
                begin
                    timer <= 0;
                    if (dirY == 2'b10)
                    begin
                        if (Y_COORD == 0)
                        begin
                            dirY <= 2'b01;
                            Y_COORD <= Y_COORD + 1;
                        end
                        else
                        begin
                            Y_COORD <= Y_COORD - 1;
                        end
                    end
                    else if (dirY == 2'b01)
                    begin
                        if (Y_COORD == 4)
                        begin
                            dirY <= 2'b10;
                            Y_COORD <= Y_COORD - 1;
                        end
                        else
                        begin
                            Y_COORD <= Y_COORD + 1;
                        end
                    end
                    else
                    //when dirY == 2'b00 or in error case of 2'b11, direction sets to 0
                    begin
                        Y_COORD <= Y_COORD;
                        dirY <= 2'b00;
                    end
                    if (X_COORD < 3)
                    begin
                        state <= SEND_B;
                        X_COORD <= X_COORD + 1;
                    end
                    else
                    begin
                        X_COORD <= 4;
                        state <= RESP_B;
                    end
                end
            end
            RESP_A:
            begin
                if(timer < 2)
                begin
                    if (BTN_A && Y_COORD == Y_in_A)
                    begin
                        X_COORD <= 1;
                        timer <= 0;
                        if (DIR_B == 2'b10)
                        begin
                            if (Y_COORD == 0)
                            begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;                                        
                            end
                            else
                            begin
                                dirY <= DIR_A;
                                Y_COORD <= Y_COORD - 1;
                            end
                        end
                        else if (DIR_B == 2'b01)
                        begin
                            if (Y_COORD == 4)
                            begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                            end
                            else
                            begin
                                dirY <= DIR_A;
                                Y_COORD <= Y_COORD + 1;
                            end
                        end
                        else
                        //when DIR_B == 2'b00 or in error case of 2'b11, direction sets to 0
                        begin
                            Y_COORD <= Y_COORD;
                            dirY <= 2'b00;
                        end
                        state <= SEND_B;
                    end
                    else
                    begin
                        state <= RESP_A;
                        timer <= timer + 1;
                    end

                end
                else
                begin
                    state <= GOAL_B;
                    scoreB <= scoreB + 1;
                    timer <= 0;
                end
            end
            RESP_B:
            begin
                if(timer < 2)
                begin
                    if (BTN_B && Y_COORD == Y_in_B)
                    begin
                        X_COORD <= 3;
                        timer <= 0;
                        if (DIR_A == 2'b10)
                        begin
                            if (Y_COORD == 0)
                            begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;                                        
                            end
                            else
                            begin
                                dirY <= DIR_B;
                                Y_COORD <= Y_COORD - 1;
                            end
                        end
                        else if (DIR_A == 2'b01)
                        begin
                            if (Y_COORD == 4)
                            begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                            end
                            else
                            begin
                                dirY <= DIR_B;
                                Y_COORD <= Y_COORD + 1;
                            end
                        end
                        else
                        //when DIR_A == 2'b00 or in error case of 2'b11, direction sets to 0
                        begin
                            Y_COORD <= Y_COORD;
                            dirY <= 2'b00;
                        end
                        state <= SEND_A;
                    end
                    else
                    begin
                        state <= RESP_B;
                        timer <= timer + 1;
                    end
                end
                else
                begin
                    state <= GOAL_A;
                    scoreA <= scoreA + 1;
                    timer <= 0;
                end
            end
            GOAL_A:
            begin
                if(timer < 2)
                begin
                    state <= GOAL_A;
                    timer <= timer + 1;
                end
                else
                begin
                    timer <= 0;
                    if (scoreA == 3)
                    begin
                        turn <= 0;
                        state <= END_STATE;
                    end
                    else
                    begin
                        state <= HIT_B;
                    end 
                end
            end
            GOAL_B:
            begin
                if(timer < 2)
                begin
                    state <= GOAL_B;
                    timer <= timer + 1;
                end
                else
                begin
                    timer <= 0;
                    if (scoreB == 3)
                    begin
                        turn <= 1;
                        state <= END_STATE;
                    end
                    else
                    begin
                        state <= HIT_A;
                    end 
                end
            end
            END_STATE:
            begin
                state <= END_STATE;
            end
            default:
            begin
                state <= IDLE;
                turn <= 0;
                dirY <= 0;
                timer <= 0;
            end
        endcase
    end
end
 
endmodule

 
// endmodule
