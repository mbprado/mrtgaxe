# MRTGaxe

MRTGaxe is a simple lightweight monitoring solution for esp-miner based mining devices such as Bitaxe and Nerdaxe. It's suitable for use with multiple devices and plots system metrics using **MRTG** and **BusyBox**. Designed for simplicity, it allows you to quickly deploy monitoring with minimal setup and resource usage. 

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

- **Why it is not written in Python?**: While it would be still very convenient, Python and its libraryes requires extra setup and storage space.
- **MRTG interface is so ugly and seems outdated**: That's true, there are many options out there with better interfaces, like Graphana, but the intention here is easy and ligh setup (M.I.S.S.)
- **Can I use it with Apache, Nginx?**: Absolutely. You can use only the mrtg.cfg file and setup it in youw own web environment.
- ** 

---

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/mbprado/mrtgaxe.git
cd mrtgaxe


# setup.sh
Simple monitoring for Bitaxes using mrtg
