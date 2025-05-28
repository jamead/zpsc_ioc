#!../../bin/linux-x86_64/zpsc

#- You may have to change zpsc to something else
#- everywhere it appears in this file

< envPaths

epicsEnvSet("IOCNAME", "lab")

# PSC IP address
epicsEnvSet("PSC1_IP", "10.0.142.115"); 
epicsEnvSet("PSC2_IP", "10.0.142.116"); 
epicsEnvSet("PSC3_IP", "10.0.142.117"); 
epicsEnvSet("PSC4_IP", "10.0.142.118"); 
epicsEnvSet("PSC5_IP", "10.0.142.119"); 


epicsEnvSet("BLEN",100000);        # Snapshot DMA Length

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/zpsc.dbd"
zpsc_registerRecordDeviceDriver pdbbase

## Load record instances for PSC1
dbLoadRecords("db/lstats.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("db/status10hz.db", "P=$(IOCNAME), NO=1, OFFSET=100")
dbLoadRecords("db/control_glob.db", "P=$(IOCNAME), NO=1")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=1")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=2")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=3")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=1, CHAN=4")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=1, MSGID=60, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=2, MSGID=61, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=3, MSGID=62, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=USR, CHAN=4, MSGID=63, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=1, MSGID=70, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=2, MSGID=71, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=3, MSGID=72, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=FLT, CHAN=4, MSGID=73, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=1, MSGID=80, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=2, MSGID=81, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=3, MSGID=82, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=ERR, CHAN=4, MSGID=83, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=1, MSGID=90, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=2, MSGID=91, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=3, MSGID=92, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=INJ, CHAN=4, MSGID=93, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=1, MSGID=100, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=2, MSGID=101, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=3, MSGID=102, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=1, TYPE=EVR, CHAN=4, MSGID=103, BUFLEN=$(BLEN)")
dbLoadRecords("db/wfmstats.db", "P=$(IOCNAME), PSC=1")
#dbLoadRecords("db/asub_test.db")

## Load record instances for PSC2
dbLoadRecords("db/lstats.db", "P=$(IOCNAME), NO=2")
dbLoadRecords("db/status10hz.db", "P=$(IOCNAME), NO=2, OFFSET=100")
dbLoadRecords("db/control_glob.db", "P=$(IOCNAME), NO=2")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=2, CHAN=1")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=2, CHAN=2")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=2, CHAN=3")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=2, CHAN=4")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=USR, CHAN=1, MSGID=60, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=USR, CHAN=2, MSGID=61, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=USR, CHAN=3, MSGID=62, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=USR, CHAN=4, MSGID=63, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=FLT, CHAN=1, MSGID=70, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=FLT, CHAN=2, MSGID=71, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=FLT, CHAN=3, MSGID=72, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=FLT, CHAN=4, MSGID=73, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=ERR, CHAN=1, MSGID=80, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=ERR, CHAN=2, MSGID=81, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=ERR, CHAN=3, MSGID=82, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=ERR, CHAN=4, MSGID=83, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=INJ, CHAN=1, MSGID=90, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=INJ, CHAN=2, MSGID=91, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=INJ, CHAN=3, MSGID=92, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=INJ, CHAN=4, MSGID=93, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=EVR, CHAN=1, MSGID=100, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=EVR, CHAN=2, MSGID=101, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=EVR, CHAN=3, MSGID=102, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=2, TYPE=EVR, CHAN=4, MSGID=103, BUFLEN=$(BLEN)")
dbLoadRecords("db/wfmstats.db", "P=$(IOCNAME), PSC=2")
#dbLoadRecords("db/asub_test.db")

