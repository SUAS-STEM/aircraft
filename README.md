# SUAS@STEM Aircraft

SUAS@STEM's aircraft backend for autonomous missions and ground control station dashboard. Communication with the aircraft's flight controller is through MAVSDK.

## Dependencies

**You will need**:
* **Microsoft Visual Studio C++** supporting C++17 or higher; MinGW is not supported
* CMake 3.1
* MAVSDK

To install MAVSDK:
1. Download `mavsdk-windows-x64.zip` from the latest [MAVSDK release](https://github.com/mavlink/MAVSDK/releases)
2. Extract the downloaded files to `C:\mavsdk`

## Building from source

Sources are built into a shared library intended to be used with a Git submodule and linked to an executable.

```
cmake -S . -B build
cmake --build build --config Release
```
