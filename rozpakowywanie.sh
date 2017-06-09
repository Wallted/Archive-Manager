#!/bin/bash

rozpakuj() {
	PLIK=$(dialog --stdout --ok-button "WYBIERZ" --cancel-button "WSTECZ" --fselect $PLIK 0 0 0) #SPRAWDENIE CZY JEST TO ARCHWIWUM
	echo $PLIK > to_ex.$$
	EXT=$(echo $PLIK | cut -d "." -f 2)
	FOLDER=$(cat to_ex.$$ | rev | cut -d "/" -f 1 | rev | cut -d "." -f 1) 
	KATALOG=$(dialog --stdout --ok-button "ROZPAKUJ" --cancel-button "WSTECZ" --title "Wybierz folder do rozpakowanie: " --dselect $KATALOG 0 0)
	if [ $EXT = "tar" ]; then
		mkdir $KATALOG/$FOLDER #SPRAWDZANIE CZY FOLDER ISTNIEJE
		tar -xvf $PLIK -C $KATALOG/$FOLDER
	elif [ $EXT = "zip" ]; then
		unzip $PLIK -d $KATALOG/$FOLDER
	elif [ $EXT = "7z" ]; then
		7z x $PLIK $KATALOG/$FOLDER
	fi
	rm to_ex.$$
}
