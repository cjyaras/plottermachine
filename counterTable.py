import math

header = "WIDTH = 32;\nDEPTH = 4096;\nADDRESS_RADIX = DEC;\nDATA_RADIX = BIN;\nCONTENT BEGIN;\n\n"

offsetSin = 1000
offsetCos = 1360
offsetFx = 1720
offsetFy = 2080
offsetMt = 2440

multAngle = 2e8
radi = math.pi / 180

direction = ["1010", "1111", "0101", "1101", "1000", "1100", "0100", "1110"]

fm = 200
fc = 50e6

f = open("dmem.mif","w+")

f.write(header)

for i in range(360):
	sinBin="{0:032b}".format(round(multAngle*math.sin(radi*i))&0xffffffff)
	f.write("%d : %s ;\n"%(offsetSin+i,sinBin))

for i in range(360):
	cosBin="{0:032b}".format(round(multAngle*math.cos(radi*i))&0xffffffff)
	f.write("%d : %s ;\n"%(offsetCos+i,cosBin))

for i in range(360):
	if round(fm * math.cos(radi * i)) == 0 : # cannot divide by zero
		fx="{0:032b}".format(abs(round(fm*math.cos(radi*i))))
	else :
		fx="{0:032b}".format(round(fc/(2*abs(fm*math.cos(radi*i)))))
	f.write("%d : %s ;\n"%(offsetFx+i,fx))

for i in range(360):
	if round(fm*math.sin(radi*i))==0: # cannot divide by zero
		fy="{0:032b}".format(abs(round(fm*math.sin(radi*i))))
	else :
		fy="{0:032b}".format(round(fc/(2*abs(fm*math.sin(radi*i)))))
	f.write("%d : %s ;\n"%(offsetFy+i,fy))

counter = 0
for i in range(360):
	if (i % 90 == 0 or i % 90 == 1) :
		counter += 1
	string = "{0:028b}".format(0) + direction[counter - 1]
	f.write("%d : %s ;\n"%(offsetMt+i,string))

f.write("END;\n")
f.close()
