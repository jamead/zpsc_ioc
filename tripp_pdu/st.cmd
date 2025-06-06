#!./bin/linux-x86_64/tripp_pdu

# Kill any existing instance of the driver
#pkill -f tripp_pdu_driver.py

# Start the driver in the background
#python3 /epics/iocs/tripp_pdu/tripp_pduApp/src/tripp_pdu_driver.py &


## Register all support components
dbLoadDatabase "dbd/tripp_pdu.dbd"
tripp_pdu_registerRecordDeviceDriver pdbbase

## Load record instances
dbLoadTemplate "db/user.substitutions"
dbLoadRecords "db/tripp_pduVersion.db", "user=pstester"
dbLoadRecords "db/dbSubExample.db", "user=pstester"
dbLoadRecords "db/tripp_pdu.db", "P=tripp_pdu"

iocInit

## Start any sequence programs
#seq sncExample, "user=pstester"
#system("pkill -f tripp_pdu_driver.py")
#system("python3 /epics/iocs/tripp_pdu/tripp_pduApp/src/tripp_pdu_driver.py &")
