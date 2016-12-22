#!/bin/bash 

DEBUG=0

PS3='Выберите, для кого удалить запись в ACL правах файла (q - выход): '
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

PS3='Выберите пользователя или группу из списка (q - выход): '
    select USER in $(getent passwd | cut -d: -f1); do
        if [[ $REPLY == "q" ]]; then
            exit 1
        fi
        if [[ $(getfacl "$1" | grep ":$USER:" | wc -l) == "0" ]]; then
            echo "У данного пользователя нет acl прав" >&2
            continue
        fi
        echo "Вы выбрали '$USER'"
        break
    done

if [[ -z $2 ]]; then
    setfacl -x "$PARAM":"$USER":"$PERMISSION" "$1"
else
    setfacl "$2" -x "$PARAM":"$USER":"$PERMISSION" "$1"
fi	

getfacl "$1"
