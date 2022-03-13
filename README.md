# Pololu 3PI+ Audio Expansion API

Expansion board to provide audio playback for Pololu 3pi+ 32U4 Robot

## System interconnection diagram

            ┌──────┐   ┌──────┐         D    ┌───┐
            │ USB  │   │ USB  │       ┌──────┤RX │
            │SUBSYS│   │SUBSYS│       │      │ANT│
            ├──────┤   ├──────┤       ▼      └───┘
            ├──────┤ B ├──────┤   ┌──────┐
    ┌───┐   │      │◄──┤      │   │      │   ┌───┐
    │BAT├──►│ 32U4 │   │ SAMD │◄─►┤ TINY ├──►│RGB│
    │LVL│ A │      ├──►│      │ E │      │ D │LED│
    └───┘   ├──────┤ C ├──────┤   └──────┘   └───┘
            ├──────┤   ├──────┤       ▲
            │ROBOT │   │AUDIO │       │      ┌───┐
            │SUBSYS│   │SUBSYS│       └──────┤ID │
            └──────┘   └──────┘         A    │POT│
                                             └───┘
    COMMUNICATION:
    A -> ANALOG             B -> SERIAL DOWNLINK
    C -> SERIAL UPLINK      D -> DIGITAL PROTOCOL
    E -> DIGITAL INTERLINK

## Protocolos de comunicaciones

- Battery reading by analog reading of `A1` of the **ATmega32U4**, the `readBatteryMillivolts()` function (implemented by the Pololu library) provides this functionality.
- Reading the identifier selection potentiometer by analog reading of `A2` from the **ATtiny85**, the `readIdPot()` function (to be implemented in code) provides this functionality.
- Bidirectional communication between **ATmega32U4** and **ATSAMD21** via serial protocol with level shifting at 115200bps. The `Serial1` port is at the **ATmega32U4** end, while the `Serial` port is at the **ATSAMD21** end.
- Reading of the 433MHz radio receiver in 24bit protocol. Realized by the `rc-switch` library (fork).
- WS2812B type RGB LED writing. Realized by the `Adafruit NeoPixel` library.
- Communication primarily one-way from the **ATtiny85** to the **ATSAMD21**. The line level determines what has been received via the radio, leaving the line in high impedance (with pulldown) until the first reception. At startup, different pulses are generated to check the initial status and send the identifier (see corresponding sections).

## Software versions

