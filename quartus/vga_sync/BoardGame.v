module BoardGame(active, x, y, end_game2, current_player2, triangle_moves2, circle_moves2, blocked_squares2, count2, count_delete_t_out);

input [3:0] x, y;
input active;

output[4:0] count_delete_t_out;

output wire current_player2;
output wire [1:0] end_game2;
output wire [95:0] circle_moves2;
output wire [31:0] blocked_squares2;
output wire [95:0] triangle_moves2;
output [4:0] count2;


reg [95:0] triangle_moves3 = 96'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
reg [95:0] circle_moves3 = 96'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
reg [31:0] blocked_squares3 = 32'b11111111111111111111111111111111;

integer x_coordinate = 15, y_coordinate = 15;
integer current_player, end_game = 3, count, count_delete_t = 0, count_delete_c = 0;
integer i, j, triangle_moves[0:9][1:0], circle_moves[0:9][1:0], blocked_squares[0:3][1:0], total_squares[0:24][1:0]; //[[a,b], [c,d],[e,f], [g,h], [i,j]]
integer x_difference[0:9], y_difference[0:9], x_control[0:9], y_control[0:9], cross_control[0:9];
integer a,b,c;
integer nvalid;

initial begin
integer current_player = 0, end_game = 3, count = 0, count_delete_t = 0, count_delete_c = 0;
integer i=0, j=0;
//integer triangle_moves[0:9][1:0];
//integer circle_moves[0:9][1:0];
//integer blocked_squares[0:3][1:0];
//integer total_squares[0:24][1:0]; //[[a,b], [c,d],[e,f], [g,h], [i,j]]
//integer x_difference[0:9], y_difference[0:9], x_control[0:9], y_control[0:9], cross_control[0:9];
integer a, b, c = 0;
integer nvalid = 0;
end

							
always @(posedge active) begin

if(count == 0) begin
	for(i = 0; i < 25; i = i + 1) begin
		total_squares[i][0] = 15;
		total_squares[i][1] = 15;
	end
