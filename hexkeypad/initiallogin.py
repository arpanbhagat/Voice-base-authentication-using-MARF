import RPi.GPIO as GPIO
import time
import sys
import time

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

r1=2
r2=3
r3=4
r4=10
c1=9
c2=11
c3=13
c4=19

starpress=0
timepress=0

GPIO.setup(r1,GPIO.OUT)
GPIO.setup(r2,GPIO.OUT)
GPIO.setup(r3,GPIO.OUT)
GPIO.setup(r4,GPIO.OUT)
GPIO.setup(c1,GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(c2,GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(c3,GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(c4,GPIO.IN, pull_up_down=GPIO.PUD_DOWN)


GPIO.output(r1,True)
GPIO.output(r2,True)
GPIO.output(r3,True)
GPIO.output(r4,True)


while True:
	currenttime = time.clock()
#	print(time.clock())
	GPIO.output(r1,False)
	GPIO.output(r2,False)
	GPIO.output(r3,False)
	GPIO.output(r4,True)
	colm1=GPIO.input(c1)
	colm2=GPIO.input(c2)
	colm3=GPIO.input(c3)
	colm4=GPIO.input(c4)

	if (colm1==True and starpress!=1):
		starpress=1
		timepress=time.clock()
#		print(timepress)

	if( starpress==1 and (currenttime - timepress >= 2)):
		print("1")
		break

#	if( starpress==1 and (currenttime - timepress <= 2)):
#		if colm1!=True:
#			print("0")
#			break	
	if (colm1==False):
		print("0")				
		break
