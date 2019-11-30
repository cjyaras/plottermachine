import math

header = "WIDTH = 32;\nDEPTH = 4096;\nADDRESS_RADIX = DEC;\nDATA_RADIX = BIN;\nCONTENT BEGIN;\n\n"

offsetSin = 1000
offsetCos = 1360
offsetCounter = 1720 # 1000 + sine (360) + cosine (360)

mult = 10e8
radi = math.pi / 180

# C = clock freq
# M = turn freq
# counter limit = C / (2 * M)

# first, find fm,x and fm,y then calculate counter limit

f = open("dmem.mif","w+")

f.write(header)

for i in range(360) :
	sinInBinary = "{0:032b}".format(round(mult * math.sin(radi * i)) & 0xffffffff)
	f.write("%d : %s ;\n" % (offsetSin + i, sinInBinary))

for i in range(360) :
	cosInBinary = "{0:032b}".format(round(mult * math.cos(radi * i)) & 0xffffffff)
	f.write("%d : %s ;\n" % (offsetCos + i, cosInBinary))

for i in range(360) :
	f.write("%d : \n" % (offsetCounter + i))

f.write("END;\n")

f.close()
