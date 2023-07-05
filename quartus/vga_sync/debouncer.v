module debouncer(clk,one, zero, start, reset,LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7);

input clk, one, zero,start,reset;
reg [9:0] one_buf;
reg [9:0] zero_buf;
reg [9:0] start_buf;
reg [9:0] reset_buf;
reg [7:0] my_input;
reg [4:0] input_col;
reg [4:0] input_row;
reg [31:0] counter;
reg [31:0] state;
assign LED0 = my_input[0];
assign LED1 = my_input[1];
assign LED2 = my_input[2];
assign LED3 = my_input[3];
assign LED4 = my_input[4];
assign LED5 = my_input[5];
assign LED6 = my_input[6];
assign LED7 = my_input[7];
output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7;
always @(negedge clk)
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
			counter=0;
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
		my_input = 0;
		state = 0;
		end
		
	endcase
end
endmodule