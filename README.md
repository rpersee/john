john
====
Docker images for John the Ripper jumbo

# With Intel iGPU on WSL2
## Update WSL kernel
```powershell
PS > wsl.exe --update
Searching for updates in progress... Please wait
Downloading updates... Please wait.
Installing updates... Please wait
This change will take effect the next time WSL is fully restarted. To force a reboot, run "wsl --shutdown".
Kernel version: 5.10.102.1
PS > wsl.exe --shutdown
```

## Install Intel GPU host driver
Download and install the latest GPU host driver from https://www.intel.com/content/www/us/en/download/19344/intel-graphics-windows-dch-drivers.html

## Run John the Ripper
```bash
$ docker run -it --rm --device /dev/dxg --volume /usr/lib/wsl:/usr/lib/wsl rpersee/john:intel
# clinfo
Number of platforms                               1
  Platform Name                                   Intel(R) OpenCL HD Graphics
...
Number of devices                                 1
  Device Name                                     Intel(R) Graphics [0x3ea0]
...
# john --list=opencl-devices
Platform #0 name: Intel(R) OpenCL HD Graphics, version: OpenCL 3.0
    Device #0 (1) name:     Intel(R) Graphics [0x3ea0]
...
# john --test --format=opencl
...
```
