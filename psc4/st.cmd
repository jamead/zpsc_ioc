#!/epics/iocs/zpsc_ioc/bin/linux-x86_64/zpsc

# PSC IP address
epicsEnvSet("PSC_IP", "10.69.26.34")

# Record Variables (macros)
epicsEnvSet("PSC", "4") 
epicsEnvSet("PWD", "/epics/iocs/psc$(PSC)") 

# load common settings from commonSt.cmd file
</epics/iocs/zpsc_ioc/commonSt.cmd

#===================================================
# Records unique to this IOC
dbLoadTemplate "$(PWD)/db/psc.substitutions"
#===================================================

# load common settings from commonInit.cmd file
</epics/iocs/zpsc_ioc/commonInit.cmd
