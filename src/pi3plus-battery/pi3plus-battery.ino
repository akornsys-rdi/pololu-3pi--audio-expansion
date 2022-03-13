#include <Pololu3piPlus32U4.h>
#include <TimerThree.h>
#include <movingAvg.h>

using namespace Pololu3piPlus32U4;
movingAvg battery(256);

#define LOW_BATT 2900

void setup() {
  battery.begin();
  for (int i = 0; i < 256; i++) {
    battery.reading(readBatteryMillivolts());
  }
  Timer3.initialize(200000);
  Timer3.attachInterrupt(callback);
  Serial.begin(115200);
  //while (!Serial);
}

void loop() {
    if (battery.getAvg() < LOW_BATT) {
        // Acción de batería baja
        while (1);
    }
}

void callback() {
  battery.reading(readBatteryMillivolts());
}
