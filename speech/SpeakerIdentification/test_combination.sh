#!/bin/tcsh -f

#
# Batch Processing of Training/Testing Samples
# NOTE: Make take quite some time to execute
#
# Copyright (C) 2002-2005 The MARF Development Group
#
# $Header: /cvsroot/marf/apps/SpeakerIdentApp/testing.sh,v 1.27 2005/05/22 15:35:37 mokhov Exp $
#

#
# Set environment variables, if needed
#

#setenv CLASSPATH .:marf.jar
#setenv EXTDIRS

#
# Set flags to use in the batch execution
#

set java = 'java'
#set debug = '-debug'
set debug = ''
set graph = ''
#set graph = '-graph'
#set spectrogram = '-spectrogram'
set spectrogram = ''

if($1 == '--reset') then
	echo "Resetting Stats..."
	java SpeakerIdentApp --reset
	exit 0
fi

echo "Training.....and....Testing..."
java SpeakerIdentApp --reset
allprep="-norm -boost -low -high -band -highpassboost -raw"
allfeat="-fft -lpc -minmax"
allclass="-eucl -cheb -mink -mah -diff"
for prep in $allprep
do
#	foreach prep (-norm -boost -low -high -band -highpassboost -raw)		
		for feat in $allfeat
		do
		#foreach feat (-fft -lpc -randfe -minmax)
			for class in $allclass
			do
		#	foreach class (-eucl -cheb -mink -mah -diff -randcl)
				echo "Config: $prep $feat $class"
				java SpeakerIdentApp --train training-samples $prep $feat $class $spectrogram $graph $debug				
				for file in $(ls testing-samples/*.wav)
				do	
				java SpeakerIdentApp --ident $file $prep $feat $class $spectrogram $graph $debug > testfile
				var=$(cat testfile| grep "Speaker identified"|cut -d' ' -f6	)
				name=${file%-*}
				filename=${name#*/}
				echo "$filename		$var" 																
				done
			done
		done
done

