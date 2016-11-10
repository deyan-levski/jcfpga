isim force add {/adc_ctrl/clock} 0 -radix bin -value 1 -radix bin -time 5 ns -repeat 10 ns
isim force add {/adc_ctrl/reset} 1 -radix bin 
run 1.00us
isim force add {/adc_ctrl/reset} 0 -radix bin 
run 50.00us
