#!/bin/bash 

DEBUG=0

PS3='Выберите, для кого добавить запись в ACL правах файла (q - выход): '
# Перечень пунктов меню
TARGET_OPTIONS=(
    "для пользователя"
    "для группы"
)

TARGETS=(
    "u"
    "g"
)

select opt in "${TARGET_OPTIONS[@]}"; do
    #отладочная информация
    if [[ $DEBUG == 1 ]]; then
        echo "filename=$1"
        echo "opt=$opt" 
        echo "REPLY=$REPLY"
    fi
    #выход
    if [[ $REPLY == "q" ]]; then
        exit 1
    fi
    case $REPLY in 
		[1-${#TARGET_OPTIONS[*]}])
	    	PARAM=${TARGETS[$((REPLY-1))]}
			if [[ $DEBUG == 1 ]]; then       
				echo "Выбрано: $PARAM"
			fi
            break
            ;;
        q) break;;
        *) echo "Неверный пункт меню" >&2;;
    esac
done

while :
do
    if [[ $REPLY == 1 ]]; then
	    echo "Введите имя пользователя:"
        else
            echo "Введите имя группы:"
        fi

    read NAME

    grep "$NAME:" /etc/passwd >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Введите корректное имя"
    else
	break
    fi
done

while :
do
    echo "Введите права доступа:"
    read PERMISSION
    if [[ $PERMISSION != "r" && $PERMISSION != "w" && $PERMISSION != "x" && $PERMISSION != "rw" && $PERMISSION != "rx" && $PERMISSION != "wx" && $PERMISSION != "rwx" ]]; then
	echo "Введите корректные права"
    else 
	break
    fi
done
	
#Добавляем для пользователя или группы те или иные права доступа
setfacl -m "$PARAM":"$NAME":"$PERMISSION" "$1"
getfacl "$1"
