# MediaTek/Intel Wi-Fi Drop Tester

- This basic script pings 8.8.8.8 every 60 seconds and runs a check of iw every 10 seconds to capture as much as possible.

- If there is a drop or even a drop and it resumes, we should see it happen here. This will run for one hour.

- You can stop it at any time with ctrl+c if you need to.

- You will first see "iw is already installed", then it will move to your interface name two seconds later. Then the monitoring will take place for one hour or until you interrupt this.

- Function to install iw if not installed - it should be installed, but this is a fail-safe.

Folks experiencing drops, please use this script, and you can attach both logs created after a full 60 minutes of running and provide this to support with this forum post as well.

- `wget https://github.com/FrameworkComputer/network-tester/blob/main/network-tester.sh` (download script)

- `chmod +x network-tester.sh`

- `sh network-tester.sh` (allowing to run a full hour with the terminal open, can be put behind other windows, but needs to be open)
