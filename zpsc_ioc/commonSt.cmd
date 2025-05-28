#====================================================
#   Common St.cmd file used by zPSC devices
#====================================================

## Register all support components
dbLoadDatabase "/epics/iocs/zpsc_ioc/dbd/zpsc.dbd"
zpsc_registerRecordDeviceDriver pdbbase

var(PSCDebug, 2)	#5 full debug

#psc1 Create the PSC
createPSC("PSC$(PSC)", $(PSC_IP), 3000, 0)
