recorder_path=/home/pi/speech/Recorder/
#adding jar file to CLASSPATH
CLASSPATH=$CLASSPATH:/home/pi/speech/marf-0.3.0-devel-20070108-fat.jar:$speaker_ident_path/:recorder_path/
export CLASSPATH

cd $recorder_path
>testfile
cd
sudo bash /home/pi/iscapturestart.sh &
cd $recorder_path

if [ $# -eq 1 ]; then 
	echo "passing arg $1"
	java JavaSoundRecorder $1 >testfile
else
	java JavaSoundRecorder >testfile
fi
>testfile
