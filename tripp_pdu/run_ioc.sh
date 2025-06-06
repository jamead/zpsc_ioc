#!/bin/bash

# Kill any existing driver instance
pkill -f tripp_driver.py

# Start the Python driver in the background
python3 tripp_pduApp/src/tripp_driver.py &

# Start the IOC
./bin/linux-x86_64/tripp_pdu st.cmd
