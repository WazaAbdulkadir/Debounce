`timescale 1ns / 1ps


module test();

reg clk;
reg rst;

reg sw_signal;

always # 10 clk = ~clk;

debounce_state_machine dut (.clk(clk), .rst(rst) ,.sw_signal(sw_signal) ); 

initial begin

clk = 1; 
rst = 1;
#30;

rst = 0;
#10;

sw_signal = 1;
#100000; // 100 us

sw_signal = 0;
#50;

sw_signal  = 1;
#750000 // 750 us;

sw_signal = 0;
#50;


sw_signal  = 1;
#12500000 // 1.250 us = 1.25 ms;

sw_signal = 0;
#50;


$finish;
end 
 
endmodule
