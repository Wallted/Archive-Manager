#!/bin/bash
#Author: Grzegorz Choiński
#Created On: 07.06.2017
#Version: 0.1
#Description:
#Pakowanie i rozpakowywanie plików w dialogu.
#Skrypt jest napisany z pomocą dialogu - konsolowych okien informacyjnych. Użytkownik może wprowadzić pliki/katalogi do spakowania/rozpakowania. Do #wyboru jest kilka rodzajów archiwów, m.in. tar, zip, 7-zip, gzip, bzip2.

. pakowanie.sh
. rozpakowywanie.sh
. stale.rc
dialog --msgbox "Witaj w skrypcie obslugujacym archiwa." 8 30
while [ ${OPCJA} -ne 3 ]; do
	OPCJA=$( dialog --backtitle "" --cancel-button "Wyjdz" --ok-button "Wybierz" --radiolist "Wybierz opcje: " 10 40 5 "${LIST[@]}" 3>&1 1>&2 2>&3)
	if [ $? -eq 1 ]; then
		break
	elif [ -z "$OPCJA" ]; then
		dialog --msgbox "UZYJ SPACJI, ABY WYBRAC OPCJE" 0 0
		OPCJA=-1
	elif [ $OPCJA -eq 1 ]; then
		pakowanie 1
	elif [ $OPCJA -eq 2 ]; then
		rozpakuj
	fi
done
dialog --msgbox "Do widzenia!" 8 30


