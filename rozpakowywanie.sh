#!/bin/bash
rozpakuj() {
	while [ true ]; do
	PLIK=$(dialog --stdout --ok-button "WYBIERZ" --cancel-button "WSTECZ" --fselect $PLIK 0 0 0)
	EXIT=$?
	if [ $EXIT -ne 0 ]; then
		PLIK=$PWD
		return
	fi
	EXT=$(echo $PLIK | cut -d "." -f 2)
	EXT2=$(echo $PLIK | cut -d "." -f 3)
	FOLDER=$(echo $PLIK | rev | cut -d "/" -f 1 | rev | cut -d "." -f 1) 
	KATALOG=$(dialog --stdout --ok-button "ROZPAKUJ" --cancel-button "WSTECZ" --title "Wybierz folder do rozpakowanie: " --dselect $KATALOG 0 0)
	EXIT=$?
	if [ $EXIT -ne 0 ]; then
		KATALOG=$PWD
		continue
	fi	
	if [[ -n  $(find $KATALOG/$FOLDER) ]]; then
			FOLDER="$FOLDER-kopia"
	fi
	if [ $EXT = "tar" ]; then
		mkdir $KATALOG/$FOLDER
		tar -xf $PLIK -C $KATALOG/$FOLDER
	elif [ $EXT = "zip" ]; then
		unzip $PLIK -d $KATALOG/$FOLDER
	elif [ $EXT = "7z" ]; then
		7z x -y $PLIK -o$KATALOG/$FOLDER
	elif [ $EXT2 = "bz2" ]; then		
		mkdir $KATALOG/$FOLDER
		pushd $KATALOG/$FOLDER 
		cp $PLIK $KATALOG/$FOLDER
		bunzip2 * 
		popd
	elif [ $EXT2 = "gz" ]; then		
		mkdir $KATALOG/$FOLDER
		pushd $KATALOG/$FOLDER 
		cp $PLIK $KATALOG/$FOLDER
		gunzip * 
		popd
	else
		dialog --msgbox "TO NIE JEST ARCHIWUM!" 0 0 
		continue
	fi
	if [[ -n  $(find $KATALOG/$FOLDER) ]]; then
		dialog --msgbox "ARCHIWUM ROZPAKOWANO POMYSLNIE!" 0 0
	else
		dialog --msgbox "BLAD! COS POSZLO NIE TAK!" 0 0
	fi
	return	
	done
}
