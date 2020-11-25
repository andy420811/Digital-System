module lab9(clk,reset,out_seven,out_dot_col,out_dot_row);

input clk,reset;
wire pulse1,pulse2;
output [6:0] out_seven;
wire [3:0] count;
wire [1:0] state;
output [7:0] out_dot_col,out_dot_row;

clk_div c1(clk,pulse1,pulse2);
Traffic t1(pulse1,pulse2,count,state);
seven_seg d1(count,out_seven);
Dot_Matrix d2(pulse2,reset, state ,out_dot_col,out_dot_row);

endmodule

module Traffic(pulse1,pulse2,reset,count,state);
input pulse1,pulse2,reset;
output reg [3:0] count;
output reg [1:0] state;
reg [1:0] next_state;


always @(posedge pulse1,negedge reset)begin
	if(~reset)begin count <= 4'd0; state <= 2'd0; end
	else begin
		count <= count + 4'd0;
		case(state)
		2'd0 : 
			if (count == 15)
				begin
				next_state <= 2'd1;
				count <= 4'd0;
				end
		2'd1 : 
			if (count == 5)
				begin
				next_state <= 2'd2;
				count <= 4'd0;
				end
		2'd2 : 
			if (count == 10)
				begin
				next_state <= 2'd0;
				count <= 4'd0;
				end
			2'd3 : next_state <= 2'd3;
		endcase
	end
end

endmodule


module clk_div(clock,pulse1,pulse2);
    input clock;
    output reg pulse1,pulse2;
    reg [31:0] cnt1,cnt2;
    
    always @(posedge clock)
    begin
        begin 
            cnt1 <= cnt1 + 32'd1;
				cnt2 <= cnt2 + 32'd1;
            if(cnt1 == 25000000)
            begin
                pulse1 <= pulse1 + 1'd1;
                cnt1 <= 32'd0;
            end
				if(cnt2 == 50)
				begin
					 pulse2 <= pulse2 + 1'd1;
					 cnt2 <= 32'd0;
				end
        end
    end
endmodule

module Dot_Matrix(pulse, reset,state ,out_dot_col,out_dot_row );
	input pulse,reset;
	input [1:0] state;
	output reg [7:0] out_dot_col;
	output reg [7:0] out_dot_row;
	reg [2:0] count;
	
	always @(posedge pulse,negedge reset)begin
		if(~reset)begin
			out_dot_row <= 8'd0;
			out_dot_col <= 8'd0;
			count <= 3'd0;
		end
		else begin
			count <= count + 3'd1;
			case(count)
			3'd0 : out_dot_row <= 8'b01111111;
			3'd1 : out_dot_row <= 8'b10111111;
			3'd2 : out_dot_row <= 8'b11011111;
			3'd3 : out_dot_row <= 8'b11101111;
			3'd4 : out_dot_row <= 8'b11110111;
			3'd5 : out_dot_row <= 8'b11111011;
			3'd6 : out_dot_row <= 8'b11111101;
			3'd7 : out_dot_row <= 8'b11111110;
			endcase
			
			case(state)
			2'd0 : 
				case(count)
				3'd0 : out_dot_col <= 8'b00001100;
				3'd1 : out_dot_col <= 8'b00001100;
				3'd2 : out_dot_col <= 8'b00011001;
				3'd3 : out_dot_col <= 8'b01111110;
				3'd4 : out_dot_col <= 8'b10011000;
				3'd5 : out_dot_col <= 8'b00011000;
				3'd6 : out_dot_col <= 8'b00101000;
				3'd7 : out_dot_col <= 8'b01001000;
				endcase
			2'd1 : 
				case(count)
				3'd0 : out_dot_col <= 8'b00000000;
				3'd1 : out_dot_col <= 8'b00100100;
				3'd2 : out_dot_col <= 8'b00111100;
				3'd3 : out_dot_col <= 8'b10111101;
				3'd4 : out_dot_col <= 8'b11111111;
				3'd5 : out_dot_col <= 8'b00111100;
				3'd6 : out_dot_col <= 8'b00111100;
				3'd7 : out_dot_col <= 8'b00000000;
				endcase
			2'd2 :
				case(count)
				3'd0 : out_dot_col <= 8'b00011000;
				3'd1 : out_dot_col <= 8'b00011000;
				3'd2 : out_dot_col <= 8'b00111100;
				3'd3 : out_dot_col <= 8'b00111100;
				3'd4 : out_dot_col <= 8'b01011010;
				3'd5 : out_dot_col <= 8'b00011000;
				3'd6 : out_dot_col <= 8'b00011000;
				3'd7 : out_dot_col <= 8'b00100100;
				endcase
			2'd3 : 
				case(count)
				3'd0 : out_dot_col <= 8'b01111111;
				3'd1 : out_dot_col <= 8'b10111111;
				3'd2 : out_dot_col <= 8'b11011111;
				3'd3 : out_dot_col <= 8'b11101111;
				3'd4 : out_dot_col <= 8'b11110111;
				3'd5 : out_dot_col <= 8'b11111011;
				3'd6 : out_dot_col <= 8'b11111101;
				3'd7 : out_dot_col <= 8'b11111110;
				endcase
			endcase
		end
		
	end

endmodule

module seven_seg( data_in, seg_out );
 
 input wire [3:0] data_in;
 output reg[6:0] seg_out;
 
always@( data_in )
 case( data_in )
 4'h1 : seg_out = 7'b100_0000;
 4'h2 : seg_out = 7'b111_1001;
 4'h3 : seg_out = 7'b010_0100;
 4'h4 : seg_out = 7'b011_0000;
 4'h5 : seg_out = 7'b001_1001;
 4'h6 : seg_out = 7'b001_0010;
 4'h7 : seg_out = 7'b000_0010;
 4'h8 : seg_out = 7'b111_1000;
 4'h9 : seg_out = 7'b000_0000;
 4'ha : seg_out = 7'b001_0000;
 4'hb : seg_out = 7'b000_1000;
 4'hc : seg_out = 7'b000_0011;
 4'hd : seg_out = 7'b100_0110;
 4'he : seg_out = 7'b010_0001;
 4'h0 : seg_out = 7'b000_0110;
 default : seg_out =7'b000_1110;
 endcase
 
endmodule