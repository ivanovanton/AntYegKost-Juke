#!/bin/bash

# включить отладку
DEBUG=0

FILENAME=$1
PS3='Введите номер пукнта меню (q - выход): '

OPTIONS=(
    "Изменить владельца файла"
    "Изменить группу файла"
)

FUNCTIONS=(
    change_user
    change_group
)

change_user()
{
    PS3='Выберите пользователя из списка: '
    select user in $(getent passwd | cut -d: -f1); do
	if [[ $REPLY == "q" ]]; then
            exit 1
    	fi 
        if [[ -z $user ]]; then
            echo "Неверный выбор" >&2
            continue
        fi
        echo "Вы выбрали пользователя '$user'."
	if [[ -z $RECURSION ]]; then
		chown $user $FILENAME
	else
		chown $2 $user $FILENAME
	fi
	echo "Владельцом файла '$FILENAME'  является '$user'."
        break
    done
}


change_group()
{
    PS3='Выберите группу из списка: '
    select group in $(cat /etc/group| cut -d: -f1); do
	if [[ $REPLY == "q" ]]; then
            exit 1
    	fi 
	if [[ -z $group ]]; then
    		echo "Неверный выбор" >&2
    		continue
        fi
        echo "Вы выбрали пользователя '$user'."	
	if [[ -z $2 ]]; then
		chown :$group $FILENAME
	else
		chown $2 :$group $FILENAME
	fi
	echo "Группой файла '$FILENAME'  является '$group'."
        break
    done
}

			  
select opt in "${OPTIONS[@]}"; do
    if [[ $DEBUG == 1 ]]; then
        echo "opt=$opt"
        echo "REPLY=$REPLY" 
    fi
    case $REPLY in
        [1-${#OPTIONS[*]}])

            FUNC=${FUNCTIONS[$((REPLY-1))]}
            echo "Запускаю функцию $FUNC"
            $FUNC
            break
            ;;
        q) break;;
        *) echo "Неверный пункт меню" >&2;;
    esac
done
