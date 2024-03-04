module b21 (
  input clock,
  input reset,
  input [31:0] si,
  output reg  [19:0] so,
  output reg  rd,
  output reg  wr) ; 
   wire [19:0] ad1 ;  
   wire [19:0] ad2 ;  
   integer di1 ;  
   integer di2 ;  
   wire [31:0] do1 ;  
   wire [31:0] do2 ;  
   wire r1 ;  
   wire r2 ;  
   wire w1 ;  
   wire w2 ;  
  
wire  P1_clock;
wire  P1_reset;
reg [19:0] P1_addr;
wire [31:0] P1_datai;
integer P1_datao;
reg  P1_rd;
reg  P1_wr;
 
 parameter P1_FETCH =0; 
 parameter P1_EXEC =1; 
   reg[1:0] P1_s ; 
   integer P1_temp ; 
   integer P1_d ; 
   integer P1_t ; 
   integer P1_m ; 
   integer P1_r ; 
   reg[0:0] P1_state ; 
   integer P1_IR ; 
   reg[19:0] P1_tail ; 
   reg[3:0] P1_ff ; 
   reg[0:0] P1_cf ; 
   reg[2:0] P1_df ; 
   reg[1:0] P1_mf ; 
   integer P1_MBR ; 
   reg[19:0] P1_MAR ; 
   reg P1_B ; 
   integer P1_reg3 ; 
   integer P1_reg2 ; 
   integer P1_reg1 ; 
   integer P1_reg0 ; 
  always @(  posedge   P1_clock or posedge  P1_reset )
       begin : P1_xhdl0 
         if ( P1_reset ==1'b1)
            begin 
               P1_MAR  =0;
               P1_MBR  =0;
               P1_IR  =0;
               P1_d  =0;
               P1_r  =0;
               P1_m  =0;
               P1_s  =0;
               P1_temp  =0;
               P1_mf  =0;
               P1_df  =0;
               P1_ff  =0;
               P1_cf  =0;
               P1_tail  =0;
               P1_B  =1'b0;
               P1_reg0  =0;
               P1_reg1  =0;
               P1_reg2  =0;
               P1_reg3  =0;
               P1_addr  <=0;
               P1_rd  <=1'b0;
               P1_wr  <=1'b0;
               P1_datao  <=0;
               P1_state  = P1_FETCH ;
            end 
          else 
            begin 
               P1_rd  <=1'b0;
               P1_wr  <=1'b0;
              case ( P1_state )
                P1_FETCH  :
                  begin 
                     P1_MAR  = P1_reg3 %2**20;
                     P1_addr  <= P1_MAR ;
                     P1_rd  <=1'b1;
                     P1_MBR  = P1_datai ;
                     P1_IR  = P1_MBR ;
                     P1_state  = P1_EXEC ;
                  end 
                P1_EXEC  :
                  begin 
                    if ( P1_IR <0)
                        P1_IR  =- P1_IR ;
                     P1_mf  =( P1_IR /2**27)%4;
                     P1_df  =( P1_IR /2**24)%2**3;
                     P1_ff  =( P1_IR /2**19)%2**4;
                     P1_cf  =( P1_IR /2**23)%2;
                     P1_tail  = P1_IR %2**20;
                     P1_reg3  =(( P1_reg3 %2**29)+8);
                     P1_s  =( P1_IR /2**29)%4;
                    case ( P1_s )
                     0 :
                         P1_r  = P1_reg0 ;
                     1 :
                         P1_r  = P1_reg1 ;
                     2 :
                         P1_r  = P1_reg2 ;
                     3 :
                         P1_r  = P1_reg3 ;
                    endcase 
                    case ( P1_cf )
                     1 :
                        begin 
                          case ( P1_mf )
                           0 :
                               P1_m  = P1_tail ;
                           1 :
                              begin 
                                 P1_m  = P1_datai ;
                                 P1_addr  <= P1_tail ;
                                 P1_rd  <=1'b1;
                              end 
                           2 :
                              begin 
                                 P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                 P1_rd  <=1'b1;
                                 P1_m  = P1_datai ;
                              end 
                           3 :
                              begin 
                                 P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                 P1_rd  <=1'b1;
                                 P1_m  = P1_datai ;
                              end 
                          endcase 
                          case ( P1_ff )
                           0 :
                              if ( P1_r < P1_m )
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           1 :
                              if (~( P1_r < P1_m ))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           2 :
                              if ( P1_r == P1_m )
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           3 :
                              if (~( P1_r == P1_m ))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           4 :
                              if (~( P1_r > P1_m ))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           5 :
                              if ( P1_r > P1_m )
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           6 :
                              begin 
                                if ( P1_r >2**30-1)
                                    P1_r  = P1_r -2**30;
                                if ( P1_r < P1_m )
                                    P1_B  =1'b1;
                                 else 
                                    P1_B  =1'b0;
                              end 
                           7 :
                              begin 
                                if ( P1_r >2**30-1)
                                    P1_r  = P1_r -2**30;
                                if (~( P1_r < P1_m ))
                                    P1_B  =1'b1;
                                 else 
                                    P1_B  =1'b0;
                              end 
                           8 :
                              if (( P1_r < P1_m )|( P1_B ==1'b1))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           9 :
                              if ((~( P1_r < P1_m ))|( P1_B ==1'b1))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           10 :
                              if (( P1_r == P1_m )|( P1_B ==1'b1))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           11 :
                              if ((~( P1_r == P1_m ))|( P1_B ==1'b1))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           12 :
                              if ((~( P1_r > P1_m ))|( P1_B ==1'b1))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           13 :
                              if (( P1_r > P1_m )|( P1_B ==1'b1))
                                  P1_B  =1'b1;
                               else 
                                  P1_B  =1'b0;
                           14 :
                              begin 
                                if ( P1_r >2**30-1)
                                    P1_r  = P1_r -2**30;
                                if (( P1_r < P1_m )|( P1_B ==1'b1))
                                    P1_B  =1'b1;
                                 else 
                                    P1_B  =1'b0;
                              end 
                           15 :
                              begin 
                                if ( P1_r >2**30-1)
                                    P1_r  = P1_r -2**30;
                                if ((~( P1_r < P1_m ))|( P1_B ==1'b1))
                                    P1_B  =1'b1;
                                 else 
                                    P1_B  =1'b0;
                              end 
                          endcase 
                        end 
                     0 :
                        if (~( P1_df ==7))
                           begin 
                             if ( P1_df ==5)
                                begin 
                                  if ((~( P1_B ))==1'b1)
                                      P1_d  =3;
                                end 
                              else 
                                if ( P1_df ==4)
                                   begin 
                                     if ( P1_B ==1'b1)
                                         P1_d  =3;
                                   end 
                                 else 
                                   if ( P1_df ==3)
                                       P1_d  =3;
                                    else 
                                      if ( P1_df ==2)
                                          P1_d  =2;
                                       else 
                                         if ( P1_df ==1)
                                             P1_d  =1;
                                          else 
                                            if ( P1_df ==0)
                                                P1_d  =0;
                             case ( P1_ff )
                              0 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                    P1_t  =0;
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  = P1_t - P1_m ;
                                    1 :
                                        P1_reg1  = P1_t - P1_m ;
                                    2 :
                                        P1_reg2  = P1_t - P1_m ;
                                    3 :
                                        P1_reg3  = P1_t - P1_m ;
                                    default :;
                                   endcase 
                                 end 
                              1 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                    P1_reg2  = P1_reg3 ;
                                    P1_reg3  = P1_m ;
                                 end 
                              2 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  = P1_m ;
                                    1 :
                                        P1_reg1  = P1_m ;
                                    2 :
                                        P1_reg2  = P1_m ;
                                    3 :
                                        P1_reg3  = P1_m ;
                                    default :;
                                   endcase 
                                 end 
                              3 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  = P1_m ;
                                    1 :
                                        P1_reg1  = P1_m ;
                                    2 :
                                        P1_reg2  = P1_m ;
                                    3 :
                                        P1_reg3  = P1_m ;
                                    default :;
                                   endcase 
                                 end 
                              4 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r + P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r + P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r + P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r + P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              5 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r + P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r + P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r + P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r + P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              6 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r - P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r - P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r - P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r - P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              7 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r - P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r - P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r - P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r - P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              8 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r + P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r + P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r + P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r + P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              9 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r - P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r - P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r - P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r - P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              10 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r + P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r + P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r + P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r + P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              11 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_m  = P1_tail ;
                                    1 :
                                       begin 
                                          P1_m  = P1_datai ;
                                          P1_addr  <= P1_tail ;
                                          P1_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg1 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P1_addr  <=( P1_tail + P1_reg2 )%2**20;
                                          P1_rd  <=1'b1;
                                          P1_m  = P1_datai ;
                                       end 
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  =( P1_r - P1_m )%2**30;
                                    1 :
                                        P1_reg1  =( P1_r - P1_m )%2**30;
                                    2 :
                                        P1_reg2  =( P1_r - P1_m )%2**30;
                                    3 :
                                        P1_reg3  =( P1_r - P1_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              12 :
                                 begin 
                                   case ( P1_mf )
                                    0 :
                                        P1_t  = P1_r /2;
                                    1 :
                                       begin 
                                          P1_t  = P1_r /2;
                                         if ( P1_B ==1'b1)
                                             P1_t  = P1_t %2**29;
                                       end 
                                    2 :
                                        P1_t  =( P1_r %2**29)*2;
                                    3 :
                                       begin 
                                          P1_t  =( P1_r %2**29)*2;
                                         if ( P1_t >2**30-1)
                                             P1_B  =1'b1;
                                          else 
                                             P1_B  =1'b0;
                                       end 
                                    default :;
                                   endcase 
                                   case ( P1_d )
                                    0 :
                                        P1_reg0  = P1_t ;
                                    1 :
                                        P1_reg1  = P1_t ;
                                    2 :
                                        P1_reg2  = P1_t ;
                                    3 :
                                        P1_reg3  = P1_t ;
                                    default :;
                                   endcase 
                                 end 
                              13 ,14,15:;
                             endcase 
                           end 
                         else 
                           if ( P1_df ==7)
                              begin 
                                case ( P1_mf )
                                 0 :
                                     P1_m  = P1_tail ;
                                 1 :
                                     P1_m  = P1_tail ;
                                 2 :
                                     P1_m  =( P1_reg1 %2**20)+( P1_tail %2**20);
                                 3 :
                                     P1_m  =( P1_reg2 %2**20)+( P1_tail %2**20);
                                endcase 
                                 P1_addr  <= P1_m %2*20;
                                 P1_wr  <=1'b1;
                                 P1_datao  <= P1_r ;
                              end 
                    endcase 
                     P1_state  = P1_FETCH ;
                  end 
              endcase 
            end 
       end
 
assign P1_clock = clock;
assign P1_reset = reset;
assign ad1 = P1_addr;
assign P1_datai = di1;
assign do1 = P1_datao;
assign r1 = P1_rd;
assign w1 = P1_wr;
 
  
wire  P2_clock;
wire  P2_reset;
reg [19:0] P2_addr;
wire [31:0] P2_datai;
integer P2_datao;
reg  P2_rd;
reg  P2_wr;
 
 parameter P2_FETCH =0; 
 parameter P2_EXEC =1; 
   reg[1:0] P2_s ; 
   integer P2_temp ; 
   integer P2_d ; 
   integer P2_t ; 
   integer P2_m ; 
   integer P2_r ; 
   reg[0:0] P2_state ; 
   integer P2_IR ; 
   reg[19:0] P2_tail ; 
   reg[3:0] P2_ff ; 
   reg[0:0] P2_cf ; 
   reg[2:0] P2_df ; 
   reg[1:0] P2_mf ; 
   integer P2_MBR ; 
   reg[19:0] P2_MAR ; 
   reg P2_B ; 
   integer P2_reg3 ; 
   integer P2_reg2 ; 
   integer P2_reg1 ; 
   integer P2_reg0 ; 
  always @(  posedge   P2_clock or posedge  P2_reset )
       begin : P2_xhdl1 
         if ( P2_reset ==1'b1)
            begin 
               P2_MAR  =0;
               P2_MBR  =0;
               P2_IR  =0;
               P2_d  =0;
               P2_r  =0;
               P2_m  =0;
               P2_s  =0;
               P2_temp  =0;
               P2_mf  =0;
               P2_df  =0;
               P2_ff  =0;
               P2_cf  =0;
               P2_tail  =0;
               P2_B  =1'b0;
               P2_reg0  =0;
               P2_reg1  =0;
               P2_reg2  =0;
               P2_reg3  =0;
               P2_addr  <=0;
               P2_rd  <=1'b0;
               P2_wr  <=1'b0;
               P2_datao  <=0;
               P2_state  = P2_FETCH ;
            end 
          else 
            begin 
               P2_rd  <=1'b0;
               P2_wr  <=1'b0;
              case ( P2_state )
                P2_FETCH  :
                  begin 
                     P2_MAR  = P2_reg3 %2**20;
                     P2_addr  <= P2_MAR ;
                     P2_rd  <=1'b1;
                     P2_MBR  = P2_datai ;
                     P2_IR  = P2_MBR ;
                     P2_state  = P2_EXEC ;
                  end 
                P2_EXEC  :
                  begin 
                    if ( P2_IR <0)
                        P2_IR  =- P2_IR ;
                     P2_mf  =( P2_IR /2**27)%4;
                     P2_df  =( P2_IR /2**24)%2**3;
                     P2_ff  =( P2_IR /2**19)%2**4;
                     P2_cf  =( P2_IR /2**23)%2;
                     P2_tail  = P2_IR %2**20;
                     P2_reg3  =(( P2_reg3 %2**29)+8);
                     P2_s  =( P2_IR /2**29)%4;
                    case ( P2_s )
                     0 :
                         P2_r  = P2_reg0 ;
                     1 :
                         P2_r  = P2_reg1 ;
                     2 :
                         P2_r  = P2_reg2 ;
                     3 :
                         P2_r  = P2_reg3 ;
                    endcase 
                    case ( P2_cf )
                     1 :
                        begin 
                          case ( P2_mf )
                           0 :
                               P2_m  = P2_tail ;
                           1 :
                              begin 
                                 P2_m  = P2_datai ;
                                 P2_addr  <= P2_tail ;
                                 P2_rd  <=1'b1;
                              end 
                           2 :
                              begin 
                                 P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                 P2_rd  <=1'b1;
                                 P2_m  = P2_datai ;
                              end 
                           3 :
                              begin 
                                 P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                 P2_rd  <=1'b1;
                                 P2_m  = P2_datai ;
                              end 
                          endcase 
                          case ( P2_ff )
                           0 :
                              if ( P2_r < P2_m )
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           1 :
                              if (~( P2_r < P2_m ))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           2 :
                              if ( P2_r == P2_m )
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           3 :
                              if (~( P2_r == P2_m ))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           4 :
                              if (~( P2_r > P2_m ))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           5 :
                              if ( P2_r > P2_m )
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           6 :
                              begin 
                                if ( P2_r >2**30-1)
                                    P2_r  = P2_r -2**30;
                                if ( P2_r < P2_m )
                                    P2_B  =1'b1;
                                 else 
                                    P2_B  =1'b0;
                              end 
                           7 :
                              begin 
                                if ( P2_r >2**30-1)
                                    P2_r  = P2_r -2**30;
                                if (~( P2_r < P2_m ))
                                    P2_B  =1'b1;
                                 else 
                                    P2_B  =1'b0;
                              end 
                           8 :
                              if (( P2_r < P2_m )|( P2_B ==1'b1))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           9 :
                              if ((~( P2_r < P2_m ))|( P2_B ==1'b1))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           10 :
                              if (( P2_r == P2_m )|( P2_B ==1'b1))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           11 :
                              if ((~( P2_r == P2_m ))|( P2_B ==1'b1))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           12 :
                              if ((~( P2_r > P2_m ))|( P2_B ==1'b1))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           13 :
                              if (( P2_r > P2_m )|( P2_B ==1'b1))
                                  P2_B  =1'b1;
                               else 
                                  P2_B  =1'b0;
                           14 :
                              begin 
                                if ( P2_r >2**30-1)
                                    P2_r  = P2_r -2**30;
                                if (( P2_r < P2_m )|( P2_B ==1'b1))
                                    P2_B  =1'b1;
                                 else 
                                    P2_B  =1'b0;
                              end 
                           15 :
                              begin 
                                if ( P2_r >2**30-1)
                                    P2_r  = P2_r -2**30;
                                if ((~( P2_r < P2_m ))|( P2_B ==1'b1))
                                    P2_B  =1'b1;
                                 else 
                                    P2_B  =1'b0;
                              end 
                          endcase 
                        end 
                     0 :
                        if (~( P2_df ==7))
                           begin 
                             if ( P2_df ==5)
                                begin 
                                  if ((~( P2_B ))==1'b1)
                                      P2_d  =3;
                                end 
                              else 
                                if ( P2_df ==4)
                                   begin 
                                     if ( P2_B ==1'b1)
                                         P2_d  =3;
                                   end 
                                 else 
                                   if ( P2_df ==3)
                                       P2_d  =3;
                                    else 
                                      if ( P2_df ==2)
                                          P2_d  =2;
                                       else 
                                         if ( P2_df ==1)
                                             P2_d  =1;
                                          else 
                                            if ( P2_df ==0)
                                                P2_d  =0;
                             case ( P2_ff )
                              0 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                    P2_t  =0;
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  = P2_t - P2_m ;
                                    1 :
                                        P2_reg1  = P2_t - P2_m ;
                                    2 :
                                        P2_reg2  = P2_t - P2_m ;
                                    3 :
                                        P2_reg3  = P2_t - P2_m ;
                                    default :;
                                   endcase 
                                 end 
                              1 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                    P2_reg2  = P2_reg3 ;
                                    P2_reg3  = P2_m ;
                                 end 
                              2 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  = P2_m ;
                                    1 :
                                        P2_reg1  = P2_m ;
                                    2 :
                                        P2_reg2  = P2_m ;
                                    3 :
                                        P2_reg3  = P2_m ;
                                    default :;
                                   endcase 
                                 end 
                              3 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  = P2_m ;
                                    1 :
                                        P2_reg1  = P2_m ;
                                    2 :
                                        P2_reg2  = P2_m ;
                                    3 :
                                        P2_reg3  = P2_m ;
                                    default :;
                                   endcase 
                                 end 
                              4 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r + P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r + P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r + P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r + P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              5 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r + P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r + P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r + P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r + P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              6 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r - P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r - P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r - P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r - P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              7 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r - P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r - P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r - P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r - P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              8 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r + P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r + P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r + P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r + P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              9 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r - P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r - P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r - P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r - P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              10 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r + P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r + P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r + P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r + P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              11 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_m  = P2_tail ;
                                    1 :
                                       begin 
                                          P2_m  = P2_datai ;
                                          P2_addr  <= P2_tail ;
                                          P2_rd  <=1'b1;
                                       end 
                                    2 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg1 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                    3 :
                                       begin 
                                          P2_addr  <=( P2_tail + P2_reg2 )%2**20;
                                          P2_rd  <=1'b1;
                                          P2_m  = P2_datai ;
                                       end 
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  =( P2_r - P2_m )%2**30;
                                    1 :
                                        P2_reg1  =( P2_r - P2_m )%2**30;
                                    2 :
                                        P2_reg2  =( P2_r - P2_m )%2**30;
                                    3 :
                                        P2_reg3  =( P2_r - P2_m )%2**30;
                                    default :;
                                   endcase 
                                 end 
                              12 :
                                 begin 
                                   case ( P2_mf )
                                    0 :
                                        P2_t  = P2_r /2;
                                    1 :
                                       begin 
                                          P2_t  = P2_r /2;
                                         if ( P2_B ==1'b1)
                                             P2_t  = P2_t %2**29;
                                       end 
                                    2 :
                                        P2_t  =( P2_r %2**29)*2;
                                    3 :
                                       begin 
                                          P2_t  =( P2_r %2**29)*2;
                                         if ( P2_t >2**30-1)
                                             P2_B  =1'b1;
                                          else 
                                             P2_B  =1'b0;
                                       end 
                                    default :;
                                   endcase 
                                   case ( P2_d )
                                    0 :
                                        P2_reg0  = P2_t ;
                                    1 :
                                        P2_reg1  = P2_t ;
                                    2 :
                                        P2_reg2  = P2_t ;
                                    3 :
                                        P2_reg3  = P2_t ;
                                    default :;
                                   endcase 
                                 end 
                              13 ,14,15:;
                             endcase 
                           end 
                         else 
                           if ( P2_df ==7)
                              begin 
                                case ( P2_mf )
                                 0 :
                                     P2_m  = P2_tail ;
                                 1 :
                                     P2_m  = P2_tail ;
                                 2 :
                                     P2_m  =( P2_reg1 %2**20)+( P2_tail %2**20);
                                 3 :
                                     P2_m  =( P2_reg2 %2**20)+( P2_tail %2**20);
                                endcase 
                                 P2_addr  <= P2_m %2**20;
                                 P2_wr  <=1'b1;
                                 P2_datao  <= P2_r ;
                              end 
                    endcase 
                     P2_state  = P2_FETCH ;
                  end 
              endcase 
            end 
       end
 
assign P2_clock = clock;
assign P2_reset = reset;
assign ad2 = P2_addr;
assign P2_datai = di2;
assign do2 = P2_datao;
assign r2 = P2_rd;
assign w2 = P2_wr;
 
  always @(         ad1 or  ad2 or  r1 or  r2 or  w1 or  w2 or  do1 or  do2 or  si)
       begin 
         so <=(ad1+ad2)%2**20;
         rd <=r1^(~r2);
         wr <=w1^(~w2);
         if ((ad1<2**19&ad2<2**19&r1==1'b0)|(ad1>2**19-1&ad2>2**19-1&r2==1'b0))
            begin 
              di1 <=do2+si;
              di2 <=do1;
            end 
          else 
            begin 
              di1 <=do2;
              di2 <=do1+si;
            end 
       end
  
endmodule
