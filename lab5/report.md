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

### 7. Изоляция процессов
``` bash
unshare --pid --fork bash	# --pid создает новое пространство для процессов, а --fork создает отдельный процесс (без него ps покажет процессы хоста)
mount -t proc /proc		# Монтируем новый интерфейс (можно делать ключом --mount-proc в unshare)
```
После создания пространства мы оказываемся в новой среде, где процесс, который создал пространство имеет PID=1

Вывод команды `ps aux` в новом пространстве
```
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.3   7296  3896 tty1     S    23:46   0:00 bash
root           8  0.0  0.4  11084  4436 tty1     R+   23:47   0:00 ps aux
```
После выхода из пространства нужно обратно смонтировать **proc** - `mount -t proc proc /proc`

---

### 8. Изоляция файловой системы
``` bash
unshare --mount bash				# Создание пространства
mkdir /tmp/private_$(whoami)			# Создание директории
mount -t tmpfs tmpfs /tmp/private_$(whoami)	# Монтирование новой временной директории
```
Проверим монтирование в новом пространстве с помощью `df -h | grep private_$(whoami)`
```
tmpfs              481M            0  481M            0% /tmp/private_root
```
На основном хосте команда ничего не выводит

---

### 9. Изоляция сети
``` bash
unshare --net bash
```
Новое пространство должно не иметь никаких сетевых интерфейсов, проверим с помощью `ip a`
```
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
```
Нет никаких интерфейсов, кроме LOOPBACK, поэтому команда `ping google.com` ожидаемо завершится неуспешно
```
ping: google.com: Временный сбой в разрешении имен
```
Хотя на основном хосте запрос проходит
```
PING google.com (64.233.164.113) 56(84) bytes of data.
64 bytes from lf-in-f113.1e100.net (64.233.164.113): icmp_seq=1 ttl=107 time=8.78 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 8.778/8.778/8.778/0.000 ms
```

---

### 10. Создание OverlayFS
#### a. Настройка
Создадим директории для каждого из слоев а также поместим проверочный файл в каталог **lower**
``` bash
mkdir -p ~/overlay_/{lower,upper,work,merged}

echo "Оригинальный текст из LOWER" >> ~/overlay_/lower/04_original.txt

mount -t overlay overlay -o lowerdir=/root/overlay_/lower,upperdir=/root/overlay_/upper,workdir=/root/overlay_/work ~/overlay_/merged
```

#### b. Имитация неполодки и отладка
Удалим текстовый файл из каталога merged - `rm -f /root/overlay_/merged/04_original.txt`

Теперь проверим файлы в верхнем каталоге (`ls -l`) 
```
итого 0
c--------- 2 root root 0, 0 апр  8 00:26 04_original.txt
```
Для того, чтобы восстановить файл `04_original.txt` удалим его в каталоге **upper**, тогда OverlayFS перестанет его скрывать и 
он станет снова видим в **merged**

#### c. Скрипт для аудита
``` bash
#!/bin/bash

OVERLAY="/root/overlay_"
UPPER_DIR="$OVERLAY/upper"
LOWER_DIR="$OVERLAY/lower"
MERGED_DIR="$OVERLAY/merged"

OUTPUT="04_audit.log"

rm -f "./$OUTPUT"
touch $OUTPUT


# Вывод всех Whiteout файлов в файл
UPPER_COUNT=0
for FILE in $(find $UPPER_DIR -type c); do
	if [[ $UPPER_COUNT -eq 0 ]]; then
		echo "======== Whiteout files ========" >> $OUTPUT 
	fi
	echo $FILE >> $OUTPUT
	UPPER_COUNT=$(($UPPER_COUNT + 1))
done

if [[ $UPPER_COUNT -ne 0 ]]; then
	echo >> $OUTPUT
fi

# Разница между Lower и Merged
echo "======== Lower and Merged diff ========" >> $OUTPUT
diff -y "$LOWER_DIR" "$MERGED_DIR" >> $OUTPUT

exit 1
```

#### d. Ответы на вопросы
- **Как OverlayFS скрывает файлы из нижнего слоя при удалении в объединенном?**

При помощи Whiteout файлов, при удалении файла в merged (который изначально при монтировании был в lower), в upper создается файл специального типа
который указывает файловой системе, что этот файл нужно скрыть из merged

---
- **Можно ли перемонтировать OvelayFS если удалить каталог work?**

Нет, так как каталог work - обязательный для монтирования, там хранятся временные служебные файлы, необходимые для функционирования файловой системы

---
- **Что будет с каталогом Merged, если верхний каталог будет пуст?**

Ничего, просто все файлы из нижнего каталога будут присутствовать в каталоге merged

---

### 11. Оптимизация Dockerfile
Итоговый dockerfile
``` dockerfile
FROM python:3.13.2-slim					# Исопльзуется меньши образ (на 10-40% меньше)
WORKDIR /app						# Создаем директорию /app и переходим в неё
COPY requirements.txt					# Копируем и устанавливаем зависимости отдельно от приложения для кэширования
RUN pip install --no-cache-dir -r requirements.txt	
COPY . .
RUN useradd -m appuser					# Создаем отдельного пользователя для образа
USER appuser
CMD ["python", "app.py"]
```
Файл `requirements.txt` - содержащий зависимости
``` text
flask==3.1.0
```
Файл `.dockerignore`
``` 
**/__pycache__/
env/
venv/
.git/
```

---
