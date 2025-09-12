#!../../bin/linux-x86_64/zpsc
#--
< envPaths
#--
cd "${TOP}"
#--
#--https://epics-controls.org/resources-and-support/documents/howto-documents/channel-access-reach-multiple-soft-iocs-linux/
#--if one needs connections between IOCs on one host
#--add the broadcast address of the lookback interface to each IOC setting
epicsEnvSet("EPICS_CA_ADDR_LIST","127.255.255.255")
#--epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST","YES")

#-- PVXA Environment Variables
#-- epicsEnvSet("EPICS_PVA_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_BEACON_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_AUTO_BEACON_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_INTF_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_SERVER_PORT","")
#-- epicsEnvSet("EPICS_PVAS_SERVER_PORT","")
#-- epicsEnvSet("EPICS_PVA_BROADCAST_PORT","")
#-- epicsEnvSet("EPICS_PVAS_BROADCAST_PORT","")
#-- epicsEnvSet("EPICS_PVAS_IGNORE_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_CONN_TMO","")
#--
epicsEnvSet("DB_TOP",                "$(TOP)/db")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DB_TOP)")
epicsEnvSet("STREAM_PROTOCOL_PATH",  "$(DB_TOP)")
epicsEnvSet("IOCSH_LOCAL_TOP",       "$(TOP)/iocsh")
#--epicsEnvSet("IOCSH_TOP",            "$(EPICS_BASE)/../modules/soft/iocsh/iocsh")
#--
epicsEnvSet("ENGINEER",  "jeonglee")
epicsEnvSet("LOCATION",  "SoftIOC")
epicsEnvSet("WIKI", "")
#-- 
epicsEnvSet("IOCNAME", "alsulab-zpsc")
epicsEnvSet("IOC", "iocalsulab-zpsc")
#--
epicsEnvSet("PRE", "AAAA:")
epicsEnvSet("REC", "BBBB:")


## Register all support components
dbLoadDatabase "dbd/zpsc.dbd"
zpsc_registerRecordDeviceDriver pdbbase


#--
#-- The following termination defintion should be in st.cmd or .iocsh. 
#-- Mostly, it should be .iocsh file. Please don't use them within .proto file
#--
#--
#-- iocshLoad("$(IOCSH_TOP)/als_default.iocsh")
#-- iocshLoad("$(IOCSH_TOP)/iocLog.iocsh",    "IOCNAME=$(IOCNAME), LOG_INET=$(LOG_DEST), LOG_INET_PORT=$(LOG_PORT)")
#--# Load record instances
#-- iocshLoad("$(IOCSH_TOP)/iocStats.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/iocStatsAdmin.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/reccaster.iocsh", "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/caPutLog.iocsh",  "IOCNAME=$(IOCNAME), LOG_INET=$(LOG_DEST), LOG_INET_PORT=$(LOG_PORT)")
#-- iocshLoad("$(IOCSH_TOP)/autosave.iocsh", "AS_TOP=$(TOP),IOCNAME=$(IOCNAME),DATABASE_TOP=$(DB_TOP),SEQ_PERIOD=60")

#-- access control list
#--asSetFilename("$(DB_TOP)/access_securityalsulab-zpsc.acf")

cd "${TOP}/iocBoot/${IOC}"

# PSC1 
epicsEnvSet("PSC1_NE", "PSC")
epicsEnvSet("PSC1_NO", "1")
epicsEnvSet("PSC1_IP", "10.0.142.115"); 
iocshLoad("$(IOCSH_LOCAL_TOP)/zpsc.iocsh", "DATABASE_TOP=$(DB_TOP),P=$(IOCNAME),NAME=$(PSC1_NE),NO=$(PSC1_NO),IPADDR=$(PSC1_IP)")
#iocshLoad("$(IOCSH_LOCAL_TOP)/zpsc.iocsh", "DATABASE_TOP=$(DB_TOP),P=$(IOCNAME),NAME=$(PSC1_NE),NO=$(PSC1_NO),IPADDR=$(PSC1_IP),PSCDEBUG=")
#iocshLoad("$(IOCSH_LOCAL_TOP)/zpsc.iocsh", "DATABASE_TOP=$(DB_TOP),P=$(IOCNAME),NAME=$(PSC1_NE),NO=$(PSC1_NO),IPADDR=$(PSC1_IP),PSCDEBUG=,PSCBSIZE=")
#iocshLoad("$(IOCSH_LOCAL_TOP)/zpsc.iocsh", "DATABASE_TOP=$(DB_TOP),P=$(IOCNAME),NAME=$(PSC1_NE),NO=$(PSC1_NO),IPADDR=$(PSC1_IP),PSCDEBUG=,DBUGLVL=5,PSCBSIZE=")

# Example for PSC2
#epicsEnvSet("PSC2_NE", "PSC")
#epicsEnvSet("PSC2_NO", "2")
#epicsEnvSet("PSC2_IP", "10.0.142.116"); 
#iocshLoad("$(IOCSH_LOCAL_TOP)/zpsc.iocsh", "DATABASE_TOP=$(DB_TOP),P=$(IOCNAME),NAME=$(PSC2_NE),NO=$(PSC2_NO),IPADDR=$(PSC2_IP)")


#>>>>>>>>>>>>>
iocInit
#>>>>>>>>>>>>>
##
##-- epicsEnvShow > /vxboot/PVenv/${IOCNAME}.softioc
##-- dbl > /vxboot/PVnames/${IOCNAME}

ClockTime_Report
##

iocshLoad("$(IOCSH_LOCAL_TOP)/zpsc_afterinit.iocsh", "DATABASE_TOP=$(DB_TOP),P=$(IOCNAME),NO=$(PSC1_NO)")

