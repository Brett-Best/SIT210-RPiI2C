import Foundation
import Rainbow
import SwiftyGPIO
import PythonKit

print(
  "RPiI2C + TMP102 Temperature Sensor\n\n".magenta.bold.underline +
    "# Wiring\n\n".cyan.bold +
    """
  | Name            | Physical Pin | BCM Mapping |
  |-----------------|:------------:|:-----------:|
  | TMP102 GND      |       9      |     N/A     |
  | TMP102 1.4-2.6V |       1      |     N/A     |
  | TMP102 SDA      |       3      |      2      |
  | TMP102 SCL      |       5      |      3      |
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

let bus = smbus.SMBus(1)

repeat {
  do {
    let data = try bus.read_i2c_block_data.throwing.dynamicallyCall(withArguments: 0x48, 0)
    
    let msb = Int(data[0])!
    let lsb = Int(data[1])!
    
    let temperature = Double(((msb << 8) | lsb) >> 4) * 0.0625
    
    print("Temperature: \(temperature)ºC")
  } catch {
    print("I2C Error: \(error)")
  }
  
  sleep(1)
} while (true)
