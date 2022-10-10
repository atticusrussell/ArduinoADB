#!/bin/bash
# TODO ADD stuff to build arduino file and upload it

echo "Put your Arduino into DFU mode by shorting the two pins nearest to the reset button (they will be on the 6-pin header nearest to the reset button)."
read -n 1 -s -r -p "Press any key to continue and reflash once pin shorted"
printf "\nErasing ATMega16U2 flash using dfu-programmer...\n"
dfu-programmer atmega16u2 erase --force
printf "Flashing Arduino-keyboard-0.3.hex using dfu-programmer...\n"
dfu-programmer atmega16u2 flash Arduino-keyboard-0.3.hex
printf "Resetting ATMega16U2 using dfu-programmer...\n"
dfu-programmer atmega16u2 reset
printf "Unplug and reconnect Arduino USB cable.\n"
read -n 1 -s -r -p "Press any key to continue once Arduino reconnected"
printf "\nYour connected keyboard should now work. If you want to reset your Arduino to normal mode in order to reprogram it, run flashSerial.sh"