module hockey(

    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   
    
    );

    reg turn, flag;
    reg [1:0] dirY, scoreA, scoreB;
    reg [3:0] state;
    reg [2:0] X_COORD, Y_COORD;
    reg [6:0] timer;

    //states: 
    //general
    parameter IDLE = 4'b0000, DISP = 4'b0001, END_STATE = 4'b1010;
    //turn A
    parameter HIT_A = 4'b0010, SEND_B = 4'b0011, RESP_B = 4'b0100, GOAL_A = 4'b0101;
    // //turn B
    parameter HIT_B = 4'b0110, SEND_A = 4'b0111, RESP_A = 4'b1000, GOAL_B = 4'b1001;

    parameter A = 7'b0001000, b = 7'b1100000, dash = 7'b1111110, off = 7'b1111111;
    parameter zero = 7'b0000001, one = 7'b1001111, two = 7'b0010010, three = 7'b0000110, four = 7'b1001100;

    //what to do with xcoord and ycoord
    
    // you may use additional always blocks or drive SSDs and LEDs in one always block
    // for state machine and memory elements 
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
            flag <= 0;
        end
        else
        begin
            case(state)
                IDLE:
                begin        
                    if(BTNA==1 && BTNB==0)
                    begin
                        state <= DISP;
                        turn <= 0;
                    end
                    else if(BTNA==0 && BTNB==1)
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
                    if(timer < 100)
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
                    if (BTNA && YA < 5)
                    begin
                        state <= SEND_B;
                        X_COORD <= 0;
                        Y_COORD <= YA;
                        dirY <= DIRA;
                    end
                    else
                    begin
                        state <= HIT_A;
                    end
                end
                HIT_B:
                begin        
                    if (BTNB && YB < 5)
                    begin
                        state <= SEND_A;
                        X_COORD <= 4;
                        Y_COORD <= YB;
                        dirY <= DIRB;
                    end
                    else
                    begin
                        state <= HIT_B;
                    end
                end
                SEND_A:
                begin
                    if (timer < 100)          //spend two seconds for every puck move
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
                    if (timer < 100)          //spend two seconds for every puck move
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
                    if(timer < 100)
                    begin
                        if (BTNA && Y_COORD == YA)
                        begin
                            X_COORD <= 1;
                            timer <= 0;
                            if (DIRA == 2'b10)
                            begin
                                if (Y_COORD == 0)
                                begin
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;                                        
                                end
                                else
                                begin
                                    dirY <= DIRA;
                                    Y_COORD <= Y_COORD - 1;
                                end
                            end
                            else if (DIRA == 2'b01)
                            begin
                                if (Y_COORD == 4)
                                begin
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                end
                                else
                                begin
                                    dirY <= DIRA;
                                    Y_COORD <= Y_COORD + 1;
                                end
                            end
                            else
                            //when DIRB == 2'b00 or in error case of 2'b11, direction sets to 0
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
                    if(timer < 100)
                    begin
                        if (BTNB && Y_COORD == YB)
                        begin
                            X_COORD <= 3;
                            timer <= 0;
                            if (DIRB == 2'b10)
                            begin
                                if (Y_COORD == 0)
                                begin
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;                                        
                                end
                                else
                                begin
                                    dirY <= DIRB;
                                    Y_COORD <= Y_COORD - 1;
                                end
                            end
                            else if (DIRB == 2'b01)
                            begin
                                if (Y_COORD == 4)
                                begin
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                end
                                else
                                begin
                                    dirY <= DIRB;
                                    Y_COORD <= Y_COORD + 1;
                                end
                            end
                            else
                            //when DIRA == 2'b00 or in error case of 2'b11, direction sets to 0
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
                    if(timer < 100)
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
                    if(timer < 100)
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
                    if (timer < 50)
                    begin
                        timer <= timer + 1;
                    end
                    else
                    begin
                        timer <= 0;
                        flag <= ~flag;
                    end
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
    
    // for SSDs
    always @ (*)
    begin
        case(state)
            IDLE:
            begin
                SSD4 = off;
                SSD2 = A;
                SSD1 = dash;
                SSD0 = b;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            DISP:
            begin
                SSD4 = off;
                SSD2 = zero;
                SSD1 = dash;
                SSD0 = zero;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
                
            end
            HIT_A:
            begin
                if (YA == 0)
                begin
                    SSD4 = zero;
                end
                else if (YA == 1)
                begin
                    SSD4 = one;
                end
                else if (YA == 2)
                begin
                    SSD4 = two;
                end
                else if (YA == 3)
                begin
                    SSD4 = three;
                end
                else if (YA == 4)
                begin
                    SSD4 = four;
                end
                else
                begin
                    SSD4 = dash;
                end
                // SSD4 = off;
                SSD2 = off;
                SSD1 = off;
                SSD0 = off;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            HIT_B:
            begin
                if (YB == 0)
                begin
                    SSD4 = zero;
                end
                else if (YB == 1)
                begin
                    SSD4 = one;
                end
                else if (YB == 2)
                begin
                    SSD4 = two;
                end
                else if (YB == 3)
                begin
                    SSD4 = three;
                end
                else if (YB == 4)
                begin
                    SSD4 = four;
                end
                else
                begin
                    SSD4 = dash;
                end
                // SSD4 = off;
                SSD2 = off;
                SSD1 = off;
                SSD0 = off;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            SEND_A:
            begin
                if (Y_COORD == 0)
                begin
                    SSD4 = zero;
                end
                else if (Y_COORD == 1)
                begin
                    SSD4 = one;
                end
                else if (Y_COORD == 2)
                begin
                    SSD4 = two;
                end
                else if (Y_COORD == 3)
                begin
                    SSD4 = three;
                end
                else
                begin
                    SSD4 = four;
                end
                SSD2 = off;
                SSD1 = off;
                SSD0 = off;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            SEND_B:
            begin
                if (Y_COORD == 0)
                begin
                    SSD4 = zero;
                end
                else if (Y_COORD == 1)
                begin
                    SSD4 = one;
                end
                else if (Y_COORD == 2)
                begin
                    SSD4 = two;
                end
                else if (Y_COORD == 3)
                begin
                    SSD4 = three;
                end
                else
                begin
                    SSD4 = four;
                end
                SSD2 = off;
                SSD1 = off;
                SSD0 = off;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            RESP_A:
            begin
                if (Y_COORD == 0)
                begin
                    SSD4 = zero;
                end
                else if (Y_COORD == 1)
                begin
                    SSD4 = one;
                end
                else if (Y_COORD == 2)
                begin
                    SSD4 = two;
                end
                else if (Y_COORD == 3)
                begin
                    SSD4 = three;
                end
                else
                begin
                    SSD4 = four;
                end
                SSD2 = off;
                SSD1 = off;
                SSD0 = off;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            RESP_B:
            begin
                if (Y_COORD == 0)
                begin
                    SSD4 = zero;
                end
                else if (Y_COORD == 1)
                begin
                    SSD4 = one;
                end
                else if (Y_COORD == 2)
                begin
                    SSD4 = two;
                end
                else if (Y_COORD == 3)
                begin
                    SSD4 = three;
                end
                else
                begin
                    SSD4 = four;
                end
                SSD2 = off;
                SSD1 = off;
                SSD0 = off;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            GOAL_A:
            begin
                SSD4 = off;
                // SSD2 = zero;
                SSD1 = dash;
                // SSD0 = zero;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
                
                if (scoreA == 0)
                begin
                    SSD2 = zero;
                end
                else if (scoreA == 1)
                begin
                    SSD2 = one;
                end
                else if (scoreA == 2)
                begin
                    SSD2 = two;
                end
                else
                begin
                    SSD2 = three;
                end

                if (scoreB == 0)
                begin
                    SSD0 = zero;
                end
                else if (scoreB == 1)
                begin
                    SSD0 = one;
                end
                else if (scoreB == 2)
                begin
                    SSD0 = two;
                end
                else
                begin
                    SSD0 = three;
                end
            end
            GOAL_B:
            begin
                SSD4 = off;
                SSD1 = dash;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
                
                if (scoreA == 0)
                begin
                    SSD2 = zero;
                end
                else if (scoreA == 1)
                begin
                    SSD2 = one;
                end
                else if (scoreA == 2)
                begin
                    SSD2 = two;
                end
                else
                begin
                    SSD2 = three;
                end

                if (scoreB == 0)
                begin
                    SSD0 = zero;
                end
                else if (scoreB == 1)
                begin
                    SSD0 = one;
                end
                else if (scoreB == 2)
                begin
                    SSD0 = two;
                end
                else
                begin
                    SSD0 = three;
                end
            end
            END_STATE:
            begin
                if (scoreB == 3)
                begin
                    SSD4 = b;
                    SSD0 = three;
                    if (scoreA == 0)
                    begin
                        SSD2 = zero;
                    end
                    else if (scoreA == 1)
                    begin
                        SSD2 = one;
                    end
                    else
                    begin
                        SSD2 = two;
                    end
                end
                else
                begin
                    SSD4 = A;
                    SSD2 = three;
                    if (scoreB == 0)
                    begin
                        SSD0 = zero;
                    end
                    else if (scoreB == 1)
                    begin
                        SSD0 = one;
                    end
                    else
                    begin
                        SSD0 = two;
                    end
                end
                SSD1 = dash;
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;
            end
            default:
            begin
                //these SSDs will remain off
                SSD7 = off;
                SSD6 = off;
                SSD5 = off;
                SSD3 = off;

                //these SSDs will change accordingly
                SSD4 = off;
                SSD2 = off;
                SSD1 = off;
                SSD0 = off;
            end
        endcase    
    end
    
    //for LEDs
    always @ (*)
    begin
        case(state)
            IDLE:
            begin
                LEDA = 1;
                LEDB = 1;
                LEDX = 5'b00000;
            end
            DISP:
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX = 5'b11111;
            end
            HIT_A:
            begin
                LEDA = 1;
                LEDB = 0;
                LEDX = 5'b00000;
            end
            HIT_B:
            begin
                LEDA = 0;
                LEDB = 1;
                LEDX = 5'b00000;
            end
            SEND_A:
            begin
                if (X_COORD == 1)
                begin
                    LEDX = 5'b01000;
                end
                else if (X_COORD == 2)
                begin
                    LEDX = 5'b00100;
                end
                else if (X_COORD == 3)
                begin
                    LEDX = 5'b00010;
                end
                else
                begin
                    LEDX = 5'b00001;
                end
                LEDA = 0;
                LEDB = 0;
            end
            SEND_B:
            begin
                if (X_COORD == 0)
                begin
                    LEDX = 5'b10000;
                end
                else if (X_COORD == 1)
                begin
                    LEDX = 5'b01000;
                end
                else if (X_COORD == 2)
                begin
                    LEDX = 5'b00100;
                end
                else
                begin
                    LEDX = 5'b00010;
                end
                LEDA = 0;
                LEDB = 0;
            end
            RESP_A:
            begin
                LEDA = 1;
                LEDB = 0;
                LEDX = 5'b10000;
            end
            RESP_B:
            begin
                LEDA = 0;
                LEDB = 1;
                LEDX = 5'b00001;
            end
            GOAL_A:
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX = 5'b11111;
            end
            GOAL_B:
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX = 5'b11111;
            end
            END_STATE:
            begin
                LEDA = 0;
                LEDB = 0;
                if (flag == 0)
                begin
                    LEDX = 5'b10101;
                    // flag = 1;
                end
                else
                begin
                    LEDX = 5'b01010;
                    // flag = 0;
                end
            end
            default:
            begin
                LEDA = 1;
                LEDB = 1;
                LEDX = 5'b00000;
            end
        endcase    
    end
    
endmodule
