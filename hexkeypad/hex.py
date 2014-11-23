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
	GPIO.output(r1,True)
	GPIO.output(r2,False)
	GPIO.output(r3,False)
	GPIO.output(r4,False)
	colm1=GPIO.input(c1)
	colm2=GPIO.input(c2)
	colm3=GPIO.input(c3)
	colm4=GPIO.input(c4)


	if colm1==True:
		print('1')
		time.sleep(0.5)
	elif colm2==True:		
		print('2')
		time.sleep(0.5)
	elif colm3==True:
		print('3')
		time.sleep(0.5)
	elif colm4==True:
		print("A")
		time.sleep(0.5)


	GPIO.output(r1,False)
	GPIO.output(r2,True)
	GPIO.output(r3,False)
	GPIO.output(r4,False)
	colm1=GPIO.input(c1)
	colm2=GPIO.input(c2)
	colm3=GPIO.input(c3)
	colm4=GPIO.input(c4)

	if colm1==True:
		print('4')
		time.sleep(0.5)
	elif colm2==True:		
		print('5')
		time.sleep(0.5)
	elif colm3==True:
		print('6')
		time.sleep(0.5)
	elif colm4==True:
		print("B")
		time.sleep(0.5)

	GPIO.output(r1,False)
	GPIO.output(r2,False)
	GPIO.output(r3,True)
	GPIO.output(r4,False)
	colm1=GPIO.input(c1)
	colm2=GPIO.input(c2)
	colm3=GPIO.input(c3)
	colm4=GPIO.input(c4)


	if colm1==True:
		print('7')
		time.sleep(0.5)
	elif colm2==True:		
		print('8')
		time.sleep(0.5)
	elif colm3==True:
		print('9')
		time.sleep(0.5)
	elif colm4==True:
		print("C")
		time.sleep(0.5)


	GPIO.output(r1,False)
	GPIO.output(r2,False)
	GPIO.output(r3,False)
	GPIO.output(r4,True)
	colm1=GPIO.input(c1)
	colm2=GPIO.input(c2)
	colm3=GPIO.input(c3)
	colm4=GPIO.input(c4)

	if colm1==True:
		print('*')
		time.sleep(0.5)
	elif colm2==True:		
		print('0')
		time.sleep(0.5)
	elif colm3==True:
		print("#")
		time.sleep(0.5)
	elif colm4==True:
		print("D")
		time.sleep(0.5)
