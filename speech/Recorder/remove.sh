pathofrecorded="/home/shiva/Test"
pathoftraining="/home/shiva/samples/training"
speakerfile_path="/home/shiva/samples/"

if [ $# -eq 1 ] ;then
	name=$1
else
	echo "Enter User Name to be remove: "
	read name
fi
rm $pathoftraining/$name*
cat $speakerfile_path/speakers.txt | grep -v "$name" >dummy
cp dummy $speakerfile_path/speakers.txt
rm dummy
