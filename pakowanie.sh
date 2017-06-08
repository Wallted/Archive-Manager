#!/bin/bash
LISTAROZSZ=(1 ".tar" on, 2 ".zip" on, 3 ".7z" off)
KATALOG=$HOME/Desktop
PLIK=$HOME/
getPlik(){
	PLIK=$(dialog --stdout --ok-button "DODAJ" --cancel-button "UTWORZ" --fselect $PLIK 0 0 0)	
}
getNazwa(){
	NAZWA=$(dialog --stdout --ok-button "DALEJ" --cancel-button "WSTECZ" --inputbox "Wprowadz nazwe archiwum" 0 0)
}
getKatalog(){
	KATALOG=$(dialog --stdout --ok-button "DALEJ" --cancel-button "WSTECZ" --title "Wybierz folder dla archiwum: " --dselect $KATALOG 0 0)
}
getRozszerzenie(){
	ROZSZERZENIE=$( dialog --ok-button "DALEJ" --cancel-button "WSTECZ" --radiolist "Wybierz rozszerzenie:" 0 0 0 "${LISTAROZSZ[@]}" 3>&1 1>&2 2>&3)
}
utworz(){
	>files_to.$$
	cat files.$$ | rev | sed "s#//#/#" | awk 'BEGIN { FS="/"; OFS="/" } ; {$2=$2" " }; {print}' | rev | uniq > files_to.$$
	if [ $ROZSZERZENIE -eq 1 ]; then
		
		readarray a < files_to.$$
		#echo ${a[@]} > d.txt
		tar -cvf $KATALOG/$NAZWA.tar ${a[@]} 
	elif [ $ROZSZERZENIE -eq 2 ]; then
		cat files_to.$$ | cut -d " " -f 2 > file_dirs.$$
		cat files_to.$$ | cut -d " " -f 3 | sed "s#/##"> files.$$
		readarray FILES < files.$$
		readarray DIRS < file_dirs.$$
		CNT=0
		for file in ${FILES[@]}; do
			pushd ${DIRS[$CNT]}
			zip -r $KATALOG/$NAZWA $file
			popd
		((CNT++))
		done
	else	
		cat files_to.$$ | cut -d " " -f 2 > file_dirs.$$
		cat files_to.$$ | cut -d " " -f 3 | sed "s#/##"> files.$$
		readarray FILES < files.$$
		readarray DIRS < file_dirs.$$
		CNT=0
		for file in ${FILES[@]}; do	
			FILE=$( echo ${DIRS[$CNT]}$file | sed "s# ##" )
			echo $FILE >>d.txt
			7z a $KATALOG/$NAZWA.7z $FILE
		((CNT++))
		done
	fi
	rm files_to.$$
	rm files.$$
	rm file_dirs.$$
	dialog --msgbox "Archiwum utworzono pomyślnie!" 0 0 
}
pakowanie(){
	#musisz ogarnac co jak nie wybierze nic #esc #podebuguj wstecz
	EXIT=0
	while [ $EXIT -ne 1 ]; do
		getRozszerzenie
		EXIT=$?
		if [ $EXIT -eq 0 ]; then
			while [ $EXIT -ne 1 ]; do
				getKatalog
				EXIT=$?
				if [ $EXIT -eq 0 ]; then
					while [ $EXIT -ne 1 ]; do
						getNazwa
						WYNIK=$(find $KATALOG  -name $NAZWA.tar)
						if [[ -n $WYNIK ]]; then
							dialog --yes-button "TAk" --no-button "NIE" --yesno "Juz istnieje takie archiwum. Czy chcesz je nadpisac?" 0 0
						fi
						EXIT=$?
						if [ $EXIT -eq 0 ]; then
							> files.$$
							while [ $EXIT -ne 1 ]; do
								getPlik
								EXIT=$?
								if [ $EXIT -eq 1 ]; then
									utworz
									return
								else
									echo -C $PLIK/ >> files.$$
								fi
							done
							rm files.$$
						fi
					done
					EXIT=0
				fi
			done
			EXIT=0
		fi
	done
}
