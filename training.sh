##################################
#PATH TO PROGRAMPS LCD AND  HEXPAD
##################################
lcd=/home/pi/CopyLCD/Adafruit_CharLCD/Adafruit_CharLCD.py
keyval=/home/pi/hexkeypad/myhex.py


################################################################
#COMMANDS FOR GETTING INPUT FROM HEXPAD AND GIVING OUTPUT TO LCD
#################################################################
lcdcmd="sudo python $lcd"
hexcmd="sudo python $keyval"

################################################################
#PATH OF RECORDING MODULE AND SPEAKERIDENTIFICATION MODULE
################################################################

pathofrecorded="/home/pi/speech/Recorder/"
pathoftraining="/home/pi/speech/SpeakerIdentification/training-samples"
speakerfile_path="/home/pi/speech/SpeakerIdentification/"

#THIS IS TIME GIVEN TO USER TO GIVE SINGLE SAMPLE 0.3 SEC
time=3000


CLASSPATH=$CLASSPATH:/home/pi/speech/marf-0.3.0-devel-20070108-fat.jar:$speakerfile_path/:pathofrecorded/
export CLASSPATH

##################################################################
#TRAINING OF USER ( INTERACTION WITH COMMAND PROMPT )
##################################################################

if [ $# -ne 0 ] ; then


##################################################################
#GETTING USER ID AND NAME BY COMMAND PROMPT
##################################################################
	echo "Enter Users name:  "
	read name

	echo "Enter UserID:  "
	read userid


	cd $pathofrecorded
	ispresent=$(cat $speakerfile_path/speakers.txt | grep -w "$userid"|wc -l)
	if [ $ispresent -ne 0 ] ; then
		echo this userid is already present....
		exit 1
	fi

################################################################################
#BELOW IS CODE FOR ACCEPTING AUDIO INPUT FOR DIFFERENT SAMPLES
################################################################################

	echo "Give sound for number 0: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-0.wav

	echo "Give sound for number 1: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-1.wav

	echo "Give sound for number 2: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-2.wav

	echo "Give sound for number 3: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-3.wav

	echo "Give sound for number 4: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-4.wav

	echo "Give sound for number 5: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-5.wav

	echo "Give sound for number 6: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-6.wav

	echo "Give sound for number 7: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-7.wav

	echo "Give sound for number 8: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-8.wav

	echo "Give sound for number 9: "
	java JavaSoundRecorder $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-9.wav


	list="$userid,$name,"

	for file in $(ls $pathoftraining/$name*)
	do
		filename=${file##*/}
		len=${#list}	
		list="$list$filename|"	
	done
	finallist=${list%|*}
	echo $finallist
	echo $finallist >> $speakerfile_path/speakers.txt

	echo "Do you want to insert these sounds(Yes/No): "
	read input

	if [[ $input =~ ^[Nn][Oo]$ ]] ; then
		bash remove.sh  $name
		exit 1
	fi

	cd $speakerfile_path
	java SpeakerIdentApp --reset
	java SpeakerIdentApp --train $pathoftraining -raw -lpc -eucl
	echo "System has trained...."


else

########################################################################
# TARINING (INTERACTION WITH LCD)
#########################################################################

	echo "Enter 6 Digit ID: ">lcdfile
	echo "UserID: ">>lcdfile
	$lcdcmd
	userid=$(bash /home/pi/getuserid.sh)
	name="Emp-$userid"

######################
#CHECKING FOR USER ID IS ALREADY PRESENT OR NOT
######################
	ispresent=$(cat $speakerfile_path/speakers.txt | grep -w "$userid"|wc -l)
	if [ $ispresent -ne 0 ] ; then
		echo "USERID Already  ">lcdfile
		echo "Present ">>lcdfile
		$lcdcmd
		>lcdfile
		sleep 0.5
		sudo python /home/pi/redled.py 2		
		exit 1
	fi


	echo "Get ready for">lcdfile
	echo "training">>lcdfile
	$lcdcmd

################################################################################
#BELOW IS CODE FOR ACCEPTING AUDIO INPUT FOR DIFFERENT SAMPLES INTERACTION WITH LCD
################################################################################

	echo "Now writing to LCD say 0"	

	echo "Say : 0">lcdfile
	echo "Audio Capturing.">>lcdfile

	echo "Say : 0">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-0.wav

	echo "Say : 1">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-1.wav


	echo "Say : 2">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-2.wav

	echo "Say : 3">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-3.wav


	echo "Say : 4">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-4.wav

	echo "Say : 5">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-5.wav

	echo "Say : 6">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-6.wav

	echo "Say : 7">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-7.wav

	echo "Say : 8">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-8.wav

	echo "Say : 9">lcdfile
	echo "Audio Capturing.">>lcdfile
	bash /home/pi/captureaudio.sh $time
	mv  $pathofrecorded/input.wav $pathoftraining/$name-9.wav


	list="$userid,$name,"

	for file in $(ls $pathoftraining/$name*)
	do
		filename=${file##*/}
		len=${#list}	
		list="$list$filename|"	
	done
	finallist=${list%|*}
	echo $finallist
	echo $finallist >> $speakerfile_path/speakers.txt

####################################################################
#ASKING USER ABOUT TRAINING SYSTEM OR NOT
#IF 0 THEN NOT TRAIN AND IF 1 THEN TRAINING SYSTEM 
####################################################################

	sleep 1
	echo "(Not train/Train)" >lcdfile
	echo "(0/1):">>lcdfile
	$lcdcmd

	key=$($hexcmd)
	echo "(Not train/Train)" >lcdfile
	echo "(0/1):$key">>lcdfile
	$lcdcmd

	sleep 0.1
	if [ $key -eq 0 ];then
		echo "Now Removing Entry"	
		echo "Not Training">lcdfile
		$lcdcmd
		>lcdfile
		bash remove.sh  $name
		sudo python /home/pi/redled.py 2
		exit 1
	fi
	echo "Training System">lcdfile
	$lcdcmd
	
	sudo python /home/pi/greenled.py 2
	cd $speakerfile_path
	java SpeakerIdentApp --reset
	java SpeakerIdentApp --train $pathoftraining -raw -lpc -eucl
	echo "System has trained...."
fi
