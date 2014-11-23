::
:: Batch Processing of Training/Testing Samples
:: NOTE: Make take quite some time to execute
::
:: Copyright (C) 2003 The MARF Development Group
::
:: $Header: /cvsroot/marf/apps/SpeakerIdentApp/testing.bat,v 1.1 2003/04/21 04:34:01 mokhov Exp $
::

@echo off

::
:: Set environment variables, if needed
::

set %CLASSPATH=".;marf-0.3.0.jar;marf-0.3.0-opti.jar;marf-0.3.0-fat.jar;marf-0.2.1.jar;marf-0.2.0.jar"
set %EXTDIRS=".;/pkg/j2sdk-1.3.1_01/jre/lib;/mnt/nettemp/jaxp;/cygdrive/g/Programming/Java/jdk-1.3.1_06/jre/bin/lib/ext"

::
:: Set flags to use in the batch execution
::

set %%java='java'
::set %%debug='-debug'
set %%debug=''
set %%graph=''
::set %%graph='-graph'
::set %%spectrogram='-spectrogram'
set %%spectrogram=''


::if "%1" == "--reset" goto RESETSTATS
::if "%1" == "--retrain" goto RETRAIN

::set

::goto TESTING

:::RESETSTATS

if "%1" == "--reset"
(
	echo "Resetting Stats..."
	%%java SpeakerIdentApp --reset
	goto END
)

:RETRAIN
	echo "Training..."

	:: Always reset stats before retraining the whole thing
	%%java SpeakerIdentApp --reset

	for %%prep in (-norm -boost -low -high -band) do
	(
		for %%feat in (-fft -lpc -randfe) do
		(
			:: Here we specify which classification modules to use for
			:: training. Since Neural Net wasn't working the default
			:: distance training was performed; now we need to distinguish them
			:: here. NOTE: for distance classifiers it's not important
			:: which exactly it is, because the one of generic Distance is used.
			:: Exception for this rule is Mahalanobis Distance, which needs
			:: to learn its Covariance Matrix.

			for %%class in (-cheb -mah -randcl -nn) do
			(
				echo "Config: $prep $feat $class $spectrogram $graph $debug"
				date

				:: XXX: We cannot cope gracefully right now with these combinations --- too many
				:: links in the fully-connected NNet, so run out of memory quite often; hence,
				:: skip it for now.
				if ("%%class" == "-nn" && ("%%feat" == "-fft" || "%%feat" == "-randfe"))
				(
					echo "skipping..."
					continue
				)

				%%java SpeakerIdentApp --train training-samples %%prep %%feat %%class %%spectrogram %%graph %%debug
			)

		)
	)

:TESTING

echo "Testing..."

for %%file in (testing-samples/*.wav) do
(
	for %%prep in (-norm -boost -low -high -band) do
	(
		for %%feat in (-fft -lpc -randfe) do
		(
			for %%class in (-eucl -cheb -mink -mah -randcl -nn) do
			(
				echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
				echo "DOING FILE:"
				echo $file
				echo "Config: %%prep %%feat %%class %%spectrogram %%graph %%debug"
				date
				echo "============================================="

				:: XXX: We cannot cope gracefully right now with these combinations --- too many
				:: links in the fully-connected NNet, so run of memeory quite often, hence
				:: skip it for now.
				if("%%class" == "-nn" && ("%%feat" == "-fft" || "%%feat" == "-randfe"))
				(
					echo "skipping..."
					continue
				)

				%%java SpeakerIdentApp --ident %%file %%prep %%feat %%class %%spectrogram %%graph %%debug

				echo "---------------------------------------------"
			)
		)
	)
)

echo "Stats:"

%%java SpeakerIdentApp --stats | tee stats.txt
%%java SpeakerIdentApp --best-score | tee best-score.tex
date | tee stats-date.tex

echo "Testing Done"

:END

:: EOF
