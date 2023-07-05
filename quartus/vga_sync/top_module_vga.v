module top_module_vga(CLOCK_50, VGA_VS, VGA_HS, VGA_CLK,o_red, o_green,o_blue,one, zero,start, reset,LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7);

input one, zero,start,reset;
reg [9:0] one_buf;
reg [9:0] zero_buf;
reg [9:0] start_buf;
reg [9:0] reset_buf;
reg [7:0] my_input;
reg [4:0] input_col;
reg [4:0] input_row;
reg [31:0] counter;
reg [31:0] state;
reg pulse;
assign LED0 = my_input[0];
assign LED1 = my_input[1];
assign LED2 = my_input[2];
assign LED3 = my_input[3];
assign LED4 = my_input[4];
assign LED5 = my_input[5];
assign LED6 = my_input[6];
assign LED7 = my_input[7];
output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7;
input CLOCK_50;
output VGA_HS, VGA_VS;

output reg VGA_CLK=0;
output wire [7:0]o_red;
output wire [7:0]o_green; 
output wire [7:0]o_blue;

reg [7:0]r_red;
reg [7:0]r_green; 
reg [7:0]r_blue;

reg [7:0] a_mem [0:399];
reg [7:0] b_mem [0:399];
reg [7:0] c_mem [0:399];
reg [7:0] d_mem [0:399];
reg [7:0] e_mem [0:399];
reg [7:0] f_mem [0:399];
reg [7:0] g_mem [0:399];
reg [7:0] h_mem [0:399];
reg [7:0] i_mem [0:399];
reg [7:0] j_mem [0:399];

reg [7:0] zero_mem [0:399];
reg [7:0] one_mem [0:399];
reg [7:0] two_mem [0:399];
reg [7:0] three_mem [0:399];
reg [7:0] four_mem [0:399];
reg [7:0] five_mem [0:399];
reg [7:0] six_mem [0:399];
reg [7:0] seven_mem [0:399];
reg [7:0] eight_mem [0:399];
reg [7:0] nine_mem [0:399];

reg [7:0] circle_mem [0:728];
reg [7:0] triangle_mem [0:728];

reg [7:0] big_circle_fill [0:3599];
reg [7:0] big_circle_empty [0:3599];
reg [7:0] big_triangle_fill [0:3599];
reg [7:0] big_triangle_empty [0:3599];

reg [7:0] circle_wins [0:2999];
reg [7:0] triangle_wins [0:2999];
reg [7:0] draw [0:2999];

reg[7:0] total_moves_txt[0:1664];
reg[7:0] recent_move_txt[0:2174];
reg[7:0] wins_txt[0:749];
integer timer = 0;
wire[9:0] pos_H, pos_V;
reg test_counter = 0;
reg enfal_clock = 0;
parameter TOTAL_MOVES_WIDTH = 111;
parameter TEXT_HEIGHT = 15;

parameter POS_N = 272;
parameter POSA = 302;
parameter POSB = 332;
parameter POSC = 362;
parameter POSD = 392;
parameter POSE = 422;
parameter POSF = 452;
parameter POSG = 482;
parameter POSH = 512;
parameter POSI = 542;
parameter POSJ = 572;

parameter POS_L = 50;
parameter POS0 = 70;
parameter POS1 = 100;
parameter POS2 = 130;
parameter POS3 = 160;
parameter POS4 = 190;
parameter POS5 = 220;
parameter POS6 = 250;
parameter POS7 = 280;
parameter POS8 = 310;
parameter POS9 = 340;

parameter SQUARE_SIZE = 27;
parameter LETTER_SIZE = 20;

parameter GREEN_MOVE_TXT_POS_H = 190;
parameter GREEN_MOVE_TXT_POS_V = 380;
parameter GREEN_MOVE_1_POS_H = 315;
parameter GREEN_MOVE_2_POS_H = 345;
parameter GREEN_TXT_RECENT_POSITION_H = 380;
parameter GREEN_RECENT_1_POSITION_H = 530;
parameter GREEN_RECENT_2_POSITION_H = 555;
parameter GREEN_TXT_WIN_POSITION_H = 580;
parameter GREEN_WIN_1_POSITION_H = 635;
parameter GREEN_WIN_2_POSITION_H = 655;

parameter BLUE_MOVE_TXT_POS_H = 190;
parameter BLUE_MOVE_TXT_POS_V = 410;
parameter BLUE_MOVE_1_POS_H = 315;
parameter BLUE_MOVE_2_POS_H = 345;
parameter BLUE_TXT_RECENT_POSITION_H = 380;
parameter BLUE_RECENT_1_POSITION_H = 530;
parameter BLUE_RECENT_2_POSITION_H = 555;
parameter BLUE_TXT_WIN_POSITION_H = 580;
parameter BLUE_WIN_1_POSITION_H = 635;
parameter BLUE_WIN_2_POSITION_H = 655;



reg [3:0] x  = 0;
reg [3:0] y  = 0;
wire [1:0] endgame;
wire current_player;
wire [95:0] triangle_moves;
wire [95:0] circle_moves;
wire [31:0] blocked_squares;
wire active_out;

integer letter = 0;
integer number = 0;
integer letter_g = 0;
integer number_g = 0;
integer letter_b = 0;
integer number_b = 0;
integer total_move_blue = 0;
integer total_move_green = 0;
integer win_g = 0;
integer win_b = 0;



