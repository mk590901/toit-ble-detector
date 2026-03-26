# TOIT-BLE-Detector App

## Introduction

The app below, running on an __ESP32-S3__, continuously monitors the presence of a __BLE__ device in a room and tracks the disappearance and reappearance of the smart rings like __COLMI R09/R12__. Could try using the app to track a person's movements around the house. It's a shame, though, the smart ring only be used as a location tag 🤓, but this only experiment.

## Notes

> App using the ntp package (https://docs.toit.io/tutorials/misc/date-time)

> Command to run app:
```
micrcx@micrcx-desktop:~/toit/ble_scanner$ jag run -d basic ble_scanner.toit
Scanning for device with name: 'basic'
Running 'ble_scanner.toit' on 'basic' ...
Success: Sent 78KB code to 'basic' in 2.92s
micrcx@micrcx-desktop:~/toit/ble_scanner$ 
```
## Screen & log

<img width="1600" height="900" alt="scanner from 2026-03-12 08-33-43" src="https://github.com/user-attachments/assets/19982973-cb3e-4dff-af43-138344c83e6a" />

