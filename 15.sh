#!/bin/bash

arr=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F" "@")
chk=("${arr[@]}")
mov=("h" "j" "k" "l")
buf=""
now=16
pre=0

shuffle() {
    c=0
    while :
    do
        read -p  "shuffle[0-100]:" c
        [ $s -le 100 -a $s -ge 0 ] && echo $c; return
    done
}

check() {
    res=0
    for (( k = 1; k <= 16; k++ )) {
        [ ${arr[k]} != ${chk[k]} ] && res=1
    }
    echo $res
}

help() {
    cat << EOL
h: left
j: down
k: up
l: right
s: shuffle tiles
c: check and quit, if it's ok.
?: show this messages
q: quit
EOL
    read -p "(press any key to continue.)" -s -n 1
}

main() {
    declare -i s=0

    while :
    do
        clear
        for i in {1..16}
        do
            echo -n "${arr[i]}"
            [ `expr $i % 4` -eq 0 ] && printf \\n
        done

        pre=$now
        mv=0

        if [ $s -eq 0 ]; then
            read -s -n 1 k
        else
            k=${mov[ ((RANDOM % 4)) ]}
            s=`expr $s - 1`
        fi

        case $k in
            "k" ) [ $now -ge 5 ] && mv=-4 ;;
            "j" ) [ $now -le 12 ] && mv=4 ;;
            "h" ) [ `expr $now % 4` -ne 1 ] && mv=-1 ;;
            "l" ) [ `expr $now % 4` -ne 0 ] && mv=1 ;;
            "s" ) s=`shuffle` ;;
            "c" ) [ `check` -eq 0 ] && break ;;
            "?" ) help ;;
            "q" ) break ;;
        esac

        if [ $mv -ne 0 ]; then
            now=`expr $now + $mv`
            buf=${arr[now]}
            arr[$now]=${arr[pre]}
            arr[$pre]=$buf
        fi

    done
}

main
