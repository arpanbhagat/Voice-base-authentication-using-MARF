#############################################################
#PATHS FOR LCD AND HEXPAD PROGRAMS
#############################################################
lcd=/home/pi/CopyLCD/Adafruit_CharLCD/Adafruit_CharLCD.py
keyval=/home/pi/hexkeypad/myhex.py
lcdcmd="sudo python $lcd"
hexcmd="sudo python $keyval"




CLASSPATH=$CLASSPATH:/home/pi/speech/marf-0.3.0-devel-20070108-fat.jar:$speaker_ident_path/:recorder_path/
export CLASSPATH

pathoftraining="/home/pi/speech/SpeakerIdentification/training-samples"


inval=1
bltime=0.5
##########################################################################
#THIS IS INFINITE LOOP FOR APPLICATION.  IF YOU GIVE 1 INPUT
#IT CALLS AUNTHETICATION  PROGRAM AND FOR 2 INPUT IT CALLS TRAINING PROGRAM 
###########################################################################
while [ $inval -eq 1 ] ; 
do
key=""
val=0
flag=0
	echo "Now back to the 1st Screen"
	while [ $val -eq 0 ];
        do
            val=$(sudo python /home/pi/hexkeypad/initiallogin.py)
	    if [ $val -eq 1 ]; then
		echo "* detected"
		key=1
		break
	    fi
	    val=$(sudo python /home/pi/hexkeypad/hashlogin.py)
	    if [ $val -eq 1 ]; then
		echo "# detected"
		key=2
		break
	    fi
            if [ $flag -eq 1 ] ; then
                let "flag=0"
                echo "Press * for 2sec">lcdfile
                echo "To login:">>lcdfile
                $lcdcmd
                >lcdfile
                sleep $bltime
            else            
                echo "Press * for 2sec">lcdfile
                echo "To login ">>lcdfile
                $lcdcmd
                >lcdfile
                let "flag=1"
                sleep $bltime
            fi
        done

	echo "we got the value $key"

   	if [ $key -eq 2 ] ; then
		echo "Give master password"
		echo "Give Master">lcdfile
		echo "Password: ">>lcdfile
		$lcdcmd

		mpwdstr=$(echo "Password: ")
		mpwd=""
		for i in `seq 1 6`;
	        do
        	     key=$($hexcmd)
	             echo "Give Master: ">lcdfile
	             mpwdstr="$mpwdstr*"
        	     mpwd=$mpwd$key
        	     echo "$mpwdstr">>lcdfile
	             $lcdcmd			
       		 done	
		master=$(cat /home/pi/masterpass)
		if [ $mpwd = $master ];then
		     echo "1.Change MPWD" >lcdfile
		     echo "2.Training 3.Remove">>lcdfile
		     $lcdcmd
		     >lcdfile
		     key=$($hexcmd)
		     if [ $key -eq 1 ]; then
			echo "New Pass:">lcdfile
			$lcdcmd
		
			mpwdstr=$(sudo echo "New Pass: ")
			mpwd=""
			for i in `seq 1 6`;
	        	do
             		     key=$($hexcmd)
		             mpwdstr="$mpwdstr*"
        		     mpwd=$mpwd$key
	        	     echo "$mpwdstr">lcdfile
		             $lcdcmd			    
	       		done


			echo "New Pass:******">lcdfile
			echo "Re-enter: ">>lcdfile
			$lcdcmd
			
			mpwdstr=$(sudo echo "Re-enter: ")
			mpw=""
			for i in `seq 1 6`;
	        	do
			     echo "New Pass:******">lcdfile
             		     key=$($hexcmd)
		             mpwdstr="$mpwdstr*"
        		     mpw=$mpw$key
	        	     echo "$mpwdstr">>lcdfile
		             $lcdcmd			    
	       		done

			if [ $mpw = $mpwd ];then
				echo "Password">lcdfile
				echo "Changed">>lcdfile
				$lcdcmd
				sudo python /home/pi/greenled.py 2
			else
				echo "Password Not">lcdfile
				echo "matching">>lcdfile
				$lcdcmd
				sudo python /home/pi/redled.py 2
			fi
		     else if [ $key -eq 2 ]; then	
			     sudo bash /home/pi/training.sh
			  else if [ $key -eq 3 ] ; then
					
					echo "Enter 6 Digit ID: ">lcdfile
				        echo "UserID: ">>lcdfile
				        $lcdcmd
				        userid=$(bash /home/pi/getuserid.sh)
				        name=$(cat /home/pi/speech/SpeakerIdentification/speakers.txt|grep $userid |cut -d',' -f2)
					if [ -z $name ]; then
						echo "No user Present"
					else
						bash /home/pi/remove.sh $name 
						cd /home/pi/speech/SpeakerIdentification/
						rm *.gzbin
						java SpeakerIdentApp --train $pathoftraining -raw -lpc -eucl
					fi
			       else
					echo "Wrong Option">lcdfile
					$lcdcmd
					>lcdfile
			       fi
			  fi
		     fi
		else
		     echo "Wrong Master">lcdfile
		     echo "Password">>lcdfile
		     $lcdcmd
		     sudo python /home/pi/redled.py 2
		fi
	
	else if [ $key -eq 1 ]; then
		echo "Calling Recognition"
		sudo bash /home/pi/recognition.sh
	     else
		echo "Invalid Option" >lcdfile
		$lcdcmd
		>lcdfile
		sleep 1
	     fi
	fi
done
