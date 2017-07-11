module stimulate() ;

wire [31:0]out_cash, out_num;
reg [3:0]A ;
reg [3:0]B ;
reg [31:0]num, money ;
reg reset, cancel, clock, give ;

ticket_shop ticket_shop( out_cash, out_num, A, B, num, reset, cancel, money, clock, give );
						 
initial begin
  A = 0 ;
  B = 0 ;
  num = 0 ;
  cancel = 0 ;
  money = 10 ;
  give = 1'b1 ;
  clock = 1'b1 ;
  forever #5 clock = ~clock ;			 
end

initial begin
  reset = 1'b1 ;
  #5 reset = 1'b0 ;
end

initial begin
  #10 A = 4'd1 ;
	  B = 4'd2 ;
  #10 num = 3 ;
  #10 give = ~give ;
      money = 10 ;
  #10 give = ~give ;
      money = 10 ;
  #10 give = ~give ;
      money = 10 ;
	  
end

endmodule