#!/bin/bash
echo "This script will flash your Arduino to serial (normal) mode so that sketches can be uploaded to it."
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
printf "\nYour Arduino should now be in serial (normal) mode and be able to be reprogrammed."