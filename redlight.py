import RPi.GPIO as GPIO ## Import GPIO library
import time
import sys

lighttime=float(sys.argv[1])
GPIO.setmode(GPIO.BCM) ## Use GPIO Pin numbering
GPIO.setwarnings(False)
ledred=5
GPIO.setup(ledred, GPIO.OUT) ## Setup GPIO Pin 5 to OUT

GPIO.output(ledred,True) ## Turn on GPIO pin 5
time.sleep(lighttime)
GPIO.output(ledred,False) ## Turn off GPIO pin 5
