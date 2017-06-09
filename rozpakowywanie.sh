#!/bin/bash

rozpakuj() {
	PLIK=$(dialog --stdout --ok-button "WYBIERZ" --cancel-button "WSTECZ" --fselect $PLIK 0 0 0) #SPRAWDENIE CZY JEST TO ARCHWIWUM
	echo $PLIK > to_ex.$$
	FOLDER=$(cat to_ex.$$ | rev | cut -d "/" -f 1 | rev | cut -d "." -f 1) 
	KATALOG=$(dialog --stdout --ok-button "ROZPAKUJ" --cancel-button "WSTECZ" --title "Wybierz folder do rozpakowanie: " --dselect $KATALOG 0 0)
	mkdir $KATALOG/$FOLDER #SPRAWDZANIE CZY FOLDER ISTNIEJE
	tar -xvf $PLIK -C $KATALOG/$FOLDER
	rm to_ex.$$
}
