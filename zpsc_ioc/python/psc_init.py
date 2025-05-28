import matplotlib.pyplot as plt
import scipy.signal as signal
import cothread
from cothread.catools import *
import numpy as np
import time
import sys



def write_pv(psc, chan, name, val):
  pv_name = psc + "Chan" + chan + ':' + str(name)
  print(pv_name)
  caput(pv_name,val);



def main():


  if (len(sys.argv) != 3):
      print("Usage %s [psc name] [chan num 1-4]" % (sys.argv[0]))
      exit() 

  psc = sys.argv[1]
  chan = sys.argv[2]
  
  
  write_pv(psc,chan,'SF:AmpsperSec-SP',1.0)
  write_pv(psc,chan,'SF:DAC_DCCTs-SP',1.0)  
  write_pv(psc,chan,'SF:Vout-SP',1.0) 
  write_pv(psc,chan,'SF:Ignd-SP',1.0)   
  write_pv(psc,chan,'SF:Spare-SP',1.0)
  write_pv(psc,chan,'SF:Regulator-SP',1.0) 
  write_pv(psc,chan,'SF:Error-SP',1.0)
 
  
  write_pv(psc,chan,'DCCT1-Offset-SP',0.0)
  write_pv(psc,chan,'DCCT1-Gain-SP',1.0)
  write_pv(psc,chan,'DCCT2-Offset-SP',0.0)
  write_pv(psc,chan,'DCCT2-Gain-SP',1.0)  
  write_pv(psc,chan,'DAC-Offset-SP',0.0)
  write_pv(psc,chan,'DAC-Gain-SP',1.0)  
  write_pv(psc,chan,'Volt-Offset-SP',0.0)
  write_pv(psc,chan,'Volt-Gain-SP',1.0)  
  write_pv(psc,chan,'Gnd-Offset-SP',0.0)
  write_pv(psc,chan,'Gnd-Gain-SP',1.0)  
  write_pv(psc,chan,'Spare-Offset-SP',0.0)
  write_pv(psc,chan,'Spare-Gain-SP',1.0)  
  write_pv(psc,chan,'Reg-Offset-SP',0.0)
  write_pv(psc,chan,'Reg-Gain-SP',1.0)  
  write_pv(psc,chan,'Error-Offset-SP',0.0)
  write_pv(psc,chan,'Error-Gain-SP',1.0)  

  write_pv(psc,chan,'OVC1_Flt_Threshold-SP',5.0)
  write_pv(psc,chan,'OVC2_Flt_Threshold-SP',5.0)
  write_pv(psc,chan,'OVV_Flt_Threshold-SP',5.0)
  write_pv(psc,chan,'ERR1_Flt_Threshold-SP',5.0)
  write_pv(psc,chan,'ERR2_Flt_Threshold-SP',5.0)
  write_pv(psc,chan,'IGND_Flt_Threshold-SP',5.0)

  write_pv(psc,chan,'OVC1_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'OVC2_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'OVV_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'ERR1_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'ERR2_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'IGND_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'DCCT_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'FLT1_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'FLT2_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'FLT3_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'ON_Flt_CntLim-SP',1.0)
  write_pv(psc,chan,'HeartBeat_Flt_CntLim-SP',1.0)




if __name__ == "__main__":
  main()
