#!/bin/bash
echo "This script will flash your Arduino to serial (normal) mode so that sketches can be uploaded to it."
# checks to see if dfu-programmer is installed. If it is not it prompts the user to install it
nullIfNoDFU=$(type -p dfu-programmer)
if [ -z "$nullIfNoDFU" ]
then
    printf "\nRequired program dfu-programmer is not installed. Please install it from your distro's package manager and try again. \nex. \"sudo apt install dfu-programmer\" \n"
    echo "program exiting..."
    exit 1
fi
echo "Put your Arduino into DFU mode by shorting the two pins nearest to the reset button (they will be on the 6-pin header nearest to the reset button)."
read -n 1 -s -r -p "Press any key to continue and reflash once pin shorted"
printf "\nErasing ATMega16U2 flash using dfu-programmer...\n"
dfu-programmer atmega16u2 erase --force
printf "Flashing Arduino-keyboard-0.3.hex using dfu-programmer...\n"
dfu-programmer atmega16u2 flash Arduino-usbserial-uno.hex
printf "Resetting ATMega16U2 using dfu-programmer...\n"
dfu-programmer atmega16u2 reset
printf "Unplug and reconnect Arduino USB cable.\n"
read -n 1 -s -r -p "Press any key to continue once Arduino reconnected"
printf "\nYour Arduino should now be in serial (normal) mode and be able to be detected and programmed."
# check if arduino-cli is installed and procede accordingly
nullIfNoArduinoCLI=$(type -p arduino-cli)
if [ -z "$nullIfNoArduinoCLI" ]
then
    printf "\nRequired program arduino-cli is not installed. Please run the following command to install it: \"sudo curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=~/bin sh\" \n"
    echo "program exiting..."
    exit 1
fi
printf "\nDetected arduinos listed below:\n"
# TODO check to see what arduinos are detected
# arduinoListOutput=$(arduino-cli board list)
#echo $arduinoListOutput
arduino-cli board list