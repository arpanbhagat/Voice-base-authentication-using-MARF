pathofrecorded="/home/shiva/Test"
#pathoftraining="/home/shiva/samples/training"
pathoftraining="/home/shiva/embeded/Embeded_Project/SpeakerIdentification/training-samples"
#speakerfile_path="/home/shiva/samples/"
speakerfile_path="/home/shiva/embeded/Embeded_Project/SpeakerIdentification/"
time=2000


echo "Enter Users name:  "
read name

ispresent=$(cat $speakerfile_path/speakers.txt | grep "$name-0.wav"|wc -l)
if [ $ispresent -ne 0 ] ; then
	echo this username is already present....
	exit 1
fi

echo "Give sound for number 0: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-0.wav

echo "Give sound for number 1: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-1.wav

echo "Give sound for number 2: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-2.wav

echo "Give sound for number 3: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-3.wav

echo "Give sound for number 4: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-4.wav

echo "Give sound for number 5: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-5.wav

echo "Give sound for number 6: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-6.wav

echo "Give sound for number 7: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-7.wav

echo "Give sound for number 8: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-8.wav

echo "Give sound for number 9: "
java JavaSoundRecorder $time
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-9.wav

spno=$(cat $speakerfile_path/speakers.txt|tail -1|cut -d',' -f1)
echo "spno before setting is $spno"
let spno=spno+1
list="$spno,$name,"
echo "spno after setting is $spno"


for file in $(ls $pathoftraining/$name*)
do
	filename=${file##*/}
	len=${#list}	
	list="$list$filename|"	
done
finallist=${list%|*}
echo $finallist
echo $list >> $speakerfile_path/speakers.txt

echo "Do you want to insert these sounds(Yes/No): "
read input

if [[ $input =~ ^[Nn][Oo]$ ]] ; then
	bash remove.sh  $name
	exit 1
fi

#echo "Do you want to train system with this data(Yes/No)"
#read input

#if [[ $input =~ ^[Yy][eE][sS]$ ]] ; then
#	cd ../SpeakerIdentification
#	java SpeakerIdentApp --train $pathoftraining -norm -fft -cheb
#	echo "System has trained...."
#fi
