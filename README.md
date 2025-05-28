# zPSC IOC Suite

This repository contains the full suite of Input/Output Controllers (IOCs) for controlling and monitoring zPSC (Power Supply Controller) devices in an EPICS-based control system.

## Overview

Each IOC in this repository is dedicated to a specific PSC unit. The architecture is now modularized, enabling clear separation of configuration and control logic for each device.

### Structure

- `psc1/` through `psc5/`:  
  Each directory contains a fully functional IOC for a specific PSC device, with its own `st.cmd`, macros, and PV configuration.

- `zpsc_ioc/`:  
  Common support modules, database definitions, and scripts shared across all PSC IOCs. This acts as the shared core for all device-specific IOCs.

- `test/`:  
  Contains test databases and a minimal IOC for experimental or development use.

## Features

- Modular IOC layout supporting up to 5 PSC units.
- Common startup and initialization scripts (`commonSt.cmd`, `commonInit.cmd`) to ensure consistency across all units.
- Easy replication of IOC instances by copying a `pscX/` folder and adjusting macro settings (e.g., `PSC`, `PSC_IP`).
- Shared database and device support logic under `zpsc_ioc`.

## How to Use

1. Clone this repository:
   ```bash
   git clone https://github.com/Rainer1370/zpscIoc.git
   cd zpscIoc
   
2. Build the common IOC application under zpsc_ioc/
   ```bash
   make
   
3. Run the desired IOC, example:
   ```bash
   ./psc1/st.cmd

## Notes
  Ensure your environment variables (e.g., EPICS_BASE, HOST_ARCH) are properly configured.
  This repo no longer uses embedded Git submodules for individual IOCs. All subdirectories are now part of the main repo.

## Author
  Rob Rainer,
  Osprey Distributed Control Systems ([OspreDCS.com](https://ospreydcs.com/))
