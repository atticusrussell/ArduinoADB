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
            ./flashSerial.sh
            # TODO rebuild and upload the sketch here
            printf "\n#TODO here is where I would build and upload the Arduino sketch \n"
            flash_ATM16U2_KB
            loop=0
            ;;
        *)
            echo "Invalid input. Try again."
            ;;
    esac
done