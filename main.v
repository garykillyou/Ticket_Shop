module ticket_shop( out_cash, out_num, A, B, num, reset, cancel, money, clock, give );

output reg [31:0]out_cash, out_num;
input [3:0]A ;
input [3:0]B ;
input [31:0]num, money ;
input reset, cancel, clock, give ;

parameter S0 = 4'd0,
	      S1 = 4'd1,
		  S2 = 4'd2,
	      S3 = 4'd3 ;
	  
reg [3:0] state ;
reg [3:0] next_state ;
reg [3:0] Aname ;
reg [3:0] Bname ;
reg [31:0] A2Bmoney ;
reg [31:0] moneyGive ;
reg [31:0] moneymoney ;

always @( posedge clock ) begin
  if ( reset ) begin
	next_state = S0 ;
	A2Bmoney = 0 ;
	moneyGive = 0 ;
	moneymoney = 0 ;
  end
  else
	state = next_state ;
end

always @( give ) begin
  moneymoney = money ;
end

always @( state or give ) begin
  case ( state )
    S0: begin
      Aname = A ;
      Bname = B ;
	  $display( "%d: The ticket you chose is S%d to S%d", $time/10, Aname, Bname ) ;
      if ( A < B ) begin
        A2Bmoney = 5 * ( B - A + 1 ) ;
	  end
      else begin
        A2Bmoney = 5 * ( A - B + 1 ) ;
	  $display( "%d: A ticket's price is %d TWD.", $time/10, A2Bmoney ) ;
	  end
      next_state = S1 ;
    end
    S1: begin
	  $display( "%d: You chose %d tickets.", $time/10, num ) ;
      A2Bmoney = A2Bmoney * num ;
      next_state = S2 ;
    end
    S2: begin
	  $display( "%d: You give me %d TWD.", $time/10, moneymoney ) ;
      moneyGive = moneyGive + moneymoney ;
	  $display( "%d: You have given me %d TWD.", $time/10, moneyGive ) ;
	  $display( "%d: You have to give me more than %d TWD.", $time/10, A2Bmoney - moneyGive ) ;
	  if ( cancel ) 
		next_state = S3 ;
      else if ( A2Bmoney > moneyGive )
        next_state = S2 ;
      else 
        next_state = S3 ;
    end
    S3: begin
      if ( cancel ) begin
		$display( "%d: You cancel the step.", $time/10 ) ;
		$display( "%d: The money you have given is %d.\n", $time/10, moneyGive ) ;
	  end
	  else begin
		out_num = num ;
		$display( "%d: These are your %d tickets(S%d to S%d).", $time/10, out_num, Aname, Bname ) ;
		out_cash = moneyGive - A2Bmoney ;
		$display( "%d: And your cash is [%d].\n", $time/10, out_cash ) ;
		
	  end
	  next_state = S0 ;
	  A2Bmoney = 0 ;
	  moneyGive = 0 ;
	  moneymoney = 0 ;
    end
	default: next_state = S0 ;
  endcase
end

endmodule