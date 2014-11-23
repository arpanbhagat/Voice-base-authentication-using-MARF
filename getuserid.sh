lcd=/home/pi/CopyLCD/Adafruit_CharLCD/Adafruit_CharLCD.py
keyval=/home/pi/hexkeypad/myhex.py
lcdcmd="sudo python $lcd"
hexcmd="sudo python $keyval"

useridstr=$(echo "UserID: ")
userid=""
for i in `seq 1 6`;
        do
             key=$($hexcmd)
             echo "Enter 6 Digit ID: ">lcdfile
             useridstr=$useridstr$key
             userid=$userid$key
             echo "$useridstr">>lcdfile
             $lcdcmd
        done
echo "$userid"
