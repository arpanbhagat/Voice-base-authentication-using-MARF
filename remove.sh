pathofrecorded="/home/pi/speech/Recorder"
pathoftraining="/home/pi/speech/SpeakerIdentification/training-samples"
speakerfile_path="/home/pi/speech/SpeakerIdentification/"

if [ $# -eq 1 ] ;then
	name=$1
else
	echo "Enter User Name to be remove: "
	read name
fi
sudo rm $pathoftraining/$name*
cat $speakerfile_path/speakers.txt | grep -v "$name" >dummy
cp dummy $speakerfile_path/speakers.txt
sudo rm dummy
