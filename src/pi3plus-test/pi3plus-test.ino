/*
 * CUIDADO: Desactivar ModemManager!
 *   `sudo service ModemManager stop`
 */

#include <Pololu3piPlus32U4.h>

using namespace Pololu3piPlus32U4;
Motors motors;
LCD display;

void setup() {
}

void loop() {
  static uint16_t lastDisplayTime = 0;
  static uint16_t lastMotorsTime = 0;
  char buf[6];
  static unsigned char i = 0;

  if ((uint16_t)(millis() - lastDisplayTime) > 100) {
    bool usbPower = usbPowerPresent();
    uint16_t batteryLevel = readBatteryMillivolts();

    lastDisplayTime = millis();
    display.gotoXY(0, 0);
    sprintf(buf, "%5d", batteryLevel);
    display.print(buf);
    display.print(F(" mV"));
    display.gotoXY(3, 1);
    display.print(F("USB="));
    display.print(usbPower ? 'Y' : 'N');
  }

  if ((uint16_t)(millis() - lastMotorsTime) > 500) {
    i++;
    lastMotorsTime = millis();
    switch (i) {
      case 1:
        ledYellow(true);
        motors.setSpeeds(400, 400);
        break;
      case 2:
        motors.setSpeeds(-400, -400);
        break;
      case 3:
        ledYellow(false);
        motors.setSpeeds(0, 0);
        break;
      case 4:
        i = 0;
        break;
    }
  }
}
