/*******************************************************************************
 *  B O A R D   &   F U S E S   C O N F I G U R A T I O N
 *  - MCU: ATtiny85
 *  - Board: Digispark (16MHz - No USB)
 *  - Fuses: Low fuse 0xE1; High fuse 0xDD; Extended fuse 0xFE
 *  - First run cli: `avrdude -pattiny85 -Pusb -catmelice_isp -Ulfuse:w:0xE1:m   -Uhfuse:w:0xDD:m   -Uefuse:w:0xFE:m`
 ******************************************************************************/

#include <Adafruit_NeoPixel.h>
Adafruit_NeoPixel ws2812 = Adafruit_NeoPixel(1, 3, NEO_GRB + NEO_KHZ800);

void setup() {
  ws2812.begin();
  ws2812.setPixelColor(0, 0, 0, 0);
  ws2812.show();
}

void loop() {
    while(1);
  ws2812.setPixelColor(0, 255, 255, 255);
  ws2812.show();
  delay(500);
  ws2812.setPixelColor(0, 0, 0, 0);
  ws2812.show();
  delay(500);
}
