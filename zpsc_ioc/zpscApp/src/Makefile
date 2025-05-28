TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = zpsc
# zpsc.dbd will be created and installed
DBD += zpsc.dbd

# zpsc.dbd will be made up from these files:
zpsc_DBD += base.dbd

# Include dbd files from all support applications:
zpsc_DBD += pscCore.dbd
zpsc_DBD += scaleWaveform.dbd
zpsc_DBD += epoch2string.dbd

# Add all the support libraries needed by this IOC
zpsc_LIBS += pscCore

# Add your custom C source here:
zpsc_SRCS += scaleWaveform.c  
zpsc_SRCS += epoch2string.c 

# zpsc_registerRecordDeviceDriver.cpp derives from zpsc.dbd
zpsc_SRCS += zpsc_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
zpsc_SRCS_DEFAULT += zpscMain.cpp
zpsc_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#zpsc_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
zpsc_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

