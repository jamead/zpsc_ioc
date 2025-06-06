#!../../bin/linux-x86_64/tripp_pdu

#- You may have to change tripp_pdu to something else
#- everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/tripp_pdu.dbd"
tripp_pdu_registerRecordDeviceDriver pdbbase

## Load record instances
dbLoadTemplate "db/user.substitutions"
dbLoadRecords "db/tripp_pduVersion.db", "user=pstester"
dbLoadRecords "db/dbSubExample.db", "user=pstester"

#- Set this to see messages from mySub
#-var mySubDebug 1

#- Run this to trace the stages of iocInit
#-traceIocInit

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncExample, "user=pstester"
