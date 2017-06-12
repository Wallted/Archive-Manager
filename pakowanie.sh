#!/bin/bash
LISTAROZSZ=(1 ".tar" on, 2 ".zip" on, 3 ".7z" off)
EXT=("" "tar" "zip" "7z")
PLIK=$(pwd)
KATALOG=$(pwd)
getPlik(){
	PLIK=$(dialog --stdout --ok-button "DODAJ" --cancel-button "UTWORZ" --fselect $PLIK 0 0 0)	
	EXIT=$?
	if [[ -z $PLIK ]]; then
		PLIK=$(pwd)
	fi
}
getNazwa(){
	NAZWA=$(dialog --stdout --ok-button "DALEJ" --cancel-button "WSTECZ" --inputbox "Wprowadz nazwe archiwum" 0 0)
	EXIT=$?	
	if [[ -z $NAZWA ]]; then
		NAZWA='NO-NAME'
	fi
}
getKatalog(){
	KATALOG=$(dialog --stdout --ok-button "DALEJ" --cancel-button "WSTECZ" --title "Wybierz folder dla archiwum: " --dselect $KATALOG 0 0)
	EXIT=$?
	if [[ -z $KATALOG ]]; then
		KATALOG=$(pwd)
	fi
}
getRozszerzenie(){
	ROZSZERZENIE=$( dialog --ok-button "DALEJ" --cancel-button "WSTECZ" --radiolist "Wybierz rozszerzenie:" 0 0 0 "${LISTAROZSZ[@]}" 3>&1 1>&2 			2>&3)
	EXIT=$?
	if [[ -z $ROZSZERZENIE ]]; then
		if [ $EXIT -eq 0 ]; then
			getRozszerzenie
		fi
	fi
}
utworz(){
	cat /tmp/files.$$ | rev | sed "s#//#/#" | awk 'BEGIN { FS="/"; OFS="/" } ; {$2=$2" " }; {print}' | rev | uniq > /tmp/files_to.$$
	if [ $ROZSZERZENIE -eq 1 ]; then		
		readarray FILES < /tmp/files_to.$$
		tar -cvf $KATALOG/$NAZWA.tar ${FILES[@]} 
	elif [ $ROZSZERZENIE -eq 2 ]; then
		cat /tmp/files_to.$$ | cut -d " " -f 2 > /tmp/file_dirs.$$
		cat /tmp/files_to.$$ | cut -d " " -f 3 | sed "s#/##"> /tmp/files.$$
		readarray FILES < /tmp/files.$$
		readarray DIRS < /tmp/file_dirs.$$
		CNT=0
		for file in ${FILES[@]}; do
			pushd ${DIRS[$CNT]}
			zip -r $KATALOG/$NAZWA $file
			popd
		((CNT++))
		done
	else	
		cat /tmp/files_to.$$ | cut -d " " -f 2 > /tmp/file_dirs.$$
		cat /tmp/files_to.$$ | cut -d " " -f 3 | sed "s#/##"> /tmp/files.$$
		readarray FILES < /tmp/files.$$
		readarray DIRS < /tmp/file_dirs.$$
		CNT=0
		for file in ${FILES[@]}; do	
			FILE=$( echo ${DIRS[$CNT]}$file | sed "s# ##" )
			7z a $KATALOG/$NAZWA.7z $FILE
		((CNT++))
		done
	fi
	rm /tmp/files_to.$$
	rm /tmp/files.$$
	rm /tmp/file_dirs.$$
	WYNIK=$(find $KATALOG -name $NAZWA.${EXT[$ROZSZERZENIE]})
	if [[ -n $WYNIK ]]; then
		dialog --msgbox "Archiwum utworzono pomyślnie!" 0 0 
	else
		dialog --msgbox "Blad, cos poszlo nie tak!" 0 0
	fi
}
pakowanie(){
	EXIT=0
	while [ $EXIT -eq 0 ]; do
		getRozszerzenie
		if [ $EXIT -eq 0 ]; then
			while [ $EXIT -eq 0 ]; do
				getKatalog
				if [ $EXIT -eq 0 ]; then
					while [ $EXIT -eq 0 ]; do
						getNazwa
						if [ $EXIT -eq 1 ]; then
							break
						fi
						if [[ -n $(find $KATALOG  -name $NAZWA.${EXT[$ROZSZERZENIE]}) ]]; then
							dialog --yes-button "TAK" --no-button "NIE" --yesno "Tutaj istnieje juz takie archiwum. Czy 									chcesz je nadpisac?" 0 0
							EXIT=$?
							if [ $EXIT -eq 0 ]; then
								rm $KATALOG/$NAZWA.${EXT[$ROZSZERZENIE]}
							fi
						fi	
						if [ $EXIT -eq 0 ]; then
							> /tmp/files.$$
							while [ $EXIT -ne 1 ]; do
								getPlik
								if [ $EXIT -eq 1 ]; then
									utworz
									return
								elif [ $EXIT -eq 255 ]; then
									break
								else
									echo -C $PLIK/ >> /tmp/files.$$
								fi
							done
							rm /tmp/files.$$
						fi
					done
					EXIT=0
				fi
			done
			EXIT=0
		fi
	done
}
