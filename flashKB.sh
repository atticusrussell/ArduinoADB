#!/bin/bash
#function to interactively flash the keyboard firmware
flash_ATM16U2_KB(){
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
    printf "\nYour connected keyboard should now work. If you want to reset your Arduino to normal mode in order to reprogram it, run \"./flashSerial.sh\" from the command line"
}


echo "This script is to re-flash your Arduino's ATMega16U2 to act as a USB converter for the ADB protocol."
# checks to see if dfu-programmer is installed. If it is not it prompts the user to install it
nullIfNoDFU=$(type -p dfu-programmer)
if [ -z "$nullIfNoDFU" ]
then
    printf "\nRequired program dfu-programmer is not installed. Please install it from your distro's package manager and try again. \nex. \"sudo apt install dfu-programmer\" \n"
    echo "program exiting..."
    exit 1
else
    echo "dfu-programmer is installed, proceeding normally"
fi

loop=1
while (($loop==1))
do
    echo "Pick an option and press the corresponding key:"
    echo "  'q' - cancel and quit."
    echo "  'f' - just flash the keyboard firmware."
    echo "  'r' - re-build and re-upload the adb_to_usb sketch and then flash the keyboard firmware."
    #read in the first character pressed to the variable $CHOICE and supress output
    read -n1 -s CHOICE
    echo "$CHOICE"

    case $CHOICE in
        q)
            echo "quitting"
            exit 1
            ;;
        f)
            flash_ATM16U2_KB
            loop=0
            ;;
        r)
            # check if arduino-cli is installed and procede accordingly
            nullIfNoArduinoCLI=$(type -p arduino-cli)
            if [ -z "$nullIfNoArduinoCLI" ]
            then
                printf "\nRequired program arduino-cli is not installed. Please run the following command to install it: \"sudo curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=~/bin sh\" \n"
                echo "program exiting..."
                exit 1
            else
                echo "arduino-cli is installed, proceeding normally"
            fi
            # runs flashSerial to set the AVR16U2 in serial mode so that it can be programmed
            ./flashSerial.sh
            

            # TODO rebuild and upload the sketch here
            printf "\n\nPLACEHOLDER Arduino-CLI part under development\n"
          

            # TODO check if the sketch name directory exists and if it doesn't move files accordingly
            DIR="adb_to_usb" 
            if [-d "$DIR"]
            then

            fi 
            # TODO use the arduino CLI to build and stuff

            printf "\nEND PLACEHOLDER\n\n"
            flash_ATM16U2_KB
            loop=0
            ;;
        *)
            echo "Invalid input. Try again."
            ;;
    esac
done