pathofrecorded="/home/shiva/Test"
pathoftraining="/home/shiva/samples/testing"
pathoftraining="/home/shiva/embeded/Embeded_Project/SpeakerIdentification/testing-samples"
#time=4000
echo "Enter Users name:  "
read name
echo "Give sound for any one digit: "
java JavaSoundRecorder 2000
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-one.wav

echo "Give sound for any two digit: "
java JavaSoundRecorder 3000
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-two.wav

echo "Give sound for any three digit: "
java JavaSoundRecorder 4000
mv  $pathofrecorded/RecordAudio.wav $pathoftraining/$name-three.wav
