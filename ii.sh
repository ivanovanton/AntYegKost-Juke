#! /bin/bash
find / -type f -perm -a+w 2>/dev/null | less
