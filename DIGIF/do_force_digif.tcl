isim force add {/digif/d_digif_sck} 1 -radix bin -value 0 -radix bin -time 2 ns -repeat 4 ns
isim force add {/digif/d_digif_rst} 1 -radix bin
run 1.00us
isim force add {/digif/d_digif_rst} 0 -radix bin


