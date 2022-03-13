#include <Arduino.h>

#include <Adafruit_ZeroI2S.h>
#include <math.h>

#include <SPI.h>
#include <SD.h>

Sd2Card card;
SdVolume volume;
SdFile root;
const int chipSelect = 10;

/* max volume for 32 bit data */
#define VOLUME ( (1UL << 31) - 1)

/* create a buffer for both the left and right channel data */
#define BUFSIZE 128
int left[BUFSIZE];
int right[BUFSIZE];

// Use default pins in board variant
Adafruit_ZeroI2S i2s = Adafruit_ZeroI2S();

void setup()
{
  SerialUSB.begin(115200);
  while (!SerialUSB) delay(10);
  SerialUSB.println("I2S demo");

  for (int i = 0; i < BUFSIZE; i++) {
    /* create a sine wave on the left channel */
    left[i] = sin( (2 * PI / (BUFSIZE) ) * i) * VOLUME;

    /* create a cosine wave on the right channel */
    right[i] = cos( (2 * PI / (BUFSIZE) ) * i) * VOLUME;
  }

  /* begin I2S on the default pins. 24 bit depth at
     44100 samples per second
  */
  i2s.begin(I2S_32_BIT, 44100);
  i2s.enableTx();

   SerialUSB.print("\nInitializing SD card...");

  if (!card.init(SPI_HALF_SPEED, chipSelect)) {
    SerialUSB.println("initialization failed. Things to check:");
    SerialUSB.println("* is a card inserted?");
    SerialUSB.println("* is your wiring correct?");
    SerialUSB.println("* did you change the chipSelect pin to match your shield or module?");
  } else {
    SerialUSB.println("Wiring is correct and a card is present.");
  }

  // print the type of card
  SerialUSB.println();
  SerialUSB.print("Card type:         ");
  switch (card.type()) {
    case SD_CARD_TYPE_SD1:
      SerialUSB.println("SD1");
      break;
    case SD_CARD_TYPE_SD2:
      SerialUSB.println("SD2");
      break;
    case SD_CARD_TYPE_SDHC:
      SerialUSB.println("SDHC");
      break;
    default:
      SerialUSB.println("Unknown");
  }

  // Now we will try to open the 'volume'/'partition' - it should be FAT16 or FAT32
  if (!volume.init(card)) {
    SerialUSB.println("Could not find FAT16/FAT32 partition.\nMake sure you've formatted the card");
    while (1);
  }

  SerialUSB.print("Clusters:          ");
  SerialUSB.println(volume.clusterCount());
  SerialUSB.print("Blocks x Cluster:  ");
  SerialUSB.println(volume.blocksPerCluster());

  SerialUSB.print("Total Blocks:      ");
  SerialUSB.println(volume.blocksPerCluster() * volume.clusterCount());
  SerialUSB.println();

  uint32_t volumesize;
  SerialUSB.print("Volume type is:    FAT");
  SerialUSB.println(volume.fatType(), DEC);

  volumesize = volume.blocksPerCluster();
  volumesize *= volume.clusterCount();
  volumesize /= 2;
  SerialUSB.print("Volume size (Kb):  ");
  SerialUSB.println(volumesize);
  SerialUSB.print("Volume size (Mb):  ");
  volumesize /= 1024;
  SerialUSB.println(volumesize);
  SerialUSB.print("Volume size (Gb):  ");
  SerialUSB.println((float)volumesize / 1024.0);

  SerialUSB.println("\nFiles found on the card (name, date and size in bytes): ");
  root.openRoot(volume);

  root.ls(LS_R | LS_DATE | LS_SIZE);
}

void loop()
{
  /* write the output buffers
     note that i2s.write() will block until both channels are written.
  */
  for (int i = 0; i < BUFSIZE; i++) {
    i2s.write(left[i], right[i]);
  }
}
