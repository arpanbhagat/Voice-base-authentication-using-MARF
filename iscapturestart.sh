lcd=/home/pi/CopyLCD/Adafruit_CharLCD/Adafruit_CharLCD.py
lcdcmd="sudo python $lcd"

cd /home/pi/speech/Recorder/
n=$(cat testfile|wc -l)
while [ $n -eq 0 ];
do
	n=$(cat testfile|wc -l)
done
>testfile
cd /home/pi/
echo "capturing started"
$lcdcmd
cat lcdfile
>lcdfile

