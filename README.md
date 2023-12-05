# digital-clock

This project is a simple digital clock made with an Atmega16A microcontroller and assembly language. It shows time from 00:00 to 59:59 on four seven-segment displays. The clock uses multiplexing, a technique where the displays are turned on and off very quickly by a timer that sends out signals at two speeds: one signal at 1 hz (every second) to change the time, and another signal at 1 khz (1000 times a second) to manage which display is on. The signals sent at these frequencies trigger interrupts in the microcontroller. These interrupts act like signals that tell it when to update the time or switch between the displays. This feature ensures the clock remains accurate and the display stays easy to read.

This project was an assignment in the course TSIU02 at Linköping University.

### Setup
![IMG_6158](https://github.com/alexandengstrom/digital-clock/assets/123507241/d6ff5f02-0d0a-4442-a780-2effde557225)
