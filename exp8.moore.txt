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

    always @(pulse)
    begin
        if(!reset) data <= 4'd0;
        if(in)
        begin
            if(data < 5)
            data <= data + 4'd1;
        end
        else 
        begin
            if(data > 0)
            data <= data - 4'd1;
        end
    end
    
    
endmodule

module clk_div(clock,pause,pulse);
    input clock,pause;
    output reg pulse;
    reg [31:0] cnt;
    
    always @(posedge clock)
    begin
        if(!pause)
        begin 
            cnt <= cnt + 32'd1;
            if(cnt == 50000000)
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
