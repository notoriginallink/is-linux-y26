#!/bin/bash

# Валидация входных аргументов
if [[ $# -ne 1 ]]; then
	echo "Expected 1 parameter: PID"
	exit 1
fi

NUM_REGEXP='^[0-9]+$'
if ! [[ $1 =~ $NUM_REGEXP ]] ; then
	echo "Invalid argument. Expected PID of a process"
	exit 1
fi

PID=$1
GROUP_NAME='cpu-adjust'
GROUP_PATH='sys/fs/cgroup/$GROUP_NAME'

# Создание группы
if ! [[ -d "GROUP_PATH" ]] ; then
	echo "Creating cgroup"
	mkdir $GROUP_PATH
fi

echo $PID | tee "$GROUP_PATH/cgroup.procs" > /dev/null

# Мониторинг
while true; do
	CPU_USAGE=$(mpstat --dec=0 1 1 | tail -n 1 | awk '{print 100 - $12}')
	if [[ $CPU_USAGE -lt 20 ]]; then
		echo "80000 100000" | tee "$GROUP_PATH/cpu.max" > /dev/null
	else
		echo "20000 100000" | tee "$GROUP_PATH/cpu.max" > /dev/null
	fi

	sleep 5
done

exit 0
