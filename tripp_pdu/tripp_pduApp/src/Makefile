TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET

# xxxRecord.h will be created from xxxRecord.dbd
DBDINC += xxxRecord

# Install xxxSupport.dbd into <top>/dbd
DBD += xxxSupport.dbd

# Build an IOC support library
LIBRARY_IOC += tripp_pduSupport

# Compile and add code to the support library
tripp_pduSupport_SRCS += xxxRecord.c
tripp_pduSupport_SRCS += devXxxSoft.c

# Link locally-provided code into the support library,
# rather than directly into the IOC application, that
# causes problems on Windows DLL builds
tripp_pduSupport_SRCS += dbSubExample.c
tripp_pduSupport_SRCS += devtripp_pduVersion.c
tripp_pduSupport_SRCS += tripp_pduHello.c
tripp_pduSupport_SRCS += initTrace.c

tripp_pduSupport_LIBS += $(EPICS_BASE_IOC_LIBS)

# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = tripp_pduVersion.h
# Macro name
GENVERSIONMACRO = tripp_pduVERSION

# Build the IOC application
PROD_IOC = tripp_pdu

# tripp_pdu.dbd will be created and installed
DBD += tripp_pdu.dbd

# tripp_pdu.dbd will include these files:
tripp_pdu_DBD += base.dbd
tripp_pdu_DBD += xxxSupport.dbd
tripp_pdu_DBD += dbSubExample.dbd
tripp_pdu_DBD += devtripp_pduVersion.dbd
tripp_pdu_DBD += tripp_pduHello.dbd
tripp_pdu_DBD += initTrace.dbd

# tripp_pdu_registerRecordDeviceDriver.cpp derives from tripp_pdu.dbd
tripp_pdu_SRCS += tripp_pdu_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
tripp_pdu_SRCS_DEFAULT += tripp_pduMain.cpp
tripp_pdu_SRCS_vxWorks += -nil-

# Link in the code from our support library
tripp_pdu_LIBS += tripp_pduSupport

# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncExample into tripp_pduSupport
    sncExample_SNCFLAGS += +r
    tripp_pdu_DBD += sncExample.dbd
    # A .stt sequence program is *not* pre-processed:
    tripp_pduSupport_SRCS += sncExample.stt
    tripp_pduSupport_LIBS += seq pv
    tripp_pdu_LIBS += seq pv

    # Build sncProgram as a standalone program
    PROD_HOST += sncProgram
    sncProgram_SNCFLAGS += +m
    # A .st sequence program *is* pre-processed:
    sncProgram_SRCS += sncProgram.st
    sncProgram_LIBS += seq pv
    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    tripp_pdu_LIBS += qsrv
    tripp_pdu_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    tripp_pdu_DBD += PVAServerRegister.dbd
    tripp_pdu_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
tripp_pdu_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devtripp_pduVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