## Load record instances for PSC3
dbLoadRecords("db/lstats.db", "P=$(IOCNAME), NO=3")
dbLoadRecords("db/status10hz.db", "P=$(IOCNAME), NO=3, OFFSET=100")
dbLoadRecords("db/control_glob.db", "P=$(IOCNAME), NO=3")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=3, CHAN=1")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=3, CHAN=2")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=3, CHAN=3")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=3, CHAN=4")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=USR, CHAN=1, MSGID=60, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=USR, CHAN=2, MSGID=61, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=USR, CHAN=3, MSGID=62, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=USR, CHAN=4, MSGID=63, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=FLT, CHAN=1, MSGID=70, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=FLT, CHAN=2, MSGID=71, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=FLT, CHAN=3, MSGID=72, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=FLT, CHAN=4, MSGID=73, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=ERR, CHAN=1, MSGID=80, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=ERR, CHAN=2, MSGID=81, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=ERR, CHAN=3, MSGID=82, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=ERR, CHAN=4, MSGID=83, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=INJ, CHAN=1, MSGID=90, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=INJ, CHAN=2, MSGID=91, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=INJ, CHAN=3, MSGID=92, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=INJ, CHAN=4, MSGID=93, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=EVR, CHAN=1, MSGID=100, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=EVR, CHAN=2, MSGID=101, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=EVR, CHAN=3, MSGID=102, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=3, TYPE=EVR, CHAN=4, MSGID=103, BUFLEN=$(BLEN)")
dbLoadRecords("db/wfmstats.db", "P=$(IOCNAME), PSC=3")
#dbLoadRecords("db/asub_test.db")

## Load record instances for PSC4
dbLoadRecords("db/lstats.db", "P=$(IOCNAME), NO=4")
dbLoadRecords("db/status10hz.db", "P=$(IOCNAME), NO=4, OFFSET=100")
dbLoadRecords("db/control_glob.db", "P=$(IOCNAME), NO=4")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=4, CHAN=1")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=4, CHAN=2")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=4, CHAN=3")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=4, CHAN=4")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=USR, CHAN=1, MSGID=60, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=USR, CHAN=2, MSGID=61, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=USR, CHAN=3, MSGID=62, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=USR, CHAN=4, MSGID=63, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=FLT, CHAN=1, MSGID=70, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=FLT, CHAN=2, MSGID=71, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=FLT, CHAN=3, MSGID=72, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=FLT, CHAN=4, MSGID=73, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=ERR, CHAN=1, MSGID=80, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=ERR, CHAN=2, MSGID=81, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=ERR, CHAN=3, MSGID=82, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=ERR, CHAN=4, MSGID=83, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=INJ, CHAN=1, MSGID=90, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=INJ, CHAN=2, MSGID=91, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=INJ, CHAN=3, MSGID=92, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=INJ, CHAN=4, MSGID=93, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=EVR, CHAN=1, MSGID=100, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=EVR, CHAN=2, MSGID=101, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=EVR, CHAN=3, MSGID=102, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=4, TYPE=EVR, CHAN=4, MSGID=103, BUFLEN=$(BLEN)")
dbLoadRecords("db/wfmstats.db", "P=$(IOCNAME), PSC=4")
#dbLoadRecords("db/asub_test.db")

## Load record instances for PSC5
dbLoadRecords("db/lstats.db", "P=$(IOCNAME), NO=5")
dbLoadRecords("db/status10hz.db", "P=$(IOCNAME), NO=5, OFFSET=100")
dbLoadRecords("db/control_glob.db", "P=$(IOCNAME), NO=5")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=5, CHAN=1")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=5, CHAN=2")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=5, CHAN=3")
dbLoadRecords("db/control_chan.db", "P=$(IOCNAME), NO=5, CHAN=4")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=USR, CHAN=1, MSGID=60, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=USR, CHAN=2, MSGID=61, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=USR, CHAN=3, MSGID=62, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=USR, CHAN=4, MSGID=63, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=FLT, CHAN=1, MSGID=70, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=FLT, CHAN=2, MSGID=71, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=FLT, CHAN=3, MSGID=72, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=FLT, CHAN=4, MSGID=73, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=ERR, CHAN=1, MSGID=80, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=ERR, CHAN=2, MSGID=81, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=ERR, CHAN=3, MSGID=82, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=ERR, CHAN=4, MSGID=83, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=INJ, CHAN=1, MSGID=90, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=INJ, CHAN=2, MSGID=91, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=INJ, CHAN=3, MSGID=92, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=INJ, CHAN=4, MSGID=93, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=EVR, CHAN=1, MSGID=100, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=EVR, CHAN=2, MSGID=101, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=EVR, CHAN=3, MSGID=102, BUFLEN=$(BLEN)")
dbLoadRecords("db/snapshots.db", "P=$(IOCNAME), NO=5, TYPE=EVR, CHAN=4, MSGID=103, BUFLEN=$(BLEN)")
dbLoadRecords("db/wfmstats.db", "P=$(IOCNAME), PSC=5")
#dbLoadRecords("db/asub_test.db")





