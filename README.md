# MediaTek/Intel Wi-Fi Drop Tester

- Auto-installs needed packages for Fedora OR Ubuntu. Not configured as is for other distros (minor tweaks needed for that).

- This basic script pings 8.8.8.8 every 60 seconds and runs a check of iw every 10 seconds to capture as much as possible.

- If there is a drop or even a drop and it resumes, we should see it happen here. This will run for one hour.

- You can stop it at any time with ctrl+c if you need to.

- You will first see "iw is already installed", then it will move to your interface name two seconds later. Then the monitoring will take place for one hour or until you interrupt this.

- Function to install iw if not installed - it should be installed, but this is a fail-safe.

- Folks experiencing drops, please use this script, and you can attach both logs created after a full 60 minutes of running and provide this to support. 

- Logs created are iw_logfile and ping_logfile.

Curl should already be installed.

But just in case:

#### Fedora
```
sudo dnf install curl -y
```

or

#### Ubuntu
```
sudo apt install curl -y
```

**Then run:**

- ```
  curl -s https://raw.githubusercontent.com/FrameworkComputer/network-tester/main/network-tester.sh -o network-tester.sh && clear && sh network-tester.sh
  ```
  
(Run a full hour with the terminal open, can be put behind other windows, but needs to be open)


---------

## Short example of iw_logfile

```
Kernel Version: 6.8.9-300.fc40.x86_64
BIOS Version: 03.03
Linux Distribution: Fedora release 40 (Forty)
Device Brand: MEDIATEK Corp.
Driver: mt7921e
---------------------------
Thu May 16 11:19:52 AM PDT 2024:
Connected to d8:8e:d4:7d:2e:c8 (on wlp5s0)
	SSID: MEH
	freq: 6135.0
	RX: 1447320118 bytes (7771244 packets)
	TX: 81050139 bytes (749311 packets)
	signal: -43 dBm
	rx bitrate: 2161.3 MBit/s 160MHz HE-MCS 10 HE-NSS 2 HE-GI 0 HE-DCM 0
	tx bitrate: 1441.3 MBit/s 160MHz HE-MCS 7 HE-NSS 2 HE-GI 0 HE-DCM 0
	bss flags: short-slot-time
	dtim period: 2
	beacon int: 100
---------------------------
Thu May 16 11:20:02 AM PDT 2024:
Connected to d8:8e:d4:7d:2e:c8 (on wlp5s0)
	SSID: MEH
	freq: 6135.0
	RX: 1447341370 bytes (7771348 packets)
	TX: 81061431 bytes (749368 packets)
	signal: -43 dBm
	rx bitrate: 2161.3 MBit/s 160MHz HE-MCS 10 HE-NSS 2 HE-GI 0 HE-DCM 0
	tx bitrate: 1441.3 MBit/s 160MHz HE-MCS 7 HE-NSS 2 HE-GI 0 HE-DCM 0
	bss flags: short-slot-time
	dtim period: 2
	beacon int: 100
```
 -------------------------

 ## Short example of ping_logfile

```
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=24.9 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=21.0 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=57 time=48.3 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=57 time=27.8 ms
64 bytes from 8.8.8.8: icmp_seq=6 ttl=57 time=28.0 ms
64 bytes from 8.8.8.8: icmp_seq=7 ttl=57 time=42.7 ms
64 bytes from 8.8.8.8: icmp_seq=8 ttl=57 time=35.4 ms
64 bytes from 8.8.8.8: icmp_seq=9 ttl=57 time=29.0 ms
```