initial begin
$readmemh("txts/A_letter.txt", a_mem);
$readmemh("txts/B_letter.txt", b_mem);
$readmemh("txts/C_letter.txt", c_mem);
$readmemh("txts/D_letter.txt", d_mem);
$readmemh("txts/E_letter.txt", e_mem);
$readmemh("txts/F_letter.txt", f_mem);
$readmemh("txts/G_letter.txt", g_mem);
$readmemh("txts/H_letter.txt", h_mem);
$readmemh("txts/I_letter.txt", i_mem);
$readmemh("txts/J_letter.txt", j_mem);

$readmemh("txts/0_letter.txt", zero_mem);
$readmemh("txts/1_letter.txt", one_mem);
$readmemh("txts/2_letter.txt", two_mem);
$readmemh("txts/3_letter.txt", three_mem);
$readmemh("txts/4_letter.txt", four_mem);
$readmemh("txts/5_letter.txt", five_mem);
$readmemh("txts/6_letter.txt", six_mem);
$readmemh("txts/7_letter.txt", seven_mem);
$readmemh("txts/8_letter.txt", eight_mem);
$readmemh("txts/9_letter.txt", nine_mem);

$readmemh("txts/circle.txt", circle_mem);
$readmemh("txts/triangle.txt", triangle_mem);


$readmemh("txts/circle_large_fill.txt", big_circle_fill);
$readmemh("txts/circle_large_empty.txt", big_circle_empty);
$readmemh("txts/tri_large_fill.txt", big_triangle_fill);
$readmemh("txts/tri_large_empty.txt", big_triangle_empty);


$readmemh("txts/tri_wins.txt", triangle_wins);
$readmemh("txts/circle_wins.txt", circle_wins);
$readmemh("txts/draw_sit.txt", draw);

$readmemh("txts/recent_pos.txt", recent_move_txt);
$readmemh("txts/total_moves.txt", total_moves_txt);
$readmemh("txts/wins.txt", wins_txt);

end

wire READY;

always @(posedge CLOCK_50) begin 
	VGA_CLK = ~VGA_CLK;
end



vga SYNC(.vga_CLK(VGA_CLK), .VSync(VGA_VS), .HSync(VGA_HS), .vga_Ready(READY), .pos_H(pos_H), .pos_V(pos_V));


BoardGame controller(.active(pulse), .end_game2(endgame),
.current_player2(current_player), .triangle_moves2(triangle_moves),.circle_moves2(circle_moves), .blocked_squares2(blocked_squares), .x(input_row), .y(input_col));

