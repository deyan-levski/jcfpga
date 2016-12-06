#!/usr/bin/sh
#|------------------------------------------------------------------|
#| ADC Testchip UART sequencer RAM loader                           |
#|------------------------------------------------------------------|
#| Version P1A, Deyan Levski, deyan.levski@eng.ox.ac.uk, 27.11.2016 |
#|------------------------------------------------------------------|
#|
#
# Usage: sh sendUART.sh instr.coe 2400 /dev/ttyUSB0 
#
#
#

update_progress_bar()
{
  if [ $# -eq 3 ];
  then
    if [[ $1 == [0-9]* ]];
    then
      if [ $1 -ge 0 ];
      then
        if [ $1 -le 100 ];
        then
          local val=$1
          local max=100

          echo -n "["

          for j in $(seq $max);
          do
            if [ $j -lt $val ];
            then
              echo -n "="
            else
              if [ $j -eq $max ];
              then
                echo -n "]"
              else
                echo -n "."
              fi
            fi
          done

          echo -ne "Byte: $2, $3 "$val"%\r"

          if [ $val -eq $max ];
          then
            echo ""
          fi
        fi
      fi
    fi
  fi
}

ttyPort=$3
silenceTime="0.05"

word=$1
rate=$2
device=$3
clear
echo -ne "|----------------------------------------------------|
| asm2uart2ram (ASM to UART to RAM)                  |
|----------------------------------------------------|
| Version A, Deyan Levski, deyan.levski@eng.ox.ac.uk |
|----------------------------------------------------|
\n"

echo -ne "Port is: $ttyPort, Stop bits: 1, Parity: none, Silence time: $silenceTime, Speed: "

stty -F $device speed $rate cs8 -echo  ## Set port settings

size=`wc -c < $word`
echo -ne "\nRAM size: $(($size/2)) bytes \n\n"

start_byte="AE"
stop_byte="AF"

echo -ne "Start Byte: $start_byte \n"
echo -en "\x$start_byte" > $device
sleep $silenceTime

for (( c=1; c<=$size; c += 2 ))
do  
cb=$c
ce=`expr $c + 1`
c2=$(($c / 2))
cpbar=$(echo "$c/$size*100" | bc -l) # calc %
cpbar=$(echo "($cpbar+0.5)/1" | bc ) # round to nearest int

cutwhat=`echo -c$cb-$ce`
byte=`cat $word | cut $cutwhat`
echo -en "\x$byte" > $device
sleep $silenceTime

update_progress_bar $cpbar $c2 $byte

done

c2=$(($c2+1))

echo -ne "\nStop Byte: $c2    , $stop_byte \n"
echo -en "\x$stop_byte" > $device
echo -ne " \n"

#update_progress_bar 0
#update_progress_bar 100
