#!/bin/bash

DEBUG=1
PS3="Главное меню (q- выход, help - справка): "
OPTIONS=(
	"Работа с файлом/папкой" 
	"Поиск файлов, доступных всем пользователям на запись"
)
FUNCTIONS=(
	first_case
	second_case
)

HELP="Справка:..."

first_case(){
	if [ -z "$1" ]	
	then
		echo "Введите имя файла или папки:"
		read FILENAME
	else
		FILENAME=$1
	fi
	if [[ $DEBUG = 1 ]]
	then
		echo "Имя файла: $FILENAME"
	fi
	if [[ -a $FILENAME ]]
	
	then
		if [[ -d $FILENAME ]]
			then
				echo "Введите y, если хотите применить операцию рекурсивно к выбранной папке"
				read CHOICE 
				if [[ $CHOICE = "y" ]]
				then 
					PARAM="-R"
				fi
				if [[ $DEBUG = 1 ]]; then
					echo "choice=$CHOICE"
					echo "param=$PARAM"
				fi
		fi
	else
		echo "Файл не существует" >&2
		return 0;
	fi

	PS3="Выберите нужный пункт меню (q- выход, help - справка): "
	OPTIONS1=(
	"Изменение прав доступа" 
	"Изменение владельца и группы файла" 
	"Добавить запись ACL"
	"Изменить запись ACL"
	"Удалить запись ACL"	
	)
	EXIT_STATUS=0
	while (( !EXIT_STATUS )); do
		echo ""
		select opt in "${OPTIONS1[@]}"
		do
			case $REPLY in
				"1")
					./change_permissions.sh "$FILENAME" "$PARAM"
					break
					;;
				"2")
					./change_user_and_group.sh "$FILENAME" "$PARAM"
					break
					;;
				"3")	./add_record.sh "$FILENAME" "$PARAM"
					break
					;;
				"4") 	./delete_record.sh "$FILENAME" "$PARAM"
					break
					;;
				"5")	./change_record.sh "$FILENAME" "$PARAM"
					break
					;;				
				"q")
					return 0;
					break
					;;
				"help")
					echo "$HELP"
					break
					;;
				*) echo "Неверно выбран пункт меню" >&2
					break
					;;
			esac
		done
	done
}

second_case(){
	./2.sh
}

select opt in "${OPTIONS[@]}"; do
	    if [[ $DEBUG == 1 ]]; then
		echo "filename=$1"
		echo "opt=$opt" 
		echo "REPLY=$REPLY"
	    fi
	    case $REPLY in 
		    [1-${#OPTIONS[*]}])
		    FUNC=${FUNCTIONS[$((REPLY-1))]}
		    if [[ $DEBUG == 1 ]]; then
		    	echo "Запускаем $FUNC"
		    fi
                    $FUNC "$1"
		    break
		    ;;
		q) exit 0;;
		"help") echo "$HELP"
			break
			;;
		*) echo "Неверный пункт меню" >&2;;
	    esac
	done
		
