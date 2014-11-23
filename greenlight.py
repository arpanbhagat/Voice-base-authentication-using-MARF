import RPi.GPIO as GPIO ## Import GPIO library
import time
import sys

lighttime= float(sys.argv[1])
GPIO.setmode(GPIO.BCM) ## Use GPIO Pin numbering
GPIO.setwarnings(False)
ledgreen=12
GPIO.setup(ledgreen, GPIO.OUT) ## Setup GPIO Pin 12 to OUT

GPIO.output(ledgreen,True) ## Turn on GPIO pin 12
time.sleep(lighttime)
GPIO.output(ledgreen,False) ## Turn off GPIO pin 12
