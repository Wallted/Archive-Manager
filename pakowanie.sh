#!/bin/bash
LISTAROZSZ=(1 ".tar" on, 2 ".zip" on, 3 ".7z" off)

getPlik(){
	PLIK=$(dialog --stdout --ok-button "DODAJ" --cancel-button "UTWORZ" --fselect $HOME/ 14 48)	
}
getNazwa(){
	NAZWA=$(dialog --stdout --ok-button "DALEJ" --cancel-button "WSTECZ" --inputbox "Wprowadz nazwe archiwum" 0 0)
}
getKatalog(){
	KATALOG=$(dialog --stdout --ok-button "DALEJ" --cancel-button "WSTECZ" --title "Wybierz folder dla archiwum: " --dselect $HOME/Desktop 14 48)
}
getRozszerzenie(){
	ROZSZERZENIE=$( dialog --backtitle ""  --ok-button "DALEJ" --cancel-button "WSTECZ" --radiolist "Wybierz rozszerzenie:" 10 30 5 "${LISTAROZSZ[@]}" 3>&1 1>&2 2>&3)
}
utworz(){
	>files_to.$$
	cat files.$$ | rev | sed "s#//#/#" | awk 'BEGIN { FS="/"; OFS="/" } ; {$2=$2" " }; {print}' | rev > files_to.$$
	#files_to.$$
	#cat files_to.$$ > FILE
	readarray a < files.$$
	echo ${a[@]} > d.txt
	tar -cvf $KATALOG/$NAZWA.tar -C ${a[@]}

	dialog --msgbox "Archiwum utworzono pomyślnie!" 0 0 
	rm files_to.$$
rm files.$$
}
pakowanie(){
	#musisz ogarnac co jak nie wybierze nic
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
								#echo $PLIK/ >> files.$$
								if [ $EXIT -eq 1 ]; then
									utworz
									return
								else
									echo $PLIK/ >> files.$$
								fi
							done
						fi
					done
					EXIT=0
				fi
			done
			EXIT=0
		fi
	done
}
