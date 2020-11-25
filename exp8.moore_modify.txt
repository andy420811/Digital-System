module exp8(clock,pause,reset,in,out);
    input clock,pause,reset,in;
    output [6:0] out;
    wire pulse;
    wire [3:0] data;
    
    clk_div c1(.clock(clock),.pause(pause),.pulse(pulse));
    Moore_Machine m1(.pulse(pulse),.reset(reset),.in(in),.data(data));
    seven_seg s1(.data_in(data), .seg_out(out));
    
endmodule

module Moore_Machine(pulse,reset,in,data);
    input pulse,reset,in;
    output reg [3:0] data;
	 reg [3:0] cur_state;
	 reg [3:0] next_state;
	 

	 
    always @(*)
    begin
		 case(cur_state)
			4'd0:if(in) next_state = 4'd1; else next_state = 4'd0;
			4'd1:if(in) next_state = 4'd2; else next_state = 4'd0;
			4'd2:if(in) next_state = 4'd4; else next_state = 4'd3;
			4'd3:if(in) next_state = 4'd3; else next_state = 4'd4;
			4'd4:if(in) next_state = 4'd5; else next_state = 4'd1;
   			4'd5:if(in) next_state = 4'd5; else next_state = 4'd2;
		 endcase
    end
	 
    always @(posedge pulse, negedge reset)
    begin
	 if(!reset) cur_state <= 4'd0;
	 else cur_state <= next_state;
    end
	 
	 
    always @(*)
    begin
        case(cur_state)
		  4'd0:data <= 4'd0;
		  4'd1:data <= 4'd1;
		  4'd2:data <= 4'd2;
		  4'd3:data <= 4'd3;
		  4'd4:data <= 4'd4;
		  4'd5:data <= 4'd5;
		  endcase
    end
    
endmodule

module clk_div(clock,pause,pulse);
    input clock,pause;
    output reg pulse;
    reg [31:0] cnt;
    
    always @(posedge clock)
    begin
        if(~pause)
        begin 
            cnt <= cnt + 32'd1;
            if(cnt == 25000000)
            begin
                pulse <= pulse + 1'd1;
                cnt <= 32'd0;
            end
        end
    end
endmodule

module seven_seg( data_in, seg_out );
 
 input wire [3:0] data_in;
 output reg[6:0] seg_out;
 
always@( data_in )
 case( data_in )
 4'h0 : seg_out = 7'b100_0000;
 4'h1 : seg_out = 7'b111_1001;
 4'h2 : seg_out = 7'b010_0100;
 4'h3 : seg_out = 7'b011_0000;
 4'h4 : seg_out = 7'b001_1001;
 4'h5 : seg_out = 7'b001_0010;
 4'h6 : seg_out = 7'b000_0010;
 4'h7 : seg_out = 7'b111_1000;
 4'h8 : seg_out = 7'b000_0000;
 4'h9 : seg_out = 7'b001_0000;
 4'ha : seg_out = 7'b000_1000;
 4'hb : seg_out = 7'b000_0011;
 4'hc : seg_out = 7'b100_0110;
 4'hd : seg_out = 7'b010_0001;
 4'he : seg_out = 7'b000_0110;
 default : seg_out =7'b000_1110;
 endcase
 
endmodule