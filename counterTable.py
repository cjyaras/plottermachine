import math

header = "WIDTH = 32;\nDEPTH = 4096;\nADDRESS_RADIX = DEC;\nDATA_RADIX = BIN;\nCONTENT BEGIN;\n\n"

offsetSin = 1000
offsetCos = 1360
offsetFx = 1720
offsetFy = 2080

multAngle = 2e8
radi = math.pi / 180

fm = 200
fc = 50e6
counterLimit = fc / (2 * fm) # do not use this anywhere

f = open("dmem.mif","w+")

f.write(header)

for i in range(360) :
	sinInBinary = "{0:032b}".format(round(multAngle * math.sin(radi * i)) & 0xffffffff)
	f.write("%d : %s ;\n" % (offsetSin + i, sinInBinary))

for i in range(360) :
	cosInBinary = "{0:032b}".format(round(multAngle * math.cos(radi * i)) & 0xffffffff)
	f.write("%d : %s ;\n" % (offsetCos + i, cosInBinary))

for i in range(360) :
	fx = "{0:032b}".format(abs(round(fm * math.sin(radi * i))))
	f.write("%d : %s ;\n" % (offsetFx + i, fx))

for i in range(360) :
	fy = "{0:032b}".format(abs(round(fm * math.cos(radi * i))))
	f.write("%d : %s ;\n" % (offsetFy + i, fy))

f.write("END;\n")

f.close()