end

	if(end_game !=3) begin
			x_coordinate = 15; 
			y_coordinate = 15; 
			current_player = 0;
			count = 0;
			count_delete_t = 0;
			count_delete_c = 0;
			for(i=0; i<10; i=i+1) begin
				triangle_moves[i][0] = 0;
				triangle_moves[i][1] = 0;
				circle_moves[i][0] = 0;
				circle_moves[i][1] = 0;
			end
			for(i=0; i<4; i=i+1) begin
				blocked_squares[i][0] = 0;
				blocked_squares[i][1] = 0;
			end
			for(i = 0; i < 25; i = i + 1) begin
				total_squares[i][0] = 15;
				total_squares[i][1] = 15;
			end
				i = 0;
				j = 0;
				triangle_moves3 = 96'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				circle_moves3 = 96'b111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
				blocked_squares3 = 32'b11111111111111111111111111111111;
				end_game = 3;
	end 

	if(end_game == 3) begin
			nvalid = 0;
		
			for(i = 0; i < 25; i = i+1) begin
				if((total_squares[i][0] == x) && (total_squares[i][1] ==  y)) begin
					nvalid = 1;
				end
			end 
			
			if(!nvalid) begin
				x_coordinate = x;
				y_coordinate = y;
				if(!current_player) begin //Triangle
					for(i=0; i<10; i=i+1) begin
						x_difference[i] = 0;
						x_control[i] = 0;
						y_difference[i] = 0;
						y_control[i] = 0;
						cross_control[i] = 0;
					end
					if((count%6==4) && (count!=4) && (count!= 16)) begin
						blocked_squares[count-10][0] = triangle_moves[0][0];
						blocked_squares[count-10][1] = triangle_moves[0][1];
						
						count_delete_t = count_delete_t+1;	
						if(count_delete_t == 1) begin
						triangle_moves3[3:0] = 4'b1111;
						triangle_moves3[7:4] = 4'b1111;
						blocked_squares3[3:0] = blocked_squares[count-10][0];
						blocked_squares3[7:4] = blocked_squares[count-10][0];
						end
						else if(count_delete_t == 2) begin
						triangle_moves3[11:8] = 4'b1111;
						triangle_moves3[15:12] = 4'b1111;
						blocked_squares3[19:16] = blocked_squares[count-10][0];
						blocked_squares3[23:20] = blocked_squares[count-10][0];
						end

						for (i = 0; i < 9; i = i + 1) begin
							triangle_moves[i][0] = triangle_moves[i + 1][0];
							triangle_moves[i][1] = triangle_moves[i + 1][1];
						end
						
						triangle_moves[(count-2*(count_delete_t))/2][0] = x_coordinate;
						triangle_moves[(count-2*(count_delete_t))/2][1] = y_coordinate;

					end
					else begin
						triangle_moves[(count-2*(count_delete_t))/2][0] = x_coordinate;
						triangle_moves[(count-2*(count_delete_t))/2][1] = y_coordinate;
					end
					
						total_squares[count][0] = x_coordinate;
						total_squares[count][1] = y_coordinate;
						
					for(i=0; i<10; i=i+1) begin
						x_difference[i] = x_coordinate - triangle_moves[i][0];
						y_difference[i] = y_coordinate - triangle_moves[i][1];
					end
						
								
					for(i=0; i<10; i=i+1) begin
						if(x_difference[i] == 0) begin
							if(y_difference[i] > 0) begin
								y_control[i] = y_difference[i];
							end
							else begin
								y_control[i] = y_difference[i] * (-1);
							end
						end
						if(y_difference[i] == 0) begin
							if(x_difference[i] > 0) begin
								x_control[i] = x_difference[i];
							end
							else begin
								x_control[i] = x_difference[i] * (-1);
							end
						end
						if((x_difference[i] == y_difference[i]) || ((-1 * x_difference[i]) == y_difference[i])) begin
						if(x_difference[i] > 0) begin
							cross_control[i] = x_difference[i];
						end
						else begin
							cross_control[i] = x_difference[i] * (-1);
						end
						end
					end
						
					for(j = 0; j<3; j=j+1) begin
						a = 0;
						b = 0;
						c = 0;
						if(j == 0) begin
							for(i = 0; i <10; i=i+1) begin
								if(y_control[i] == 1) a = 1;
								if(y_control[i] == 2) b = 1;
								if(y_control[i] == 3) c = 1;
								if(a && b && c) end_game = 1;
							end
						end
						if(j==1) begin
							for(i = 0; i <10; i=i+1) begin
								if(x_control[i] == 1) a = 1;
								if(x_control[i] == 2) b = 1;
								if(x_control[i] == 3) c = 1;
								if(a && b && c) end_game = 1;
							end
						end
						if(j==2) begin
							for(i = 0; i <10; i=i+1) begin
								if(cross_control[i] == 1) a = 1;
								if(cross_control[i] == 2) b = 1;
								if(cross_control[i] == 3) c = 1;
								if(a && b && c) end_game = 1;
							end
						end
					end
					
					if(count == 0) begin
						triangle_moves3[3:0] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[7:4] = triangle_moves[(count-2*(count_delete_t))/2][1];
					end
					else if(count == 2) begin
						triangle_moves3[11:8] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[15:12] = triangle_moves[(count-2*(count_delete_t))/2][1];
					end
					else if(count == 4) begin
						triangle_moves3[19:16] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[23:20] = triangle_moves[(count-2*(count_delete_t))/2][1];
					end
					else if(count == 6) begin
						triangle_moves3[27:24] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[31:28] = triangle_moves[(count-2*(count_delete_t))/2][1];
					end
					else if(count == 8) begin
						triangle_moves3[35:32] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[39:36] = triangle_moves[(count-2*(count_delete_t))/2][1];
					end
					else if(count == 10) begin
						triangle_moves3[43:40] = x_coordinate;
						triangle_moves3[47:44] = y_coordinate;
					end
					else if(count == 12) begin
						triangle_moves3[51:48] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[55:52] = triangle_moves[(count-2*(count_delete_t))/2][0];
					end
					else if(count == 14) begin
						triangle_moves3[59:56] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[63:60] = triangle_moves[(count-2*(count_delete_t))/2][0];
					end
					else if(count == 16) begin
						triangle_moves3[67:64] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[71:68] = triangle_moves[(count-2*(count_delete_t))/2][0];
					end
					else if(count == 18) begin
						triangle_moves3[75:72] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[79:76] = triangle_moves[(count-2*(count_delete_t))/2][0];
					end 
					else if(count == 20) begin
						triangle_moves3[83:80] = triangle_moves[(count-2*(count_delete_t))/2][0];
						triangle_moves3[87:84] = triangle_moves[(count-2*(count_delete_t))/2][0];
					end 
					else if(count == 22) begin
						triangle_moves3[91:88] = x_coordinate;
						triangle_moves3[95:92] = y_coordinate;
					end 
						count = count+1;
					end
					
				else begin //Circle
					for(i=0; i<10; i=i+1) begin
						x_difference[i] = 0;
						x_control[i] = 0;
						y_difference[i] = 0;
						y_control[i] = 0;
						cross_control[i] = 0;
					end
					
					if((count%6==5) && (count!=5) && (count!=17)) begin
						blocked_squares[count-10][0] = circle_moves[0][0];
						blocked_squares[count-10][1] = circle_moves[0][1];
						
						count_delete_c = count_delete_c+1;	
						if(count_delete_c == 1) begin
						circle_moves3[3:0] = 4'b1111;
						circle_moves3[7:4] = 4'b1111;
						blocked_squares3[11:8] = blocked_squares[count-10][0];
						blocked_squares3[15:12] = blocked_squares[count-10][0];
						end
						else if(count_delete_c == 2) begin
						circle_moves3[11:8] = 4'b1111;
						circle_moves3[15:12] = 4'b1111;
						blocked_squares3[27:24] = blocked_squares[count-10][0];
						blocked_squares3[31:28] = blocked_squares[count-10][0];
						end

						for (i = 0; i < 9; i = i + 1) begin
							circle_moves[i][0] = circle_moves[i + 1][0];
							circle_moves[i][1] = circle_moves[i + 1][1];
						end
							circle_moves[((count-1)-2*count_delete_c)/2][0] = x_coordinate;
							circle_moves[((count-1)-2*count_delete_c)/2][1] = y_coordinate;
					end
						else begin
							circle_moves[((count-1)-2*count_delete_c)/2][0] = x_coordinate;
							circle_moves[((count-1)-2*count_delete_c)/2][1] = y_coordinate;
						end
						total_squares[count][0] = x_coordinate;
						total_squares[count][1] = y_coordinate;
						
						for(i=0; i<10; i=i+1) begin

							x_difference[i] = x_coordinate - circle_moves[i][0];
							y_difference[i] = y_coordinate - circle_moves[i][1];

						end
						
					for(i=0; i<10; i=i+1) begin
						if(x_difference[i] == 0) begin
							if(y_difference[i] > 0) begin
								y_control[i] = y_difference[i];
							end
							else begin
								y_control[i] = y_difference[i] * (-1);
							end
						end
						if(y_difference[i] == 0) begin
							if(x_difference[i] > 0) begin
								x_control[i] = x_difference[i];
							end
							else begin
								x_control[i] = x_difference[i] * (-1);
							end
						end
						if((x_difference[i] == y_difference[i]) || ((-1 * x_difference[i]) == y_difference[i])) begin
						if(x_difference[i] > 0) begin
							cross_control[i] = x_difference[i];
						end
						else begin
							cross_control[i] = x_difference[i] * (-1);
						end
						end
					end
					for(j = 0; j<3; j=j+1) begin
						a = 0;
						b = 0;
						c = 0;
						if(j == 0) begin
							for(i = 0; i <10; i=i+1) begin
								if(y_control[i] == 1) a =1;
								if(y_control[i] == 2) b =1;
								if(y_control[i] == 3) c =1;
								if(a && b && c) end_game = 0;
							end
						end
						if(j==1) begin
							for(i = 0; i <10; i=i+1) begin
								if(x_control[i] == 1) a =1;
								if(x_control[i] == 2) b =1;
								if(x_control[i] == 3) c =1;
								if(a && b && c) end_game = 0;
							end
						end
						if(j==2) begin
							for(i = 0; i <10; i=i+1) begin
								if(cross_control[i] == 1) a =1;
								if(cross_control[i] == 2) b =1;
								if(cross_control[i] == 3) c =1;
								if(a && b && c) end_game = 0;
							end
						end
					end
					if(count == 1) begin
						circle_moves3[3:0] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[7:4] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 3) begin
						circle_moves3[11:8] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[15:12] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 5) begin
						circle_moves3[19:16] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[23:20] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 7) begin
						circle_moves3[27:24] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[31:28] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 9) begin
						circle_moves3[35:32] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[39:36] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 11) begin
						circle_moves3[43:40] = x_coordinate;
						circle_moves3[47:44] = y_coordinate;
					end
					if(count == 13) begin
						circle_moves3[51:48] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[55:52] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 15) begin
						circle_moves3[59:56] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[63:60] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 17) begin
						circle_moves3[67:64] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[71:68] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 19) begin
						circle_moves3[75:72] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[79:76] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end
					if(count == 21) begin
						circle_moves3[83:80] = circle_moves[((count-1)-2*count_delete_c)/2][0];
						circle_moves3[87:84] = circle_moves[((count-1)-2*count_delete_c)/2][1];
					end 
					if(count == 23) begin
						circle_moves3[91:88] = x_coordinate;
						circle_moves3[95:92] = y_coordinate;
					end 
						count = count+1;
					end
					
			if(count == 25) end_game = 2;
			
			if(current_player == 1) begin
				current_player = 0;
			end 
			else if(current_player == 0) begin
				current_player = 1;
			end 
			
			end
	end
end
assign triangle_moves2 = triangle_moves3;
assign circle_moves2 = circle_moves3;
assign blocked_squares2 = blocked_squares3;
assign current_player2 = current_player;
assign count2 = count;
assign end_game2 = end_game;
assign count_delete_t_out = count_delete_t;
endmodule