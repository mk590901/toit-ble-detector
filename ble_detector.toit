import ble
import ntp
import esp32 show adjust-real-time-clock
import .periodic_timer
import .ble_utils

DEVICE_NAME     ::= "R09_0803"
scan_period     ::= 4     //  4 
check_period    ::= 8     //  8
SCAN_DURATION   ::= Duration --s=scan_period
CHECK_INTERVAL  ::= Duration --s=check_period

class BleScanner :
  
  process_timer_/PeriodicTimer  := PeriodicTimer check_period
  
  process_counter_/int          := 0
  mac_address_/string           := ""
  is_running_/bool              := false  // true
  is_online_/bool               := false
  is_first_time_/bool           := false

  adapter/ble.Adapter? := null

  change_state is_online -> bool :
    result/bool := false 
    if is_first_time_ :
      is_first_time_ = false
      is_online_ = is_online
      result = true
    else :
      result = false
      if not (is_online_ == is_online) :
        is_online_ = is_online
        result = true
    return result

  observation :
    sign/bool := false
    if (process_counter_ == 0) :
      sign = change_state false
      if sign :
        task::
          print "  $time | No  | $DEVICE_NAME"
    else :
      sign = change_state true
      process_counter_= 0
      if sign :
        task::
          print "* $time | Yes | $DEVICE_NAME | $mac_address_"


  stop :
    print "Scan final at $time"
    is_running_ = false
    process_timer_.final

  start_scan :
    task::
      scan

  final_scan :
    task::
      stop

  scan :

    adapter = ble.Adapter

    print "BLE device '$DEVICE_NAME' presence monitoring has started"
    print "Scan start at $time, $SCAN_DURATION every $CHECK_INTERVAL"

    is_first_time_ = true
    is_running_ = true

    process_counter_ = 0
    process_timer_.start ::observation

    while is_running_ :
      adapter.central.scan --duration=SCAN_DURATION: | dev/ble.RemoteScannedDevice |
        name := dev.data.name
        if not name : continue
        if name == DEVICE_NAME :
          mac_address_ = conv-to-mac-address "$dev.identifier"
          process_counter_++
        else :
          continue
      sleep --ms=100
  
    adapter.close
    adapter = null

  dispose :
    task::
      process_timer_.dispose

sync_time :
  now := Time.now
  if now < (Time.parse "2022-01-10T00:00:00Z"):
    result ::= ntp.synchronize
    if result:
      adjust-real-time-clock result.adjustment
      print "Set time to $Time.now by adjusting $result.adjustment"
    else:
      print "ntp: synchronization request failed"
  else:
    print "We already know the time is $now"

main :
  
  sync_time

  bleScanner/BleScanner := BleScanner
  task::
    bleScanner.start_scan
    sleep (Duration --s=90)
    bleScanner.final_scan
    sleep (Duration --s=5)
    bleScanner.start_scan
    sleep (Duration --s=90)
    bleScanner.final_scan
    bleScanner.dispose
