#!/usr/bin/env python3
import os
import sys
import time
import json
import signal
import requests
import epics
import urllib3

# Suppress InsecureRequestWarning for self-signed certs
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Configuration
API_URL = "https://10.69.26.36"
USERNAME = "localadmin"
PASSWORD = "Localadmin*1234"
DEVICE_ID = 1
PREFIX = "tripp_pdu"
PID_FILE = "/tmp/tripp_pdu_driver.pid"
AUTO_SHUTDOWN_ON_START = False

# Graceful exit handler
def cleanup_and_exit(signum, frame):
    print("Stopping driver...")
    if os.path.exists(PID_FILE):
        os.remove(PID_FILE)
    sys.exit(0)

signal.signal(signal.SIGTERM, cleanup_and_exit)
signal.signal(signal.SIGINT, cleanup_and_exit)

# Save PID to file
with open(PID_FILE, "w") as f:
    f.write(str(os.getpid()))

def get_token():
    try:
        r = requests.post(
            f"{API_URL}/api/oauth/token?grant_type=password",
            verify=False,
            headers={"Content-Type": "application/json"},
            data=json.dumps({"username": USERNAME, "password": PASSWORD})
        )
        r.raise_for_status()
        return r.json().get("access_token")
    except Exception as e:
        print(f"[!] Failed to fetch token: {e}")
        return None

def control_outlet(token, outlet_id, action):
    try:
        r = requests.patch(
            f"{API_URL}/api/loads_execute/{outlet_id}",
            verify=False,
            headers={
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            },
            data=json.dumps({
                "data": {
                    "attributes": {
                        "device_id": DEVICE_ID,
                        "load_action": action
                    },
                    "type": "loads_execute"
                }
            })
        )
        r.raise_for_status()
        print(f"[+] Set outlet {outlet_id} -> {action}")
    except Exception as e:
        print(f"[!] Failed to control outlet {outlet_id}: {e}")

def read_status(token, outlet_id):
    try:
        r = requests.get(
            f"{API_URL}/api/loads/{outlet_id}",
            verify=False,
            headers={"Authorization": f"Bearer {token}"}
        )
        r.raise_for_status()
        data = r.json()
        state_str = data["data"]["attributes"]["state"]
        return "ON" if state_str == "LOAD_STATE_ON" else "OFF"
    except Exception as e:
        print(f"[!] Failed to read status for outlet {outlet_id}: {e}")
        return "UNKNOWN"

def setup_pvs():
    epics.caput(f"{PREFIX}:STATUS", "2")  # 2 = OK

    for i in range(1, 9):
        outlet_id = i
        ctrl_pv = f"{PREFIX}:OUT{i}:CTRL"
        stat_pv = f"{PREFIX}:OUT{i}:STAT"

        triggered = {"initial": True}

        # Set CTRL PV to current device state at startup
        initial_state = read_status(get_token(), outlet_id)
        initial_value = 1 if initial_state == "ON" else 0
        epics.caput(ctrl_pv, initial_value)

        def make_callback(outlet_id, triggered_flag):
            def callback(pvname=None, value=None, **kwargs):
                if triggered_flag["initial"]:
                    triggered_flag["initial"] = False
                    return
                token = get_token()
                if token:
                    action = "LOAD_ACTION_ON" if int(value) else "LOAD_ACTION_OFF"
                    control_outlet(token, outlet_id, action)
            return callback

        epics.PV(ctrl_pv, callback=make_callback(outlet_id, triggered.copy()))

def monitor_loop():
    token = get_token()
    if not token:
        print("No valid token, exiting.")
        return

    state_map = {"ON": 1, "OFF": 0, "UNKNOWN": -1}

    while True:
        for i in range(1, 9):
            stat_pv = f"{PREFIX}:OUT{i}:STAT"
            state = read_status(token, i)
            value = state_map.get(state.upper(), -1)
            epics.caput(stat_pv, value)
        time.sleep(5)

if __name__ == "__main__":
    print("[*] Starting driver...")

    if AUTO_SHUTDOWN_ON_START:
        token = get_token()
        if token:
            for i in range(1, 9):
                control_outlet(token, i, "LOAD_ACTION_OFF")

    setup_pvs()
    monitor_loop()
