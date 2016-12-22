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

PS3='Выберите пользователя или группу из списка (q - выход): '
    select USER in $(getent passwd | cut -d: -f1); do
        if [[ $REPLY == "q" ]]; then
            exit 1
        fi
        if [[ -z $USER ]]; then
            echo "Неверный выбор" >&2
            continue
        fi
        echo "Вы выбрали '$USER'"
        break
    done

HELP="Сценарий добавления записи в ACL правах файла"

PS3='Выберите права доступа, которые необходимо установить для данного пользователя или группы (q - выход, help - справка): '
ACTION_OPTIONS=(
	"Добавить право чтения"
	"Добавить право записи"
	"Добавить право выполнения"
	"Добавить право чтения и записи"
	"Добавить право чтения и выполнения"
	"Добавить право записи и выполнения"
	"Добавить право чтения, записи и выполнения"
)
ACTIONS=(
	"r"
	"w"
	"x"
	"rw"
	"rx"
	"wx"
	"rwx"
)

select opt in "${ACTION_OPTIONS[@]}"; do
    if [[ $DEBUG == 1 ]]; then
	echo "opt=$opt" 
	echo "REPLY=$REPLY"
    fi
    case $REPLY in 
		[1-${#ACTION_OPTIONS[*]}])
	    PERMISSION="${PERMISSION}${ACTIONS[$((REPLY-1))]}"
	    	if [[ $DEBUG == 1 ]]; then       
				echo "Выбрано: $PERMISSION"
			fi
	    break
	    ;;
	q) exit 1;;
	"help") echo "$HELP"
		 ;;
	*) echo "Неверный пункт меню" >&2;;
    esac
done

if [[ -z $2 ]]; then
setfacl -m "$PARAM":"$USER":"$PERMISSION" "$1"
else
setfacl "$2" -m "$PARAM":"$USER":"$PERMISSION" "$1"
fi	
#Добавляем для пользователя или группы те или иные права доступа
getfacl "$1"
