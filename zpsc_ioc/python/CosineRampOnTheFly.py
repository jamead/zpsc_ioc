import numpy as np
from matplotlib import pyplot as pl

 
pi = 3.14159265


i1 = 0    # start setpoint
i2 = 100 # end setpoint
R = 1  # ramp rate A/s
fs = 10000 # DAC update rate

D = np.abs(i2-i1)/R # ramp duration (s)
N = int(D*fs) # number of points in ramp

Y = np.zeros(N)

print("i1 = %3.5f" % i1)
print("i2 = %3.5f" % i2)
print("ramp rate = %3.2f A/s" % R)
print("ramp duration = %3.2f s" % D)
print("number of points = %d" % N)

sp0 = i1
A = (i2-i1)/N*pi/2

for i in range(N):
   dI = A*np.sin(pi*i/N)
   sp1 = sp0 + dI
   sp0 = sp1
   #print(sp1)
   Y[i] = sp1

pl.plot(Y)
pl.show()
