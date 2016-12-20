#!/bin/bash 

DEBUG=1
PS3='Выберите, для кого изменить права доступа (q - выход, help - ): '
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

HELP="Сценарий изменения прав доступа"

change_permissions() {
	select opt in "${TARGET_OPTIONS[@]}"; do
	    if [[ $DEBUG == 1 ]]; then
		echo "filename=$1"
		echo "opt=$opt" 
		echo "REPLY=$REPLY"
		echo "parameter=$2"
	    fi
	    case $REPLY in 
			[1-${#TARGET_OPTIONS[*]}])
		    	CHMOD_PARAM=${TARGETS[$((REPLY-1))]}
				if [[ $DEBUG == 1 ]]; then       
					echo "Выбрано: $CHMOD_PARAM"
				fi
		    break
		    ;;
		"help") echo "$HELP" ;;
		q) return 0;;
		*) echo "Неверный пункт меню" >&2;;
	    esac
	done

	PS3='Выберите действие, которое нужно совершить? (q - выход, help - справка): '
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
		q) return 0;;
		"help") echo "$HELP"
			 ;;
		*) echo "Неверный пункт меню" >&2;;
	    esac
	done
	
	if [[ -z $2 ]]; then
		chmod "$CHMOD_PARAM" "$1"
	else
		chmod "$2" "$CHMOD_PARAM" "$1"
	fi
}

change_permissions "$1" "$2"
