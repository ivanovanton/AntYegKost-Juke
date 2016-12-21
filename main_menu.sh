#!/bin/bash

DEBUG=1
echo "Сценарий управления безопасностью файлов и каталогов. Авторы: Иванов Антон, Василенко Егор, Максимов Константин, Богомолов Илья, Степанов Виктор, Малышев Алексей"

if [[ $1 = "--help" ]]; then
	exit 0;
fi

if [[ "$(id -u)" != "0" ]]; then
	echo "Для запуска приложения нужны root права">&2
	exit 1
fi

PS3="Главное меню (q- выход, help - справка): "
OPTIONS=(
	"Работа с файлом/папкой" 
	"Поиск файлов, доступных всем пользователям на запись"
)
FUNCTIONS=(
	first_case
	second_case
)


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
	"Удалить запись ACL"
	"Изменить запись ACL"	
	)
	EXIT_STATUS=0
	while (( !EXIT_STATUS )); do
		echo ""
		select opt in "${OPTIONS1[@]}"
		do
			case $REPLY in
				"1")    ./change_permissions.sh "$FILENAME" "$PARAM"
					break
					;;
				"2")	./change_user_and_group.sh "$FILENAME" "$PARAM"
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
					echo "Выберите, какую операцию нужно совершить для выбранного файла/каталога"	
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
	./ii.sh
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
	"help") echo "1) Работа с файлом/папкой
2) Поиск файлов, доступных всем пользователям на запись"
		;;
	*) echo "Неверный пункт меню" >&2;;
	esac
	done
		
