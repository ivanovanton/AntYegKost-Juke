#!/bin/bash

# включить отладку
DEBUG=0

FILENAME=$1
PS3='Введите номер пукнта меню (q - выход): '
# Перечень пунктов меню
OPTIONS=(
    "Изменить владельца файла"
    "Изменить группу файла"
)
# Перечень функций, которые отвечают за реализацию каждого пункта меню
FUNCTIONS=(
    change_user
    change_group
)

change_user()
{
    PS3='Выберите пользователя из списка (q - выход): '
    select user in $(getent passwd | cut -d: -f1); do
		if [[ $user -eq "q" ]]; then
			break
		fi
        if [[ -z $user ]]; then
            echo "Неверный выбор" >&2
            continue
        fi
        echo "Вы выбрали пользователя '$user'."
		chown $user $FILENAME
		echo "Владельцом файла '$FILENAME'  является '$user'."
        break
    done
}

change_group()
{
    PS3='Выберите группу из списка (q - выход): '
    select group in $(cat /etc/group| cut -d: -f1); do
		if [[ $user -eq "q" ]]; then
			break
		fi
		if [[ -z $group ]]; then
            echo "Неверный выбор" >&2
            continue
        fi
        echo "Вы выбрали пользователя '$user'."
		chown :$group $FILENAME
		echo "Группой файла '$FILENAME'  является '$group'."
        break
    done
}

			  
select opt in "${OPTIONS[@]}"; do
    if [[ $DEBUG == 1 ]]; then
        echo "opt=$opt" # opt содержит имя пункта меню, полезно для выбора пользователей или других объектов
        echo "REPLY=$REPLY" # REPLY содержит ответ пользователя
    fi
    case $REPLY in
        [1-${#OPTIONS[*]}])
            # с помощью данного хитрого способа можно автоматически перейти в нужную реализацию
            FUNC=${FUNCTIONS[$((REPLY-1))]}
            echo "Запускаю функцию $FUNC"
            $FUNC || echo "Ошибка! Нужно реализовать функцию $FUNC" >&2
            break
            ;;
        q) break;;
        *) echo "Неверный пункт меню" >&2;;
    esac
done
