# MRTGAxe

MRTGaxe is a simple lightweight monitoring solution for esp-miner based mining devices such as Bitaxe and Nerdaxe. It's suitable for use with multiple devices and plots system metrics using **MRTG** and **BusyBox**. 
Designed for simplicity, it allows you to quickly deploy monitoring with minimal setup and resource usage.  
This is intended for long term analysys, while AxeOS interface by default does't store this type of data, MRTG can keep track up to one year without log growing, like other monitoring tools. Ideal for quick insights and profiling.

---

## Features

- **Easy setup**: Get your Bitaxe monitoring running in minutes with minimal configuration.  
- **Lightweight**: Uses BusyBox and MRTG, making it ideal for low-power devices like early versions of Raspberry Pi.  
- **Efficient**: Minimal CPU and memory footprint.  
- **Customizable**: Supports monitoring multiple interfaces, devices, or custom scripts.  
- **Painless maintenance**: No complex dependencies or heavyweight services.

---

## Why MRTG + BusyBox?

- **MRTG (Multi Router Traffic Grapher)**: Generates graphs and logs data efficiently, is very robust and since MRTG graphics never grow, even a small storage can accomodate the png files.
- **BusyBox**: Provides essential Unix tools in a single lightweight binary, reducing installation complexity and storage requirements.  

## Caeveats, Drawbacks "FAQ"

- **Why it is not written in Python?**: While it would be still very convenient, Python and its libraries requires extra setup and storage space.
- **MRTG interface is so ugly and seems outdated**: That's true, there are many options out there with better interfaces, like Graphana, but the intention here is easy and ligh setup (M.I.S.S.)
- **Can I use it with Apache, Nginx?**: Absolutely. You can use only the mrtg.cfg file and setup it in youw own web environment.
- **Any plans porting it to Windos/Mac?**: Yes, probably with docker but at the cost of simplicity of deployment.

---
## Prerequisites 
All you need is a Linux with **MRTG** and **Busybox** installed. Both packages are found on the main repository of most distros. This quide will assume that you have Raspbian installed in a Raspberry Pi, but it can theoretically run in any other machine. I'm not covering how to make a initial Respberry Pi setup, but it can be easily found in form of several guides over the internet.

1. install the required packages:

```bash
sudo apt update
sudo apt -y install mrtg busybox
```
---
## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/mbprado/mrtgaxe.git
cd mrtgaxe
```

2. Add your first device

As example, our device IP is **192.168.0.200** and we name it **Miner 1**.  
Note: If the name contains spaces, it must be placed between quotes.

```bash
./mrtgaxe_set.sh -d 192.168.0.200 -n "Miner 1"
```

3. Start MRTG
```bash
./mrtgaxe_run.sh
```

---
### Usage:

#### Accessing the graphics

If the script runs fine, you will see the access link in the bottom of the screen. By default, busybox runs on port 9999, to avoid conflicts with other services you could eventually have. It can be changed setting the PORT variable in the mrtgaxe_run.sh

#### Scripts 

1. mrtgaxe_set.sh
This script is used to create configuration files for MRTG. Creating multiple files will create multiple devices in dashboard.  
Files are saved inside **./miners** directory 

Options:
```bash
**-d** : Defines the device to be monirtored. IP address or hostname. A single device per file, for multiple devices, create multiple files.
**-n** : Device the device name that will be shown in the metrics and dashboard. Quote names with spaces and special characters.
**-f** : By default mrtgaxe prevents rewriting files with same device name. Use this option to overcome it.
``` 



---
### To Do

---
Reference:

Bitaxe Project: https://github.com/bitaxeorg  
MRTG: https://oss.oetiker.ch/mrtg
