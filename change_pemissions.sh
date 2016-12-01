#!/bin/bash 

DEBUG=1

PS3='Выберите, для кого изменить права доступа (q - выход): '
# Перечень пунктов меню
TARGET_OPTIONS=(
    "для владельца"
    "для группы"
    "для остальных"
    "для всех"
)

TARGETS=(
	"u"
	"g"
	"o"
	"a"
)

select opt in "${TARGET_OPTIONS[@]}"; do
    if [[ $DEBUG == 1 ]]; then
        echo "filename=$filename"
        echo "opt=$opt" 
        echo "REPLY=$REPLY"
    fi
    case $REPLY in 
		[1-${#TARGET_OPTIONS[*]}])
	    	CHMOD_PARAM=${TARGETS[$((REPLY-1))]}
			if [[ $DEBUG == 1 ]]; then       
				echo "Выбрано: $CHMOD_PARAM"
			fi
            break
            ;;
        q) break;;
        *) echo "Неверный пункт меню" >&2;;
    esac
done

PS3='Выберите действие, которое нужно совершить? (q - выход): '
ACTION_OPTIONS=(
	"Добавить право записи"
	"Убрать право записи"
	"Добавить право чтения"
	"Удалить право чтения"
	"Добавить право исполнения"
	"Удалить право исполнения"
	"Добавить бит SUID/SGID"
	"Удалить бит SUID/SGID"
)
ACTIONS=(
	"+w"
	"-w"
	"+r"
	"-r"
	"+x"
	"-x"
	"+s"
	"-s"
)

select opt in "${ACTION_OPTIONS[@]}"; do
    if [[ $DEBUG == 1 ]]; then
        echo "opt=$opt" 
        echo "REPLY=$REPLY"
    fi
    case $REPLY in 
		[1-${#ACTION_OPTIONS[*]}])
            CHMOD_PARAM="${CHMOD_PARAM}${ACTIONS[$((REPLY-1))]}"
	    	if [[ $DEBUG == 1 ]]; then       
				echo "Выбрано: $CHMOD_PARAM"
			fi
            break
            ;;
        q) break;;
        *) echo "Неверный пункт меню" >&2;;
    esac
done

chmod "$CHMOD_PARAM" "$1"
if [[ $DEBUG == 1 ]]; then       
	ls -l "$1"
fi
