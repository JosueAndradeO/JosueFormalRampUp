module fifo(data_in,w,r,clk,rst,empty,full,data_out,count);
  input [7:0]data_in;
  input rst,clk,w,r;
  output empty,full;
  output reg [7:0]data_out;
  reg [7:0]mem[15:0];
  reg [3:0]wn,wp;
  output reg [3:0]count;
  assign full=(count==15)?1:0;
  assign empty=(count==0)?1:0;
  /*assign empty = ((wn - wp) == 0) ? 1'b1 : 1'b0; 
  
  assign full = ((wn-wp) == 15) ? 1'b1 : 1'b0; */
  always@(posedge clk)
    begin
      if(rst)
        begin
          for(int i=0;i<=16;i++)
            begin
              mem[i]<=0;
              data_out=0;
            end
          count=0;
          wn=0;
          wp=0;
        end
      else
        begin
         if(w && ~empty && ~full && r)
            begin
              mem[wn]<=data_in;
               wn=wn+1;
              data_out=mem[wp];
              wp=wp+1;
              count<=count;
            end
          /*else if(w && empty && ~full && ~r)
          begin
            wn=wn+1;
            mem[wn]=data_in;
            wp=wp;
            data_out=mem[wp];
            count=count+1;
          end
          else if(r && full && ~empty && ~w)
            begin
              wp=wp+1;
              data_out=mem[wp];
              count=count-1;
            end*/
          
           else if( w && ~full)
            begin
              mem[wn]<=data_in;
               wn<=wn+1;
              count<=count+1;
            end
            /*else 
              wn=wn;*/
          
           else if  (r && ~empty)
            begin
              data_out<=mem[wp];
                wp<=wp+1;
              count<=count-1;
            end
          
           /* else
              wp=wp;*/
      else
        begin
          wn<=wn;
          wp<=wp;
          count<=count;
        end
        end
    end
endmodule

`include "test"
`include "interface"

module tb;
  
  bit clk;
 // bit rst = 1;
  
  intf vif(clk,rst);
  test  t1(vif);
  
  initial
    clk=1'b0;
  
  
  always #5 clk=~clk;
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
  
  fifo f1(.data_in(vif.data_in),.w(vif.w),.r(vif.r),.clk(vif.clk),.rst(vif.rst),.empty(vif.empty),.full(vif.full),.data_out(vif.data_out),.count(vif.count));
  
endmodule