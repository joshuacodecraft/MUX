// Code your design here
module mux8x1 (in,
sel,
out
);
input [7:0] in;
input [2:0] sel;
output reg out=0;
always@(in, sel)
begin

case (sel)
3'd0 :out = in[0] ;
3'd1 :out = in[1] ;  
3'd2 :out = in[2] ;
3'd3 :out = in[3] ;
3'd4 :out = in[4] ;
  3'd5 :out = in[5]  ;
3'd6 :out = in[6] ;
default:out=in[7];
endcase
end
endmodule
