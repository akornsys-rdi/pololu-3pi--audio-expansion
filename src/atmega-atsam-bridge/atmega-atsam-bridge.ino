#include <Pololu3piPlus32U4.h>

using namespace Pololu3piPlus32U4;

void setup() {
  Serial1.begin(115200);
  Serial.begin(115200);
  while (!Serial);
}

void loop() {
  if (Serial1.available()) {
    Serial.write(Serial1.read());
  }
  if (Serial.available()) {
    Serial1.write(Serial.read());
  }
}
