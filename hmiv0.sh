#:/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

ct=0

while true
do

request=$(tail -n 50 /honeydrive/conpot/bin/conpot.log | grep "function_code': 5" | tail -1 |cut -d'{' -f2 | cut -d',' -f3 | cut -d' ' -f3 | tr -d "'" |  tail -c 11)
response=$(tail -n 50 /honeydrive/conpot/bin/conpot.log | grep "function_code': 5" | tail -1 |cut -d'{' -f2 | cut -d',' -f4 | cut -d' ' -f3 | cut -d'}' -f1 | tr -d "'")
slaveid=$(tail -n 50 /honeydrive/conpot/bin/conpot.log | grep "function_code': 5" | tail -1 |cut -d'{' -f2 | cut -d',' -f2 | cut -d' ' -f3)
command=$(echo $request | tail -c 10 | tail -c 5)

	if [ $request == $response ] && [ $slaveid -eq 1 ];
	then
		if [ $command == 'ff00' ];
			then
				status=1
		elif [ $command == '0000' ];
			then
				status=0
		fi
	fi

	if [ $ct -eq 0 ];
	then

		if [ $status -eq 1 ];
        		then
                		printf "${GREEN}EQUIPAMENTO LIGADO${NC}\n\n\n\n\n\n\n\n"
                elif [ $status -eq 0 ];
                        then
				printf "${RED}EQUIPAMENTO DESLIGADO${NC}\n\n\n\n\n\n\n\n"
                fi

		prev=$status
		ct=1
	fi

	if [ $prev -ne $status ];
		then
			if [ $status -eq 1 ];
				then
					printf "${GREEN}EQUIPAMENTO LIGADO${NC}\n\n\n\n\n\n\n\n"
			elif [ $status -eq 0 ];
				then
					printf "${RED}EQUIPAMENTO DESLIGADO${NC}\n\n\n\n\n\n\n\n"
			fi
			prev=$status
	fi

	sleep 1
	#echo $request $response $slaveid $command
done
