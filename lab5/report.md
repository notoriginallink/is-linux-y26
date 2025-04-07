# Lab5

### 1. Создание пользователя и выделение ему квоты на использование процессора
Создадим пользователя **user-04** и выделим ему квоту в 30% CPU
```
adduser user-04
```
Далее создадим в псевдофайловой системе `sys/fs/cgroup` директорию=группу в которой ограничим использование ресурсов процессора
```
mkdir /sys/fs/cgroup/user-04				# Создание контрольной группы
echo "30000 100000" > /sys/fs/cgroup/user-04/cpu.max	# Разрешаем использовать только 30мс за период 100мс
```
Теперь процессы, PID которых будет помещен в файл `sys/fs/cgroup/user-04/cgroup.procs` будут ограничены в 30% использования CPU

---

### 2. Ограничение памяти для процесса
Создадим группу **mem-test**
```
mkdir /sys/fs/cgroup/mem-test
echo "566231040" | tee /sys/fs/cgroup/mem-test/memory.max	# (04*10 + 500) = 540МБ = 566_231_040Б
```
Далее создадим программу, который будет забивать память
``` python

a = []
while True:
	a.append(' ' * 10**7)

```
Запустим ее и переведем процесс в группу **mem-test**
``` bash
python3 part2.py &
echo $! | tee /sys/fs/cgroup/mem-test/cgroup.procs
```
Процесс завершится через пару секунд

---

### 3. Ограничение по IO
Для этого пункта пришлось переключиться на cgroups_v1 так как ios.max не работало :(

Создадим группу **io-test**
```
cgcreate -g blkio:/io-test
echo "8:0 1040" | tee /sys/fs/cgroup/blkio/io-test/blkio.throttle.read_iops_device
echo "8:0 540" | tee /sys/fs/cgroup/blkio/io-test/blkio.throttle.write_iops_device
```
- `8:0` - MAJOR:MINOR разделы устройства sda (можно узнать через lsblk)

---

### 4. Закрепление к определенному ядру процессора
Создадим группу **cpu-core-test**
```
cgcreate -g cpuset:/cpu-core-test
```
И закрепим все процессы этой группы на ядро 0
```
echo 0 | tee /sys/fs/cgroup/cpuset/cpu-core-test/cpuset.cpus
echo 0 | tee /sys/fs/cgroup/cpuset/cpu-core-test/cpuset.mems	# Почему то по умолчанию не проставляется и без нее не работает
```
Теперь запустим утилиту top в созданной группе и проверим на каком ядре она запущена
```
cgexec -g cpuset:/cpu-core-test top &
taskset -p 706
```
Вывод команды
```
pid 706's current affinity mask: 1	# 1 = 0 ядро (как ни странно)
```

---

### 5. Динамическая корректировка ресурсов
``` bash
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
```

---

### 6. Создание изолированного имени хоста
Используем утилиту `unshare` для создания новых неймспейсов
``` bash
unshare --uts bash	# UTS - изменения hostname и domainname не будут влиять на основную систему
```
Теперь установим новый hostname - `hostname isolated-student-04` и убедимся, что имя поменялось только в этом пространстве, а в другой сессии остaлось d12

---
