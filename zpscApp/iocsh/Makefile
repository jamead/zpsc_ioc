TOP = ../..
include $(TOP)/configure/CONFIG

# IOCSH += zpsc.iocsh
IOCSH += $(patsubst ../%, %, $(wildcard ../*.iocsh))

include $(TOP)/configure/RULES

