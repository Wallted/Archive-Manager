#!/bin/bash

rozpakuj() {
	while [ true ]; do
	PLIK=$(dialog --stdout --ok-button "WYBIERZ" --cancel-button "WSTECZ" --fselect $PLIK 0 0 0)
	EXIT=$?
	if [ $EXIT -eq 1 ]; then
		PLIK=$PWD
		return
	fi
	EXT=$(echo $PLIK | cut -d "." -f 2)
	echo $PLIK > to_ex.$$
	FOLDER=$(cat to_ex.$$ | rev | cut -d "/" -f 1 | rev | cut -d "." -f 1) 
	KATALOG=$(dialog --stdout --ok-button "ROZPAKUJ" --cancel-button "WSTECZ" --title "Wybierz folder do rozpakowanie: " --dselect $KATALOG 0 0)
	EXIT=$?
	if [ $EXIT -eq 1 ]; then
		KATALOG=$PWD
		continue
	fi	
	if [ $EXT = "tar" ]; then
		if [[ -n  $(find $KATALOG/$FOLDER) ]]; then
			FOLDER="$FOLDER-kopia_($$)"
		fi
		mkdir $KATALOG/$FOLDER
		tar -xvf $PLIK -C $KATALOG/$FOLDER
	elif [ $EXT = "zip" ]; then
		unzip $PLIK -d $KATALOG/$FOLDER
	elif [ $EXT = "7z" ]; then
		7z x $PLIK $KATALOG/$FOLDER
	else
		dialog --msgbox "TO NIE JEST ARCHIWUM!" 0 0 
		continue
	fi
	rm to_ex.$$
	if [[ -n  $(find $KATALOG/$FOLDER) ]]; then
		dialog --msgbox "ARCHIWUM ROZPAKOWANO POMYSLNIE!" 0 0
	else
		dialog --msgbox "BLAD! COS POSZLO NIE TAK!" 0 0
	fi
	return	
	done
}
