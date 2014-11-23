####################################################################
#PATH FOR HEXPAD AND LCD PROGRAMS
#PATH FOR JAVA RECORDER AND SPEAKERIDENTIFICATION MODULE
####################################################################

lcd=/home/pi/CopyLCD/Adafruit_CharLCD/Adafruit_CharLCD.py
keyval=/home/pi/hexkeypad/myhex.py
lcdcmd="sudo python $lcd"
hexcmd="sudo python $keyval"
recorder_path=/home/pi/speech/Recorder/
speaker_ident_path=/home/pi/speech/SpeakerIdentification

#############################################################
#ADDING JAR FILE TO CLASSPATH TO EXECUTE JAVA CODES
############################################################

CLASSPATH=$CLASSPATH:/home/pi/speech/marf-0.3.0-devel-20070108-fat.jar:$speaker_ident_path/:recorder_path/
export CLASSPATH

flag=1
val=1
bltime=0.5
echo "we get user for auntheticate"
echo "Enter 6 Digit ID: ">lcdfile
echo "UserID: ">>lcdfile
$lcdcmd
>lcdfile

sleep 1

##########################################################################
# GETTING USERID WITH HEX KEYPAD AND ALSO DISPLAUING IT ON LCD SCREEN
##########################################################################

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
	     >lcdfile
        done
echo "$userid"


###############################################################################
#CHECK FOR GIVEN USERID IS ALRAEDY PRESENT OR NOT AND IF PRESENT THEN EXITING
###############################################################################

ispresent=$(cat $speaker_ident_path/speakers.txt | grep -w "$userid"|wc -l)
if [ $ispresent -eq 0 ] ; then
        echo "UserID is not">lcdfile
	echo "present !!">>lcdfile
	$lcdcmd      
	>lcdfile 
	sudo python /home/pi/redlight.py 2
	sleep 0.5
	exit 1 
fi


###############################################
#GENERATING RANDOM TOKEN FOR USER
###############################################
n1=$RANDOM
let "n1=n1%10"
n2=$RANDOM
let "n2=n2%10"
n3=$RANDOM
let "n3=n3%10"


echo "Random Token">lcdfile
echo "For You: $n1 $n2 $n3">>lcdfile
$lcdcmd
>lcdfile

###########################################################
#CALLING JAVA PROGRAM TO CAPTURE AUDIO FOR AUNTHETICATION
###########################################################
echo "Say: $n1  $n2  $n3">lcdfile
echo "Capturing Audio..">>lcdfile
# above line gets on lcd display whwn actual recording get started
bash /home/pi/captureaudio.sh 7000

echo "Aunthetication ...">lcdfile
echo "Started ...">>lcdfile
$lcdcmd
>lcdfile



################################################################################
#IDENTIFYING WHICH SPEAKER IS CLAIMIMG THROUGH JAVA PROGRAM
################################################################################
cd $speaker_ident_path 
java SpeakerIdentApp --ident $recorder_path/input.wav -raw -lpc -eucl -$userid > output
matchid=$(cat $speaker_ident_path/output |grep "USER"|cut -d':' -f2)
name=$(cat $speaker_ident_path/output|grep "NAME"|cut -d':' -f2 )
echo "$matchid   $name"


########################################################################
#CHECK GIVEN USERID AND RETURN USERID BY JAVA PROGRAM IS EQUAL OR NOT
########################################################################
cd
if [ $matchid -eq $userid ]; then
	echo "Hello $name">lcdfile
	echo "Access Granted " >>lcdfile
	sudo python /home/pi/greenled.py 4
	$lcdcmd
else
	echo "Access Denied" >lcdfile
	sudo python /home/pi/redled.py 4
	$lcdcmd
fi

>lcdfile
sleep 2
>$speaker_ident_path/output
rm $recorder_path/input.wav 

