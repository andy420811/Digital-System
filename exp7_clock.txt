module exp7 ( sel, reset, clk, out );
    input sel,clk,reset;
    output [6:0] out;
    wire [3:0] cnt;
    counter q1( .sel(sel),.reset(reset),.clk(clk),.W_cnt(cnt));
    seven_seg q2( .data_in(cnt), .seg_out(out) );
    
    
endmodule

module counter( sel,reset,clk,W_cnt);
    input sel,reset,clk;
    reg [3:0] out;
    output wire [3:0] W_cnt;
    assign W_cnt = out;
    reg [31:0] cnt;
    always @(  posedge clk)
    begin
    
    if(!reset) 
	 begin 
		cnt <= 32'd0; 
	 end
    else
	 begin
    cnt <= cnt + 32'd1;    
		if(cnt == 50000000)
			if(sel)
			begin 
			out <= out + 32'd1;
			cnt <= 32'd0;
			end
			else
			begin 
			out <= out - 32'd1;
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