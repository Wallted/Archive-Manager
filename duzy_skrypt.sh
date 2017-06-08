#!/bin/bash
#Author: Grzegorz Choiński
#Created On: 07.06.2017
#Version: 0.1
#Description:
#Pakowanie i rozpakowywanie plików w dialogu.
#Skrypt jest napisany z pomocą dialogu - konsolowych okien informacyjnych. Użytkownik może wprowadzić pliki/katalogi do spakowania/rozpakowania. Do #wyboru jest kilka rodzajów archiwów, m.in. tar, zip, 7-zip, gzip, bzip2.
. pakowanie.sh
. rozpakowywanie.sh
dialog --msgbox "Witaj w skrypcie obslugujacym archiwa." 8 30
OPCJA=1
LIST=(1 "Pakowanie plików" ON, 2 "Rozpakowywanie archiwum" OFF, 3 "Wyjscie" OFF )
while [ ${OPCJA} -ne 3 ]; do
	OPCJA=$( dialog --backtitle "" --radiolist "Wybierz opcje: <SPACE>" 10 40 5 "${LIST[@]}" 3>&1 1>&2 2>&3)
	if [ $? -eq 1 ]; then
		break
	elif [ -z "$OPCJA" ]; then
		OPCJA=4
	elif [ $OPCJA -eq 1 ]; then
		pakowanie 1
	elif [ $OPCJA -eq 2 ]; then
		rozpakuj
	fi
	#echo $OPCJA >>g.tx
done

dialog --msgbox "Do widzenia!" 8 30


