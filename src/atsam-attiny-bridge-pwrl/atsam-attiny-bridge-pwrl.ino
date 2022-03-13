/*
   Board: Adafruit Feather M0
   Comment on `variants.cpp`:
   `Uart Serial5( &sercom5, PIN_SERIAL_RX, PIN_SERIAL_TX, PAD_SERIAL_RX, PAD_SERIAL_TX ) ;`
   ```
   void SERCOM5_Handler()
   {
     Serial5.IrqHandler();
   }
   ```
*/

#include "wiring_private.h"

Uart mySerial (&sercom5, 6, A5, SERCOM_RX_PAD_2, UART_TX_PAD_0); // Create the new UART instance assigning it to pin 1 and 0

void setup() {
  pinMode(6, OUTPUT);
  digitalWrite(6, HIGH);
  Serial.begin(115200);
  while (!Serial);
  Serial.println("Bridge open");
  digitalWrite(6, LOW);
  delayMicroseconds(750);
  noInterrupts();
  digitalWrite(6, HIGH);
  delayMicroseconds(50);
  digitalWrite(6, LOW);
  interrupts();
  mySerial.begin(115200);
  pinPeripheral(6, PIO_SERCOM); //Assign RX function to pin 6
  pinPeripheral(A5, PIO_SERCOM); //Assign TX function to pin A5
}

void loop() {
  if (mySerial.available())
    Serial.write(mySerial.read());
}

void SERCOM5_Handler() {
  mySerial.IrqHandler();
}