**ATmega32U4**
- IDE: Arduino IDE 1.8.19
- Board: [Pololu A-Star Boards](https://github.com/pololu/a-star) 4.0.2 by Pololu
- Libraries: 
  + [Pololu3piPlus32U4](https://github.com/pololu/pololu-3pi-plus-32u4-arduino-library) 1.1.2 by Pololu
    * [FastGPIO](https://github.com/pololu/fastgpio-arduino) 2.1.0 by Pololu
    * [USBPause](https://github.com/pololu/usb-pause-arduino) 2.0.0 by Pololu
    * [Pushbutton](https://github.com/pololu/pushbutton-arduino) 2.0.0 by Pololu
    * [PololuBuzzer](https://github.com/pololu/pololu-buzzer-arduino) 1.2.0 by Pololu
    * [PololuHD44780](https://github.com/pololu/pololu-hd44780-arduino) 2.0.0 by Pololu
    * [PololuOLED](https://github.com/pololu/pololu-oled) 2.0.0 by Pololu
    * [PololuMenu](https://github.com/pololu/pololu-menu-arduino) 2.0.0 by Pololu
  + [TimerThree](https://playground.arduino.cc/Code/Timer1/) 1.1.0 by Jesse Tane, Jérôme Despatis, Michael Polli, Dan Clemens, Paul Stoffregen
  + [movingAvg](https://github.com/JChristensen/movingAvg) 2.3.1 by Jack Christensen

**ATSAMD21**
- IDE: Arduino IDE 1.8.19
- Board: Arduino SAMD Boards (32-bits ARM Cortex-M0+) 1.8.7 by Arduino
- Libraries:
  + [Arduino Sound](https://www.arduino.cc/en/Reference/ArduinoSound) 0.2.1 by Arduino
  + [SD](https://www.arduino.cc/en/Reference/SD) 1.2.3 by Arduino
  + [SDConfig](https://www.arduino.cc/reference/en/libraries/sdconfig/) 1.1.0 by Claus Mancini

**ATtiny85**
- IDE: Arduino IDE 1.8.19
- Board: [attiny](https://github.com/damellis/attiny) 1.0.2 by David A. Mellis
- Libreries: 
  + [Adafruit NeoPixel](https://github.com/adafruit/Adafruit_NeoPixel) 1.1.8 by Adafruit
  + [rc-switch](https://github.com/luelista/rc-switch/tree/feature-pcint-rebased) 2.6.2 by Mira Weller (fork).
    * [PinChangeInterrupt](https://github.com/NicoHood/PinChangeInterrupt) 1.2.9 by NicoHood
  + [ATtinySerialOut](https://github.com/ArminJo/ATtinySerialOut) 1.1.0 by Armin Joachimsmeyer

## General information

All **ATtiny85**, **ATSAMD21** and **ATmega32U4** firmware must share common values in the `N_ROBOTS` constant with the value of the maximum number of robots running simultaneously.

## Initial check

The **ATSAMD21** shall perform an initial check at startup, where it will check for the existence and correct access to the SD card, as well as that there is at least one valid audio of each required type. Hardware checks may also be performed. If any of these checks are not correct, the **ATSAMD21** will send the command `#` to the **ATmega32U4**, flash the user LED and, if available, attempt to play a special audio to indicate this circumstance. After this it will latch, ceasing to perform any other functionality until a power cycle is performed.

If the check is successful, it will send the `%` command, and will play, if available, an OK check audio. In the case of having the special audio of check ok, the command of this circumstance will be sent at the end of the reproduction of this audio. Once the initial check has been performed, the system will be able to perform the other functionalities explained in this document.

During the initial check at start-up of **ATSAMD21**, it will maintain the interlink line with **ATtiny85** at high level, thus indicating that it is present and that it is in the process of being checked. As soon as the initial check process is finished, this line will be set low and control of it will be given to the identifier assignment routine.

The **ATtiny85** can set a timeout time waiting for this high level signal, which if it does not appear, it will be considered that communication between these two microcontrollers cannot be established.

If the `MAIN.CFG` file is available on the SD card, it will try to read from it new settings, which will replace the default settings.

The **ATmega32U4** can set a timeout time, after which the Audio Expansion board is considered not available or does not respond. The behavior in this scenario is not determined.

## Identifier assignment operation

The assignment of the identifier is performed at system startup, when the potentiometer that selects the identifier is read. This reading by the **ATtiny85** is processed and converted into a range between `0` and `N_ROBOTS - 1`. The resulting `identifier` is transmitted by a variable width pulse to the **ATSAMD21**. Each identifier is assigned a color on the RGB LED by dividing the color spectrum by the constant `N_ROBOTS` and multiplying the hue angle by `identifier`.

For the pulse indicating the assigned identifier, the **ATSAMD21** after having performed its initial check (being successful), will generate a low level pause on the interlink line of 750µs. After this, it will generate a first high level pulse of 50µs, thus indicating to the **ATtiny85** that it is ready to receive. 5µs later, the **ATtiny85** starts a pulse with a length of (360µs/`N_ROBOTS`)*`identifier`. After this pulse it waits another 25µs at low level before giving control of the line to the remote command routine.

During program execution, the **ATtiny85** periodically reads the potentiometer that selects the identifier for changes. If a change is produced, it displays the new color corresponding to the resulting identifier for three seconds. This functionality has priority in the use of the RGB LED. The new identifier does not replace the previous one, and a power cycle is required for the new identifier selected via the potentiometer to be assigned.

In the communication between the **ATmega32U4** and the **ATSAMD21**, the former can ask at any time for the current identifier, by sending an `@`. If the **ATSAMD21** has already received the identifier from the **ATtiny85**, it will send a character between the `A` and the `~`. Otherwise, it will respond with `@`, thus indicating that it is still unknown. If this circumstance occurs, the **ATmega32U4** must keep asking until it gets a valid answer.

## Remote command operation

The remote command operation allows to pause the robots, or to resume running. It is performed through a 433MHz command, and the command received is processed by the **ATtiny85**. This command is relayed to the **ATSAMD21** via the interlink line level. The **ATSAMD21** will send a command to the **ATmega32U4** with each change of this command. At startup, until the first reception, it should be considered to be in a paused state.

The **ATtiny85** microcontroller decodes the keystroke received from the control and considers whether it is a pause or run command. The interlink line will be set to low or high level respectively. The line remains in high impedance state (with pulldown) until the first command is received.

The RGB LED will blink with the color of the identifier if paused, and will remain fixed for five seconds from the moment of activation, before turning off. It will turn back on with each change of command, remaining in the previous state if a keystroke equal to the current command is repeated.

At the moment of a new change detected by the **ATSAMD21**, it will generate a command via serial port to the **ATmega32U4**. A `&` is sent in case of a run resume command, and a `$` in case of pause or standby. The **ATmega32U4** must receive the command. No response is required.

## Audio playback operation

The **ATmega32U4** shall be able to generate audio playback and end of playback command at any time after the initial check. The **ATSAMD21** shall receive the command and act accordingly. There are two playback commands, depending on their type. The `>` command will initiate playback of path audios (type A), which will be repeated indefinitely if it reaches its end. The `!` command will start the playback of collision audios (type B), which will be played only once. The path audios will stop on receipt of the `=` command.

In the event of path audio playback, the **ATSAMD21** shall choose a random audio file among those provided on the SD card of its type, and start the playback. Randomly, between 1 and 5 times, the same path audio shall be played in successive receptions of that command, after which another audio shall be randomly chosen again with the same strategy.

In the event of collision audio playback, the **ATSAMD21** shall choose a random audio file among those provided on the SD card of its type, and start its playback until the file reaches its end.

If a play command is received while an audio file is already playing, this command will be ignored as long as a special audio is not being played, in which case it will be added to the play queue and played when the special audio is finished.

On the path audio playback stop event, the current audio playback will be stopped, as long as it is of this type. This action will do nothing if a file is not playing or if the playback is of another type.

### File format

The WAVE file format must be PCM mono 16bit at 22050Hz, with extension `.wav`. Any other format cannot be played.

### File names

For path and collision audios, only those files that are consecutive from `000` will be considered.

| File name               | Type     | Description                   |
|-------------------------|----------|-------------------------------|
| `A000.WAV` - `A999.WAV` | Required | Interval of path audios       |
| `B000.WAV` - `B999.WAV` | Required | Interval of collision audios  |
| `CHKOK.WAV`             | Special  | Initial check ok indicator    |
| `CHKKO.WAV`             | Special  | Initial check error indicator |
| `LWBAT.WAV`             | Special  | Low battery indicator         |

Special audios are optional.

## Battery readout operation

The battery level must be constantly monitored, in order to stop the robot if the charge drops below the `LOW_BATT` threshold. This monitoring is done by the **ATmega32U4**, which must send a command to the **ATSAMD21** in case the battery voltage drops below this threshold, which is done by sending a `-` only at the time of detection. The current battery comparison is done using the average of the last readings against the threshold.

This event should cause a latching event, and should not be recoverable until power is cycled. The **ATSAMD21** will play a special audio (if available) once to indicate low battery. If an audio is playing at the time the low battery command is received, the special audio will be retained and played after the previous one has finished. This event does not affect the playback of other audios, which must be stopped if explicitly required by the **ATmega32U4**.

## Debugging and LED status indication

The different LEDs located on the different boards of each robot have a meaning that can help to understand the current behavior of the robot, as well as to detect possible failures and their cause.

| LED                                 | Lighting mode                 | Current status                               | Notes                                                                                               |
|-------------------------------------|-------------------------------|----------------------------------------------|-----------------------------------------------------------------------------------------------------|
| Green LED on main board             | 1Hz blinking                  | Waiting for identifier of **ATSAMD21**       |                                                                                                     |
| Yellow LED on main board            | Fixed                         | Motion after obstacle detection or timeout   |                                                                                                     |
| Red LED on main board               | 2Hz blinking                  | Low battery                                  |                                                                                                     |
| Red LED on Audio Expansion board    | Fixed                         | Battery charging                             | With USB connected to Audio Expansion                                                               |
| Red LED on Audio Expansion board    | Off                           | Battery charged                              | With USB connected to Audio Expansion                                                               |
| Orange LED on Audio Expansion board | 31Hz blinking                 | SD card not found                            | No SD card                                                                                          |
| Orange LED on Audio Expansion board | 31Hz blinking                 | Audio files not found or not valid           | With SD card                                                                                        |
| Orange LED on Audio Expansion board | Fixed                         | Playing audio                                |                                                                                                     |
| RGB LED on Audio Expansion board    | Fixed any color               | Identifying color assigned to the robot      | Right at startup                                                                                    |
| RGB LED on Audio Expansion board    | 15Hz white blinking           | Awaiting communication with **ATSAMD21**     | In start-up sequence                                                                                |
| RGB LED on Audio Expansion board    | Fixed pure green              | Successful communication with **ATSAMD21**   | In start-up sequence after white blinking, duration 500ms                                           |
| RGB LED on Audio Expansion board    | Fixed pure red                | Unsuccessful communication with **ATSAMD21** | In start-up sequence after white blinking, duration 500ms                                           |
| RGB LED on Audio Expansion board    | 8Hz robot identifier blinking | Pause mode                                   | After the start-up sequence                                                                         |
| RGB LED on Audio Expansion board    | Fixed robot identifier        | Active mode                                  | After the start-up sequence, duration 5s                                                            |
| RGB LED on Audio Expansion board    | Off                           | Active mode                                  | After the start-up sequence, after being fixed for 5s                                               |
| RGB LED on Audio Expansion board    | Fixed any color               | Identification color selection               | After the start-up sequence, moving the identifier selection potentiometer or up to 3 seconds later |

## Summary of uplink/downlink commands

| Source         | Destination        | Command   | Description                   |
|----------------|----------------|-----------|-----------------------------------|
| **ATSAMD21**   | **ATmega32U4** | `#`       | Initial check error               |
| **ATSAMD21**   | **ATmega32U4** | `%`       | Initial check ok                  |
| **ATmega32U4** | **ATSAMD21**   | `@`       | Identifier request                |
| **ATSAMD21**   | **ATmega32U4** | `@`       | Answer: Unknown identifier        |
| **ATSAMD21**   | **ATmega32U4** | `A` - `~` | Answer: Identifier number         |
| **ATSAMD21**   | **ATmega32U4** | `$`       | Set pause mode                    |
| **ATSAMD21**   | **ATmega32U4** | `&`       | Set active mode                   |
| **ATmega32U4** | **ATSAMD21**   | `>`       | Start of path audio playback      |
| **ATmega32U4** | **ATSAMD21**   | `=`       | Stop audio path playback          |
| **ATmega32U4** | **ATSAMD21**   | `!`       | Start of collision audio playback |
| **ATmega32U4** | **ATSAMD21**   | `-`       | Low battery indicator             |

