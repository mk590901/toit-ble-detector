# TOIT-BLE-Detector App

## Introduction

Below is an application running on an __ESP32-S3__ continuously monitors the presence of a __BLE__ device in a room and detects its disappearance and reappearance. Any smart ring, such as the __COLMI R09/R12__, can be used as the device. Could try using the app to track a person's movements around the house 🤓 (just kidding). Really this is a test application designed to test the feasibility of creating an application on Toit that would continuously scan a health care __BLE__ device, connect to it when detected, perform measurements, and stop scanning when the connection is lost, returning to scanning mode again.

## Brief Description

The application's design principles are outlined below.

### Class BleScanner

This class is the core of the application. The main function is __scan__. It initiates a continuous scan of a BLE device named "R09_0803" and two periodic timers, one of which determines the presence or absence of the device: __process_timer___, and the other serves as a time limiter for the application's run: __task_timer___.

When a device is detected, the __process_counter___ variable is incremented. This counter is checked in the __observation__ procedure. If it is different from 0, it indicates the presence of the device; if 0, it means the device is absent.

To minimize output, a __change_state__ function was created only detects device transitions from __online__ to __offline__ and back.

## Notes

The application is represented by two practically identical files: _ble_scanner.toit_ and _ble_detector.toit_, which differ in minor details.

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

