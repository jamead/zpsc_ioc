import matplotlib.pyplot as plt
import scipy.signal as signal
import cothread
from cothread.catools import *
import numpy as np
import time
import sys


def get_sa_data(psc_prefix):

  #create pv list 
  sa_pv = []
  sa_pv.append(psc_prefix+"DieTemp-I") 
  sa_pv.append(psc_prefix+"Chan2:DCCT1-I")
  sa_pv.append(psc_prefix+"Chan2:DCCT2-I") 
  sa_pv.append(psc_prefix+"Chan2:DAC-I")
  sa_pv.append(psc_prefix+"Chan2:Volt-I")
  sa_pv.append(psc_prefix+"Chan2:Gnd-I")
  sa_pv.append(psc_prefix+"Chan2:Spare-I")
  sa_pv.append(psc_prefix+"Chan2:Reg-I")
  sa_pv.append(psc_prefix+"Chan2:Error-I") 

  #collect SA data points
  waveform = np.asarray(caget(sa_pv), dtype=np.float32)

  return waveform


def main():


  print("Total arguments passed:",len(sys.argv))
  if (len(sys.argv) != 4):
      print("Usage %s [psc name] [num pts] [output filename]" % (sys.argv[0]))
      exit() 

  psc = sys.argv[1]
  numpts = int(sys.argv[2])
  filename = sys.argv[3]
     


  with open(filename,'w',buffering=1) as outfile:
      for i in range(1,numpts):         
         ts = caget(psc+"TS-S-I")
         data = get_sa_data(psc)
         print("%8d:\t%10d\t %2.3f\t %2.6f\t %2.6f\t %2.6f\t %2.6f\t %2.6f\t %2.6f\t  %2.6f \t %2.6f" 
            % (i,ts,data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8]))
         print("%10d\t %2.3f\t %2.6f\t %2.6f\t %2.6f\t %2.6f\t %2.6f\t %2.6f\t %2.6f\t %2.6f" 
            % (ts,data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8]),file=outfile)
         while (ts == caget(psc+"TS-S-I")):
            #print("Waiting")
            time.sleep(0.1) 


if __name__ == "__main__":
  main()