var(PSCDebug, 2)	#5 full debug

#psc1 Create the PSC
createPSC("PSC1", $(PSC1_IP), 3000, 0)
#createPSC("PSC2", $(PSC2_IP), 3000, 0)
#createPSC("PSC3", $(PSC3_IP), 3000, 0)
#createPSC("PSC4", $(PSC4_IP), 3000, 0)
#createPSC("PSC5", $(PSC5_IP), 3000, 0)


cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=mead"

epicsThreadSleep(1.0)



dbpf lab{1}Chan1:DigOut_ON1-SP 0
dbpf lab{1}Chan2:DigOut_ON1-SP 0
dbpf lab{1}Chan3:DigOut_ON1-SP 0
dbpf lab{1}Chan4:DigOut_ON1-SP 0

dbpf lab{1}Chan1:DigOut_ON2-SP 0
dbpf lab{1}Chan2:DigOut_ON2-SP 0
dbpf lab{1}Chan3:DigOut_ON2-SP 0
dbpf lab{1}Chan4:DigOut_ON2-SP 0

dbpf lab{1}Chan1:DigOut_Reset-SP 0
dbpf lab{1}Chan2:DigOut_Reset-SP 0
dbpf lab{1}Chan3:DigOut_Reset-SP 0
dbpf lab{1}Chan4:DigOut_Reset-SP 0

dbpf lab{1}Chan1:DigOut_Park-SP 0
dbpf lab{1}Chan2:DigOut_Park-SP 0
dbpf lab{1}Chan3:DigOut_Park-SP 0
dbpf lab{1}Chan4:DigOut_Park-SP 0

dbpf lab{1}Chan1:DAC_SetPt-SP 0
dbpf lab{1}Chan2:DAC_SetPt-SP 0
dbpf lab{1}Chan3:DAC_SetPt-SP 0
dbpf lab{1}Chan4:DAC_SetPt-SP 0

#dbpf lab{1}Chan1:DACSetPt-Offset-SP 0.0
#dbpf lab{1}Chan1:DACSetPt-Gain-SP 1.0

dbpf lab{1}Chan1:DAC_OpMode-SP 0
dbpf lab{1}Chan2:DAC_OpMode-SP 0
dbpf lab{1}Chan3:DAC_OpMode-SP 0
dbpf lab{1}Chan4:DAC_OpMode-SP 0

#dbpf lab{1}Chan1:SF:AmpsperSec-SP 1.0
#dbpf lab{1}Chan1:SF:DAC_DCCTs-SP 1.0
#dbpf lab{1}Chan1:SF:Vout-SP 1.0
#dbpf lab{1}Chan1:SF:Ignd-SP 1.0
#dbpf lab{1}Chan1:SF:Spare-SP 1.0
#dbpf lab{1}Chan1:SF:Regulator-SP 1.0
#dbpf lab{1}Chan1:SF:Error-SP 1.0




#dbpf lab{1}Chan1:DCCT1-Offset-SP 0.0
#dbpf lab{1}Chan1:DCCT1-Gain-SP 1.0
#dbpf lab{1}Chan1:DCCT2-Offset-SP 0.0
#dbpf lab{1}Chan1:DCCT2-Gain-SP 1.0
#dbpf lab{1}Chan1:DAC-Offset-SP 0.0
#dbpf lab{1}Chan1:DAC-Gain-SP 1.0
#dbpf lab{1}Chan1:Volt-Offset-SP 0.0
#dbpf lab{1}Chan1:Volt-Gain-SP 1.0
#dbpf lab{1}Chan1:Gnd-Offset-SP 0.0
#dbpf lab{1}Chan1:Gnd-Gain-SP 1.0
#dbpf lab{1}Chan1:Spare-Offset-SP 0.0
#dbpf lab{1}Chan1:Spare-Gain-SP 1.0
#dbpf lab{1}Chan1:Reg-Offset-SP 0.0
#dbpf lab{1}Chan1:Reg-Gain-SP 1.0
#dbpf lab{1}Chan1:Error-Offset-SP 0.0
#dbpf lab{1}Chan1:Error-Gain-SP 1.0

