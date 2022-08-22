`timescale 1ns / 1ps


module debounce_state_machine(input clk,
                              input sw_signal,
                              input rst,
                              
                              output reg sw_is_asserted
                              );

parameter initial_value = 1'b0;
parameter clk_freq = 100_000_000;
parameter change_state = 1000;

parameter limit = clk_freq / change_state;

// sayacı başlat.
reg timer_en;
// sayaç çıktı verdi. 
reg timer_tick; 
// 1 ms e kadar sayabilecek timer.  100_000 
// 130 bin küsüre kadar sayabiliyor. 
reg [19:0] timer;

reg [1:0] states;

parameter [2:0] state_initial = 3'b000,
                state_zero = 3'b001,
                state_zero_to_one = 3'b010,
                state_one = 3'b011,
                state_one_to_zero = 3'b100;
                
always @(posedge clk) begin
    
    if (rst) begin
        sw_is_asserted <= 1'b0;
        states <= 2'b0;
        timer_en <= 1'b0;
   
    end 
    else begin
    
    case(states)
    
        state_initial : begin : initial_s
                
                if (initial_value == 1'b0) 
                    states <= state_zero;
                else 
                    states <= state_one;
        
        end : initial_s
       
        
        state_zero: begin
            
             sw_is_asserted <= 1'b0;
              timer_en <= 1'b0;
            if (sw_signal == 1'b1)  begin
                states <= state_zero_to_one;
                //sw_is_asserted <= 1'b0;
                          
            end                 
            else begin 
                states <= state_zero;
                //sw_is_asserted <= 1'b0;                
            end
        end 
        
        
        state_zero_to_one : begin : zero_to_one
            timer_en <= 1'b1;
            sw_is_asserted <= 1'b0; 
            
            if (timer_tick) begin 
                states <= state_one;
                timer_en <= 1'b0;
                // counter burada 0 lanmayaiblir. 
                //timer <= 10'b0;            
            end 
            
            else if (sw_signal == 1) begin
                // sw_is_asserted <= 1'b0; 
                 //timer_en <= 1'b0;
                 states <= state_zero_to_one;
            end 
            
            else begin
                 //sw_is_asserted <= 1'b0; 
                 states <= state_zero;
                 timer_en <= 1'b0;
            end     
                
        
        end : zero_to_one
        
        
        
        state_one : begin : stateone
                
                sw_is_asserted <= 1'b1;
                if (sw_signal == 1'b0) begin
                    states <= state_one_to_zero;
                    
                    timer_en <= 1'b1;
                end 
                
                else begin 
                     states <= state_one;
                end 
             
        
        end : stateone
        
      
       state_one_to_zero : begin : one_to_zero
                
                
           sw_is_asserted <= 1'b0;
           timer_en       <= 1'b1;       
           
            if (timer_tick) begin 
                states <= state_zero; 
                 // counter burada 0 lanmayaiblir. 
                //counter <= 10'b0;
            end 
            
            else if (sw_signal == 1'b1) begin
                // sw_is_asserted <= 1'b0; 
                 states <= state_one;
            end 
            
            else begin
                 //sw_is_asserted <= 1'b0; 
                 states <= state_one_to_zero;
            end     
            
        
        end : one_to_zero 
        
        default : begin 
        states <= 3'b000; 
       // sw_is_asserted <= 1'b0;
        end 
    
    endcase    
   
   end    
   
end 


always @ (posedge clk) begin
    
    if (rst) begin
         timer <= 0;
         timer_tick <= 1'b0;
    end 
    
    else if (timer_en) begin
        
        if (timer -1 == limit) begin 
            timer <= 0;
            timer_tick <= 1'b1;
        end 
        
        else begin
            timer <= timer + 1;
            timer_tick <= 1'b0;
        end 
    end
    
    else begin
       timer_tick <= 1'b0;
       timer <= 0;
    end  
        

end 
      

endmodule
