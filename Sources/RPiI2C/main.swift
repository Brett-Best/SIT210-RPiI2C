import Foundation
import Rainbow
import SwiftyGPIO
import PythonKit

print(
  "RPiI2C Temperature Sensor\n\n".magenta.bold.underline +
    "# Wiring\n\n".cyan.bold +
    """
  | Name            | Physical Pin | BCM Mapping |
  |-----------------|:------------:|:-----------:|
  | Blue LED        |      12      |     P18     |
  | HC-SR04 Trigger |      37      |     P26     |
  | HC-SR04 Echo    |      40      |     P21     |
  \n
  """.green +
    "# Logging\n".cyan.bold
)

#if os(macOS)
print("This application only runs on the Raspbery Pi 3!\nPress any key to exit...".lightRed)
_ = readLine()
exit(0)
#endif

signal(SIGINT) { _ in
  print("RPiI2C Finished")
  exit(0)
}

let smbus: PythonObject

do {
  smbus = try Python.attemptImport("smbus")
} catch {
  fatalError("Failed to import python smbus with error: \(error)")
}

let sys = try Python.import("sys")

let bus = smbus.SMBus(1)

repeat {
  let data = bus.bus.read_i2c_block_data(0x48, 0)
  let msb = data[0]
  let lsb = data[1]
  
  print(data)
  print(msb)
  print(lsb)
//  print((((msb << 8) | lsb) >> 4) * 0.0625)
} while (true)


/*
 #!/usr/bin/env python3
 
 import smbus
 import time
 bus = smbus.SMBus(1)
 data = bus.read_i2c_block_data(0x48, 0)
 msb = data[0]
 lsb = data[1]
 # shift the msb 8 bits to the left and add to lsb
 # then shift number 4 bits to right
 # then multiply by 0.0625
 print((((msb << 8) | lsb) >> 4) * 0.0625) # printout in Celcius
 */