always @(posedge VGA_CLK)
	begin

		one_buf = (one_buf << 1) | one;
		zero_buf = (zero_buf << 1) | zero;
		start_buf = (start_buf << 1)| start;
		reset_buf = (reset_buf << 1) | reset;

	case(state)
		
		// reseter state //
		0:
		begin
			my_input = 0;
			state = 1;
			counter =0;
			pulse = 0;
		end
		////////////////
		
		// reseter delay state //
		1000:
		begin
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 0;
			end
		end
	
		///////////////////////////////////////////////////////////////////////////// taking input
		///////////////////////////////////////////// ROW
		1:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[0] = 1;
				state = 2;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[0] = 0;
				state = 2;
			end
		end
		2:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 3;
			end
		end
		3:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[1] = 1;
				state = 4;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[1] = 0;
				state = 4;
			end
		end
		4:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 5;
			end
		end
		5:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[2] = 1;
				state = 6;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[2] = 0;
				state = 6;
			end
		end
		6:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 7;
			end
		end
		7:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[3] = 1;
				state = 8;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[3] = 0;
				state = 8;
			end
		end
		8:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 9;
			end
		end
		///////////////////////////////////////////// COLUMN
		9:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[4] = 1;
				state = 10;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[4] = 0;
				state = 10;
			end
		end
		10:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 11;
			end
		end
		11:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[5] = 1;
				state = 12;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[5] = 0;
				state = 12;
			end
		end
		12:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 13;
			end
		end
		13:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[6] = 1;
				state = 14;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[6] = 0;
				state = 14;
			end
		end
		14:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 15;
			end
		end
		15:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b0000000000)
			begin
				my_input[7] = 1;
				state = 16;
			end
			else if(zero_buf == 10'b0000000000)
			begin
				my_input[7] = 0;
				state = 16;
			end
		end
		16:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 17;
			end
		end
		
		// input is take start request
		17:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(start_buf == 10'b0000000000)
			begin
			state = 18;
			end
		end
		18:
		begin
			if(reset_buf == 10'b0000000000)
				begin
				state = 1000;
				end
			if(one_buf == 10'b1111111111 && zero_buf == 10'b1111111111 && reset_buf == 10'b1111111111 && start_buf == 10'b1111111111)
			begin
			counter = counter + 1;
			end
			if(counter == 50000)
			begin
				counter = 0;
				state = 19;
			end
		end
	///////////////////////////////////////////////////////////////////////////// input is taken
	
		
		// input seperator
		19:
		begin
		input_col = my_input[3:0];
		input_row = my_input[7:4];
		if(current_player == 0)begin
		case(input_col)
		4'b0000: letter = 0;
		4'b0001: letter = 1;
		4'b0010: letter = 2;
		4'b0011: letter = 3;
		4'b0100: letter = 4;
		4'b0101: letter = 5;
		4'b0110: letter = 6;
		4'b0111: letter = 7;
		4'b1000: letter = 8;
		4'b1001: letter = 9;
		endcase
		case(input_row)
		4'b0000: number = 0;
		4'b0001: number = 1;
		4'b0010: number = 2;
		4'b0011: number = 3;
		4'b0100: number = 4;
		4'b0101: number = 5;
		4'b0110: number = 6;
		4'b0111: number = 7;
		4'b1000: number = 8;
		4'b1001: number = 9;
		endcase
		end
		my_input = 0;
		state = 20;
		end
		
		20:
		begin
		input_col = 0;
		input_row = 0;
		pulse = 1;
		state = 0;
		if(current_player == 0) total_move_green = total_move_green +1;
		else if(current_player == 1) total_move_blue = total_move_blue+1;
		if(current_player == 0 && endgame == 1) win_g = win_g+1;
		else if(current_player == 1 && endgame == 0) win_b = win_b + 1;
		end
	endcase
end


always @(posedge VGA_CLK) begin 


if(pos_H >=300 && pos_H <=601 && pos_V >=70 && pos_V <=371)
begin

	if((pos_H >=300 && pos_H <=301) 
	|| (pos_H >=330 && pos_H <=331)
	|| (pos_H >=360 && pos_H <=361)
	|| (pos_H >=390 && pos_H <=391)
	|| (pos_H >=420 && pos_H <=421)
	|| (pos_H >=450 && pos_H <=451)
	|| (pos_H >=480 && pos_H <=481)
	|| (pos_H >=510 && pos_H <=511)
	|| (pos_H >=540 && pos_H <=541)
	|| (pos_H >=570 && pos_H <=571)
	|| (pos_H >=600 && pos_H <=601))
	begin
	r_red <= 8'h00;    
	r_blue <= 8'h00;
	r_green <= 8'h00;
	end
		
	else if((pos_V >=70 && pos_V <=71) 
	|| (pos_V >=100 && pos_V <=101)
	|| (pos_V >=130 && pos_V <=131)
	|| (pos_V >=160 && pos_V <=161)
	|| (pos_V >=190 && pos_V <=191)
	|| (pos_V >=220 && pos_V <=221)
	|| (pos_V >=250 && pos_V <=251)
	|| (pos_V >=280 && pos_V <=281)
	|| (pos_V >=310 && pos_V <=311)
	|| (pos_V >=340 && pos_V <=341)
	|| (pos_V >=370 && pos_V <=371))
	begin
		r_red <= 8'h00;    
		r_blue <= 8'h00;
		r_green <= 8'h00;
	end
	
	else begin
		r_red <= 8'hFF;     
		r_blue <= 8'hFF;
		r_green <= 8'hFF;
	end
	
	
	end

else begin
	r_red <= 8'hFF;     
	r_blue <= 8'hFF;
	r_green <= 8'hFF;
end
if(pos_H >=POSA && pos_H <= POSA + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //A Letter
			r_red <= a_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSA}];    
			r_blue <= a_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSA}];
			r_green <= a_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSA}];
	end
	else if(pos_H >=POSB && pos_H <= POSB + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //B Letter
			r_red <= b_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSB}];    
			r_blue <= b_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSB}];
			r_green <= b_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSB}];
	end
	else if(pos_H >=POSC && pos_H <= POSC + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //C Letter
			r_red <= c_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSC}];    
			r_blue <= c_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSC}];
			r_green <= c_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSC}];
	end
	else if(pos_H >=POSD && pos_H <= POSD + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //D Letter
			r_red <= d_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSD}];    
			r_blue <= d_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSD}];
			r_green <= d_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSD}];
	end
	else if(pos_H >=POSE && pos_H <= POSE + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //E Letter
			r_red <= e_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSE}];    
			r_blue <= e_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSE}];
			r_green <= e_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSE}];
	end
	else if(pos_H >=POSF && pos_H <= POSF + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //F Letter
			r_red <= f_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSF}];    
			r_blue <= f_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSF}];
			r_green <= f_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSF}];
	end
		else if(pos_H >=POSG && pos_H <= POSG + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //F Letter
			r_red <= g_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSG}];    
			r_blue <= g_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSG}];
			r_green <= g_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSG}];
	end
	else if(pos_H >=POSH && pos_H <= POSH + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //H Letter
			r_red <= h_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSH}];    
			r_blue <= h_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSH}];
			r_green <= h_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSH}];
	end
	else if(pos_H >=POSI && pos_H <= POSI + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //I Letter
			r_red <= i_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSI}];    
			r_blue <= i_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSI}];
			r_green <= i_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSI}];
	end
	else if(pos_H >=POSJ && pos_H <= POSJ + LETTER_SIZE - 1 && pos_V >= POS_L && pos_V <=LETTER_SIZE + POS_L - 1) begin //J Letter
			r_red <= j_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSJ}];    
			r_blue <= j_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSJ}];
			r_green <= j_mem[{( pos_V-POS_L)*LETTER_SIZE + pos_H-POSJ}];
	end
	
	// ******************************************************Numbers **********************************************************
	if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS0 && pos_V <=LETTER_SIZE + POS0 - 1) begin // 0 Number
			r_red <= zero_mem[{( pos_V-POS0)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= zero_mem[{( pos_V-POS0)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= zero_mem[{( pos_V-POS0)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS1 && pos_V <=LETTER_SIZE + POS1 - 1) begin // 1 Number
			r_red <= one_mem[{( pos_V-POS1)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= one_mem[{( pos_V-POS1)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= one_mem[{( pos_V-POS1)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS2 && pos_V <=LETTER_SIZE + POS2 - 1) begin // 2 Number
			r_red <= two_mem[{( pos_V-POS2)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= two_mem[{( pos_V-POS2)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= two_mem[{( pos_V-POS2)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS3 && pos_V <=LETTER_SIZE + POS3 - 1) begin // 3 Number
			r_red <= three_mem[{( pos_V-POS3)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= three_mem[{( pos_V-POS3)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= three_mem[{( pos_V-POS3)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS4 && pos_V <=LETTER_SIZE + POS4 - 1) begin // 4 Number
			r_red <= four_mem[{( pos_V-POS4)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= four_mem[{( pos_V-POS4)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= four_mem[{( pos_V-POS4)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS5 && pos_V <=LETTER_SIZE + POS5 - 1) begin // 5 Number
			r_red <= five_mem[{( pos_V-POS5)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= five_mem[{( pos_V-POS5)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= five_mem[{( pos_V-POS5)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS6 && pos_V <=LETTER_SIZE + POS6 - 1) begin // 6 Number
			r_red <= six_mem[{( pos_V-POS6)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= six_mem[{( pos_V-POS6)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= six_mem[{( pos_V-POS6)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS7 && pos_V <=LETTER_SIZE + POS7 - 1) begin // 7 Number
			r_red <= seven_mem[{( pos_V-POS7)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= seven_mem[{( pos_V-POS7)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= seven_mem[{( pos_V-POS7)*LETTER_SIZE + pos_H-POS_N}];
	end
		else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS8 && pos_V <=LETTER_SIZE + POS8 - 1) begin // 8 Number
			r_red <= eight_mem[{( pos_V-POS8)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= eight_mem[{( pos_V-POS8)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= eight_mem[{( pos_V-POS8)*LETTER_SIZE + pos_H-POS_N}];
	end
	else if(pos_H >=POS_N && pos_H <= POS_N + LETTER_SIZE - 1 && pos_V >= POS9 && pos_V <=LETTER_SIZE + POS9 - 1) begin // 9 Number
			r_red <= nine_mem[{( pos_V-POS9)*LETTER_SIZE + pos_H-POS_N}];    
			r_blue <= nine_mem[{( pos_V-POS9)*LETTER_SIZE + pos_H-POS_N}];
			r_green <= nine_mem[{( pos_V-POS9)*LETTER_SIZE + pos_H-POS_N}];
	end
	
	
	
	
	
	else if (pos_H >= POSA - 100 && pos_H <= POSA - 100 + 60- 1 && pos_V >= POS3 && pos_V <=60 + POS3 - 1) begin // 9 Number
			if(current_player == 0)begin
				r_red <= 8'hFF;  
				r_blue <= 8'hFF;
				r_green <= big_triangle_fill[{( pos_V-POS3)*60 + pos_H-POSA + 100 }];
			end
				else if(current_player == 1)begin
				r_red <= 8'hFF;  
				r_blue <= 8'hFF;
				r_green <= big_triangle_empty[{( pos_V-POS3)*60 + pos_H-POSA + 100 }];
			end
	end
		else if (pos_H >= POSJ + 60 && pos_H <= POSJ +  60 + 60- 1 && pos_V >= POS3 && pos_V <=60 + POS3 - 1) begin // 9 Number
			if(current_player == 1)begin
			r_red <= 8'hFF;  
			r_blue <= big_circle_fill[{( pos_V-POS3)*60 + pos_H-POSJ -60 }];
			r_green <= 8'hFF;
			end
			else if (current_player == 0)begin
			r_red <= 8'hFF;  
			r_blue <= big_circle_empty[{( pos_V-POS3)*60 + pos_H-POSJ -60 }];
			r_green <= 8'hFF;
			end
	end
	
	
	
	
	
	else if(pos_H >= BLUE_MOVE_TXT_POS_H && pos_H <= BLUE_MOVE_TXT_POS_H - 1 + TOTAL_MOVES_WIDTH && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + TEXT_HEIGHT - 1)begin
			r_red <= 8'hFF;    
			r_blue <= total_moves_txt[{( pos_V-BLUE_MOVE_TXT_POS_V)*TOTAL_MOVES_WIDTH + pos_H-BLUE_MOVE_TXT_POS_H}];
			r_green <= 8'hFF;
	
	end
	else if(pos_H >= GREEN_MOVE_TXT_POS_H && pos_H <= GREEN_MOVE_TXT_POS_H - 1 + TOTAL_MOVES_WIDTH && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + TEXT_HEIGHT - 1)begin
			r_red <= 8'hFF;    
			r_blue <= 8'hFF;
			r_green <= total_moves_txt[{( pos_V-GREEN_MOVE_TXT_POS_V)*TOTAL_MOVES_WIDTH + pos_H-GREEN_MOVE_TXT_POS_H}];
	
	end
	else if(pos_H >= GREEN_MOVE_TXT_POS_H && pos_H <= GREEN_MOVE_TXT_POS_H - 1 + TOTAL_MOVES_WIDTH && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + TEXT_HEIGHT - 1)begin
			r_red <= 8'hFF;    
			r_blue <= 8'hFF;
			r_green <= total_moves_txt[{( pos_V-GREEN_MOVE_TXT_POS_V)*TOTAL_MOVES_WIDTH + pos_H-GREEN_MOVE_TXT_POS_H}];
	
	end
	else if(pos_H >= GREEN_MOVE_1_POS_H && pos_H <= GREEN_MOVE_1_POS_H + LETTER_SIZE - 1  && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			case(total_move_green)
			0: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= zero_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_1_POS_H}];			
			end
			10: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= one_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_1_POS_H}];			
			end
			20: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= two_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_1_POS_H}];			
			end
			
			endcase
	

	
	end
	else if(pos_H >= GREEN_MOVE_2_POS_H && pos_H <= GREEN_MOVE_2_POS_H + LETTER_SIZE - 1  && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			case(total_move_green)
				0: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= zero_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				1: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= one_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				2: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= two_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				3: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= three_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				4: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= four_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				5: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= five_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				6: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= six_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				7: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= seven_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				8: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= eight_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				9: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= nine_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				10: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= zero_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				11: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= one_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				12: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= two_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				13: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= three_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				14: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= four_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				15: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= five_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				16: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= six_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				17: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= seven_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				18: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= eight_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				19: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= nine_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				20: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= zero_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				21: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= one_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				22: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= two_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				23: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= three_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				24: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= four_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
				25: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= five_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_MOVE_2_POS_H}];
				end
	
			endcase
			

	
	end
	else if(pos_H >= GREEN_TXT_RECENT_POSITION_H && pos_H <= GREEN_TXT_RECENT_POSITION_H - 1 + 145 && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + TEXT_HEIGHT - 1)begin
			r_red <= 8'hFF;    
			r_blue <= 8'hFF;
			r_green <= recent_move_txt[{( pos_V-GREEN_MOVE_TXT_POS_V)*145 + pos_H-GREEN_TXT_RECENT_POSITION_H}];
	
	end
	
	else if(pos_H >= GREEN_RECENT_1_POSITION_H && pos_H <= GREEN_RECENT_1_POSITION_H+ LETTER_SIZE - 1  && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			if(current_player == 0) begin
			letter_b = letter;
				case(letter_b)
				0: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= a_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				1: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= b_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				2: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= c_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				3: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= d_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				4: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= e_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				5: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= f_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				6: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= g_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				7: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= h_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				8: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= i_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
				9: begin
					r_red <= 8'hFF;    
					r_blue <= 8'hFF;
					r_green <= j_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_1_POSITION_H}];
			
				end
			
			
				endcase
			end
	
	end
	else if(pos_H >= GREEN_RECENT_2_POSITION_H && pos_H <= GREEN_RECENT_2_POSITION_H + LETTER_SIZE - 1  && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
		if(current_player == 0) begin
			number_g = number;
			case(number_g)
				0: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= zero_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				1: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= one_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				2: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= two_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				3: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= three_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				4: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= four_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				5: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= five_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				6: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= six_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				7: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= seven_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				8: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= eight_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
				9: begin
						r_red <= 8'hFF;    
						r_blue <= 8'hFF;
						r_green <= nine_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_RECENT_2_POSITION_H}];
				end
			endcase	
			end

	end
	
	
	else if(pos_H >= GREEN_TXT_WIN_POSITION_H && pos_H <= GREEN_TXT_WIN_POSITION_H - 1 + 50 && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + TEXT_HEIGHT - 1)begin
			r_red <= 8'hFF;    
			r_blue <= 8'hFF;
			r_green <= wins_txt[{( pos_V-GREEN_MOVE_TXT_POS_V)*50 + pos_H-GREEN_TXT_WIN_POSITION_H}];
	
	end
	
	else if(pos_H >= GREEN_WIN_1_POSITION_H && pos_H <= GREEN_WIN_1_POSITION_H+ LETTER_SIZE - 1  && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			r_red <= 8'hFF;    
			r_blue <= 8'hFF;
			r_green <= zero_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_1_POSITION_H}];	
	
	end
	else if(pos_H >= GREEN_WIN_2_POSITION_H && pos_H <= GREEN_WIN_2_POSITION_H + LETTER_SIZE - 1  && pos_V >= GREEN_MOVE_TXT_POS_V && pos_V <= GREEN_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
		case(win_g)
			0: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= zero_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			1: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= one_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			2: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= two_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			3: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= three_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			4: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= four_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			5: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= five_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			6: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= six_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			7: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= seven_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			8: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= eight_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
			9: begin
				r_red <= 8'hFF;    
				r_blue <= 8'hFF;
				r_green <= nine_mem[{( pos_V-GREEN_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			end
		endcase
	end
	
	
	
	
	
	else if(pos_H >= BLUE_MOVE_1_POS_H && pos_H <= BLUE_MOVE_1_POS_H + LETTER_SIZE - 1  && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			
			case(total_move_blue)
				0:begin
					r_red <= 8'hFF;    
					r_blue <= zero_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_1_POS_H}];
					r_green <= 8'hFF;
				end
				10:begin
					r_red <= 8'hFF;    
					r_blue <= one_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_1_POS_H}];
					r_green <= 8'hFF;
				end
				20:begin
					r_red <= 8'hFF;    
					r_blue <= two_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_1_POS_H}];
					r_green <= 8'hFF;
				end
				
			endcase

	
	end
	else if(pos_H >= BLUE_MOVE_2_POS_H && pos_H <= BLUE_MOVE_2_POS_H + LETTER_SIZE - 1  && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			case(total_move_blue)
				0: begin
					r_red <= 8'hFF;    
					r_blue <= zero_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				1: begin
					r_red <= 8'hFF;    
					r_blue <= one_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				2: begin
					r_red <= 8'hFF;    
					r_blue <= two_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				3: begin
					r_red <= 8'hFF;    
					r_blue <= three_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				4: begin
					r_red <= 8'hFF;    
					r_blue <= four_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				5: begin
					r_red <= 8'hFF;    
					r_blue <= five_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				6: begin
					r_red <= 8'hFF;    
					r_blue <= six_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				7: begin
					r_red <= 8'hFF;    
					r_blue <= seven_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				8: begin
					r_red <= 8'hFF;    
					r_blue <= eight_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				9: begin
					r_red <= 8'hFF;    
					r_blue <= nine_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				10: begin
					r_red <= 8'hFF;    
					r_blue <= zero_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				11: begin
					r_red <= 8'hFF;    
					r_blue <= one_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				12: begin
					r_red <= 8'hFF;    
					r_blue <= two_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				13: begin
					r_red <= 8'hFF;    
					r_blue <= three_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				14: begin
					r_red <= 8'hFF;    
					r_blue <= four_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				15: begin
					r_red <= 8'hFF;    
					r_blue <= five_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				16: begin
					r_red <= 8'hFF;    
					r_blue <= six_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				17: begin
					r_red <= 8'hFF;    
					r_blue <= seven_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				18: begin
					r_red <= 8'hFF;    
					r_blue <= eight_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				19: begin
					r_red <= 8'hFF;    
					r_blue <= nine_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				0: begin
					r_red <= 8'hFF;    
					r_blue <= zero_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				21: begin
					r_red <= 8'hFF;    
					r_blue <= one_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				22: begin
					r_red <= 8'hFF;    
					r_blue <= two_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				23: begin
					r_red <= 8'hFF;    
					r_blue <= three_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				24: begin
					r_red <= 8'hFF;    
					r_blue <= four_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
				end
				25: begin
					r_red <= 8'hFF;    
					r_blue <= five_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_MOVE_2_POS_H}];
					r_green <= 8'hFF;
					end
			endcase

	
	end

	
	
	else if(pos_H >= BLUE_TXT_RECENT_POSITION_H && pos_H <= BLUE_TXT_RECENT_POSITION_H - 1 + 145 && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + TEXT_HEIGHT - 1)begin
			
			r_red <= 8'hFF;    
			r_blue <= recent_move_txt[{( pos_V-BLUE_MOVE_TXT_POS_V)*145 + pos_H-BLUE_TXT_RECENT_POSITION_H}];
			r_green <= 8'hFF;  
	
	end
	
	else if(pos_H >= BLUE_RECENT_1_POSITION_H && pos_H <= BLUE_RECENT_1_POSITION_H+ LETTER_SIZE - 1  && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			if(current_player == 1)begin
				letter_g = letter;
				case(letter_g)
				0:begin	
					r_red <= 8'hFF;    
					r_blue <= a_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				1:begin	
					r_red <= 8'hFF;    
					r_blue <= b_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				2:begin	
					r_red <= 8'hFF;    
					r_blue <= c_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				3:begin	
					r_red <= 8'hFF;    
					r_blue <= d_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				4:begin	
					r_red <= 8'hFF;    
					r_blue <= e_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				5:begin	
					r_red <= 8'hFF;    
					r_blue <= f_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				6:begin	
					r_red <= 8'hFF;    
					r_blue <= g_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				7:begin	
					r_red <= 8'hFF;    
					r_blue <= g_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				8:begin	
					r_red <= 8'hFF;    
					r_blue <= i_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				9:begin	
					r_red <= 8'hFF;    
					r_blue <= j_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_1_POSITION_H}];
					r_green <= 8'hFF;
				end
				endcase
			end	
			
	
	end
	else if(pos_H >= BLUE_RECENT_2_POSITION_H && pos_H <= BLUE_RECENT_2_POSITION_H + LETTER_SIZE - 1  && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			if(current_player == 1)begin
			number_b = number;
			case(number_b)
				0: begin
					r_red <= 8'hFF;    
					r_blue <= zero_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				1: begin
					r_red <= 8'hFF;    
					r_blue <= one_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				2: begin
					r_red <= 8'hFF;    
					r_blue <= two_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				3: begin
					r_red <= 8'hFF;    
					r_blue <= three_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				4: begin
					r_red <= 8'hFF;    
					r_blue <= four_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				5: begin
					r_red <= 8'hFF;    
					r_blue <= five_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				6: begin
					r_red <= 8'hFF;    
					r_blue <= six_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				7: begin
					r_red <= 8'hFF;    
					r_blue <= seven_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				8: begin
					r_red <= 8'hFF;    
					r_blue <= eight_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
				9: begin
					r_red <= 8'hFF;    
					r_blue <= nine_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - BLUE_RECENT_2_POSITION_H}];
					r_green <= 8'hFF; 
				end
			endcase
			end

	end
	
	
		else if(pos_H >= BLUE_TXT_WIN_POSITION_H && pos_H <= BLUE_TXT_WIN_POSITION_H - 1 + 50 && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + TEXT_HEIGHT - 1)begin
			r_red <= 8'hFF;    
			r_blue <= wins_txt[{( pos_V-BLUE_MOVE_TXT_POS_V)*50 + pos_H-BLUE_TXT_WIN_POSITION_H}];
			r_green <= 8'hFF;
	
	end
	
	else if(pos_H >= GREEN_WIN_1_POSITION_H && pos_H <= GREEN_WIN_1_POSITION_H+ LETTER_SIZE - 1  && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			r_red <= 8'hFF;    
			r_blue <= zero_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_1_POSITION_H}];
			r_green <= 8'hFF;
	
	end
	else if(pos_H >= GREEN_WIN_2_POSITION_H && pos_H <= GREEN_WIN_2_POSITION_H + LETTER_SIZE - 1  && pos_V >= BLUE_MOVE_TXT_POS_V && pos_V <= BLUE_MOVE_TXT_POS_V + LETTER_SIZE - 1)begin
			case(win_b)
			0:begin
			r_red <= 8'hFF;    
			r_blue <= zero_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			1:begin
			r_red <= 8'hFF;    
			r_blue <= one_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			2:begin
			r_red <= 8'hFF;    
			r_blue <= two_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			3:begin
			r_red <= 8'hFF;    
			r_blue <= three_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			4:begin
			r_red <= 8'hFF;    
			r_blue <= four_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			5:begin
			r_red <= 8'hFF;    
			r_blue <= five_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			6:begin
			r_red <= 8'hFF;    
			r_blue <= six_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			7:begin
			r_red <= 8'hFF;    
			r_blue <= seven_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			8:begin
			r_red <= 8'hFF;    
			r_blue <= eight_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			9:begin
			r_red <= 8'hFF;    
			r_blue <= nine_mem[{( pos_V-BLUE_MOVE_TXT_POS_V)*LETTER_SIZE + pos_H - GREEN_WIN_2_POSITION_H}];
			r_green <= 8'hFF;
			end
			endcase
			
	end
	
	
	else if(pos_H >= 325 && pos_H <= 475 - 1  && pos_V >= 440 && pos_V <= 460- 1)begin
	case(endgame)
	0:begin
			r_red <= circle_wins[{( pos_V-440)*150 + pos_H - 325}]; 
			r_blue <= circle_wins[{( pos_V-440)*150 + pos_H - 325}];
			r_green <= circle_wins[{( pos_V-440)*150 + pos_H - 325}];
	end
	1:begin
			r_red <= triangle_wins[{( pos_V-440)*150 + pos_H - 325}]; 
			r_blue <= triangle_wins[{( pos_V-440)*150 + pos_H - 325}];
			r_green <= triangle_wins[{( pos_V-440)*150 + pos_H - 325}];	
	end
	2:begin
			r_red <= draw[{( pos_V-440)*150 + pos_H - 325}]; 
			r_blue <= draw[{( pos_V-440)*150 + pos_H - 325}];
			r_green <= draw[{( pos_V-440)*150 + pos_H - 325}];	
	end
	3:begin
			r_red <= 8'hFF;
			r_blue <= 8'hFF;
			r_green <= 8'hFF;	
	end
	endcase
	end
	
	
	
	
	
	
	
	
	
	
	
	
// *********************************************************** Drawing shapes to the board ***********************************************************************//

/*triangle_moves  <= 80'b0000000000000000000000000000000000000000000000000000000001100110101010101100110 ;
circle_moves  <= 80'b0000000000000000000000000000000000000000000000000000000100110010110010110010110 ;
circle_moves  <= 80'b0000000000000000000000000000000000000000000000000000000100110010110010110010110 ; */
// *********************************************************** Triangles ***********************************************************************//

	if(pos_H >=POSA + {triangle_moves[3:0] * 30} && pos_H <= POSA + {triangle_moves[3:0] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[7:4] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[7:4] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[7:4] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[3:0] * 30}}];
			end
	else if(pos_H >=POSA + {triangle_moves[11:8] * 30} && pos_H <= POSA + {triangle_moves[11:8] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[15:12] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[15:12] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[15:12] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[11:8] * 30}}];
			end
	else if(pos_H >=POSA + {triangle_moves[19:16] * 30} && pos_H <= POSA + {triangle_moves[19:16] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[23:20] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[23:20] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[23:20] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[19:16] * 30}}];
			end
	else if(pos_H >=POSA + {triangle_moves[27:24] * 30} && pos_H <= POSA + {triangle_moves[27:24] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[31:28] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[31:28] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[31:28] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[27:24] * 30}}];
			end
	else if(pos_H >=POSA + {triangle_moves[35:32] * 30} && pos_H <= POSA + {triangle_moves[35:32] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[39:36] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[39:36] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[39:36] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[35:32] * 30}}];
			end
			else if(pos_H >=POSA + {triangle_moves[43:40] * 30} && pos_H <= POSA + {triangle_moves[43:40] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[47:44] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[47:44] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[47:44] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[43:40] * 30}}];
			end
			else if(pos_H >=POSA + {triangle_moves[51:48] * 30} && pos_H <= POSA + {triangle_moves[51:48] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[55:52] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[55:52] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[55:52] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[51:48] * 30}}];
			end
			else if(pos_H >=POSA + {triangle_moves[59:56] * 30} && pos_H <= POSA + {triangle_moves[59:56] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[63:60] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[63:60] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[63:60] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[59:56] * 30}}];
			end
			else if(pos_H >=POSA + {triangle_moves[67:64] * 30} && pos_H <= POSA + {triangle_moves[67:64] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[71:68] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[71:68] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[71:68] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[67:64] * 30}}];
			end
			else if(pos_H >=POSA + {triangle_moves[75:72] * 30} && pos_H <= POSA + {triangle_moves[75:72] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {triangle_moves[79:76] * 31} && pos_V <= POS0 + SQUARE_SIZE + {triangle_moves[79:76] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_blue <= 8'hFF; 
				r_green <= triangle_mem[{( pos_V-POS0 - {triangle_moves[79:76] * 31})*SQUARE_SIZE + pos_H-POSA - {triangle_moves[75:72] * 30}}];
			end
			
// ******************************************************************* End of Drawing Triangles **************************************************************//
		
		
   if(pos_H >=POSA + {circle_moves[3:0] * 30} && pos_H <= POSA + {circle_moves[3:0] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[7:4] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[7:4] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[7:4] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[3:0] * 30}}];
			end
	else if(pos_H >=POSA + {circle_moves[11:8] * 30} && pos_H <= POSA + {circle_moves[11:8] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[15:12] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[15:12] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[15:12] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[11:8] * 30}}];
			end
	else if(pos_H >=POSA + {circle_moves[19:16] * 30} && pos_H <= POSA + {circle_moves[19:16] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[23:20] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[23:20] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[23:20] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[19:16] * 30}}];
			end
	else if(pos_H >=POSA + {circle_moves[27:24] * 30} && pos_H <= POSA + {circle_moves[27:24] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[31:28] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[31:28] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[31:28] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[27:24] * 30}}];
			end
	else if(pos_H >=POSA + {circle_moves[35:32] * 30} && pos_H <= POSA + {circle_moves[35:32] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[39:36] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[39:36] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[39:36] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[35:32] * 30}}];
			end
			else if(pos_H >=POSA + {circle_moves[43:40] * 30} && pos_H <= POSA + {circle_moves[43:40] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[47:44] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[47:44] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[47:44] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[43:40] * 30}}];
			end
			else if(pos_H >=POSA + {circle_moves[51:48] * 30} && pos_H <= POSA + {circle_moves[51:48] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[55:52] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[55:52] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[55:52] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[51:48] * 30}}];
			end
			else if(pos_H >=POSA + {circle_moves[59:56] * 30} && pos_H <= POSA + {circle_moves[59:56] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[63:60] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[63:60] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[63:60] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[59:56] * 30}}];
			end
			else if(pos_H >=POSA + {circle_moves[67:64] * 30} && pos_H <= POSA + {circle_moves[67:64] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[71:68] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[71:68] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[71:68] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[67:64] * 30}}];
			end
			else if(pos_H >=POSA + {circle_moves[75:72] * 30} && pos_H <= POSA + {circle_moves[75:72] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {circle_moves[79:76] * 31} && pos_V <= POS0 + SQUARE_SIZE + {circle_moves[79:76] * 31} - 1) begin //  ax0
				r_red <= 8'hFF;    
				r_green <= 8'hFF; 
				r_blue <= circle_mem[{( pos_V-POS0 - {circle_moves[79:76] * 31})*SQUARE_SIZE + pos_H-POSA - {circle_moves[75:72] * 30}}];
			end
			
		
		
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
	if(pos_H >=POSA + {blocked_squares[3:0] * 30} && pos_H <= POSA + {blocked_squares[3:0] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {blocked_squares[7:4] * 30} && pos_V <= POS0 + SQUARE_SIZE + {blocked_squares[7:4] * 30} - 1) begin //  ax0
				r_red <= 8'h00;    
				r_green <= 8'h00; 
				r_blue <= 8'h00;
			end
	else if(pos_H >=POSA + {blocked_squares[11:8] * 30} && pos_H <= POSA + {blocked_squares[11:8] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {blocked_squares[15:12] * 30} && pos_V <= POS0 + SQUARE_SIZE + {blocked_squares[15:12] * 30} - 1) begin //  ax0
				r_red <= 8'h00;    
				r_green <= 8'h00; 
				r_blue <= 8'h00;
			end
	else if(pos_H >=POSA + {blocked_squares[19:16] * 30} && pos_H <= POSA + {blocked_squares[19:16] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {blocked_squares[23:20] * 30} && pos_V <= POS0 + SQUARE_SIZE + {blocked_squares[23:20] * 30} - 1) begin //  ax0
				r_red <= 8'h00;    
				r_green <= 8'h00; 
				r_blue <= 8'h00;
			end
	else if(pos_H >=POSA + {blocked_squares[27:24] * 30} && pos_H <= POSA + {blocked_squares[27:24] * 30} + SQUARE_SIZE - 1 && pos_V >= POS0 + {blocked_squares[31:28] * 30} && pos_V <= POS0 + SQUARE_SIZE + {blocked_squares[31:28] * 30} - 1) begin //  ax0
				r_red <= 8'h00;    
				r_green <= 8'h00; 
				r_blue <= 8'h00;
			end
		
		
		
		/*else if(pos_H >=POSA && pos_H <= POSA + SQUARE_SIZE - 3 && pos_V >= POS1 && pos_V <=SQUARE_SIZE + POS1 - 3) begin //ax1
			r_red <= 8'hFF;   
			r_blue <= circle_mem[{( pos_V-POS1)*SQUARE_SIZE + pos_H-POSB}];
			r_green <= 8'hFF;
		end */
	

		

end
assign o_red = READY ? r_red : 8'h00;
assign o_blue = READY ? r_blue : 8'h00;
assign o_green = READY ? r_green : 8'h00;

endmodule
