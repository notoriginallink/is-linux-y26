# lab 2

### 0. Проверка связи между машинами и наличие дисков
ip-server: 10.0.2.15/24
ip-client: 10.0.2.9/24
Пинги с каждой машины на соответствующие адреса выполняются

Проверить наличие дисков можно выполнив на server команду lsblk (list block == список блочных устройств)
Вывод:
```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   20G  0 disk 
├─sda1   8:1    0 17,2G  0 part /
└─sda2   8:2    0  2,8G  0 part [SWAP]
sdb      8:16   0    2G  0 disk   
sdc      8:32   0    2G  0 disk 
sdd      8:48   0    2G  0 disk 
sde      8:64   0    2G  0 disk 
sr0     11:0    1 1024M  0 rom  
```
sdb, sdc, sdd, sde - добавленные диски

---

### 1. Создать новый раздел размером 500МБ на первом диске (sdb), начинающийся с первого свободного сектора
Запускаем утилиту fdisk для первого диска
```
fdisk /dev/sdb
```
Далее в её интерфейсе поочередно выполняем команды
- `n` - создание нового раздела
- `p` - создание основного раздела (или `e` - для расширенного)
- `1` - для выбора раздела
- **Enter** - для выбора первого свободного сектора
- `+500M` - указание размера раздела
- `w` - сохранение результатов

Теперь можно убедиться, что раздел создан с помощью lsblk
```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   20G  0 disk 
├─sda1   8:1    0 17,2G  0 part /
└─sda2   8:2    0  2,8G  0 part [SWAP]
sdb      8:16   0    2G  0 disk 
└─sdb1   8:17   0  500M  0 part 		# Созданный раздел
sdc      8:32   0    2G  0 disk 
sdd      8:48   0    2G  0 disk 
sde      8:64   0    2G  0 disk 
sr0     11:0    1 1024M  0 rom  
```

---

### 2. Сохранить UUID созданного раздела в домашний каталог root
UUID раздела можно узнать с помощью утилиты blkid или `lsblk -f`
``` bash
blkid /dev/sdb1
```

Но для раздела **sdb1** еще не назначен UUID так как раздел не был отформатирован

---

### 3. Создать на разделе sdb1 файловую систему *ext4* с размером блока 4096 байт
``` bash
mkfs.ext4 -b 4096 /dev/sdb1
```

Теперь вывод команды `blkid /dev/sdb1` выглядит так
```
/dev/sdb1: UUID="d9f4bafa-9eda-4eca-a119-661761123787" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="e0339f71-01"
```

И можно сохранить UUID в файл (пункт 2)
``` bash
blkid --match-tag UUID --output value /dev/sdb1 > /root/sdb1_uuid
```

---

### 4. Вывести текущее состояние параметров, записанных в суперблоке созданной файловой системы
``` bash
dumpe2fs /dev/sdb1
```

Или можно получить информацию только о параметрах суперблока с помощью
``` bash
tune2fs -l /dev/sdb1
```

---

### 5. Настроить автоматическую проверку файловой системы каждый 2 месяца или после каждого 2 монтирования
Настраивается с помощью утилиты tune2fs
``` bash
tune2fs -i 2m -c 2 /dev/sdb1
```
- `-i` - интервалы между проверками
- `-c` - максимальное число монтирований (после которых будет запущена проверка)

Теперь можно посмотреть текущие параметры автоматических проверок с помощью 
``` bash
tune2fs -l /dev/sdb1 | grep -E "(Check interval)|(Maximum mount count)"
```
Вывод команды:
```
Maximum mount count:      2
Check interval:           5184000 (2 months)
```

---

### 6. Создать в каталоге `/mnt` подкаталог *newdisk* и смонтировать в него созданную файловую систему
``` bash
mkdir /mnt/newdisk

mount /dev/sdb1 /mnt/newdisk
```

Теперь можно получить информацию о файловых системам с помощью утилиты `df`
``` bash
df /dev/sdb1
```
Вывод команды:
```
Файловая система 1K-блоков Использовано Доступно Использовано% Cмонтировано в
/dev/sdb1           462816           24   426952            1% /mnt/newdisk
```

---

### 7. Создать в домашнем каталоге root ссылку на смонтированную файловую систему
Создадим симлинк на созданный в прошлом пункте каталог
``` bash
ln -s /mnt/newdisk /root/sdb1.fs
```
Можно получить информацию о каталоге с помощью `ls -l /root/sdb1.fs`

Вывод:
```
lrwxrwxrwx 1 root root 13 фев 27 19:20 /root/sdb1.fs -> /mnt/newdisk/
```

---

### 8. Создать каталог в смонтированной файловой системе
``` bash
mkdir /root/sdb1.fs/new_dir
```

---

### 9. Включить автомонтирование созданной файловой системы при запуске так, чтобы в ней было невозможно запускать исполняемые файлы. А также с отключением записи времени последнего доступа к файлу
Для настройки автомонтирование нужно изменить файл `/etc/fstab`, а именно - добавить в него следущую строку:
```
/dev/sdb1	/mnt/newdisk	ext4	defaults,noexec,noatime		0	2
```
- `defaults` - набор значений по умолчанию
- `noexec` - переопределение параметра из значений по умолчанию (запрет на исполнение)
- `noatime` - переопределение параметра из значений по умолчанию (отключение записи времени)
- `0` - отключение проверки файловой системы при запуске (`1` - проверяется первой (корневая) и `2` - проверяется после корневой)
- `2` - порядок монтирования (`1` - самой первой (корневая), `2` - после корневой)

После перезагрузки проверим, что файловая система автоматически вмонтировалась с помощью `df /dev/sdb1` или `mount | grep "/dev/sdb1"`
```
/dev/sdb1 on /mnt/newdisk type ext4 (rw,noexec,noatime)
```

Теперь создадим в файловой системе исполняемый файл и попробуем его выполнить
``` bash
echo '!bin/bash\n echo "Hello, World!" >> /mnt/newdisk/hello.sh'
chmod +x /mnt/newdisk/hello.sh
```

При попытке его исполнить появляется ошибка
```
-bash: /mnt/newdisk/hello.sh: Отказано в доступе
```

---

### 10. Увеличить размер раздела и файловой системы до 1 Гб
Сначала отмонтируем файловую систему с помощью `umount /dev/sdb1`

Теперь используем утилиту `fdisk`, в ней сначала выполним команду `d` чтобы удалить сузествующий раздел, а потом повторим команды из п.1

Дальше увеличим размер файловой системы
``` bash
resize2fs /dev/sdb1
```

Проверим параметры раздела и файловой системы с помощью `fdisk` и `df`
```
# fdisk -l /dev/sdb1
Disk /dev/sdb1: 1 GiB, 1073741824 bytes, 2097152 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

# df --human-readable /dev/sdb1
Файловая система Размер Использовано  Дост Использовано% Cмонтировано в
/dev/sdb1          945M          28K  889M            1% /mnt/newdisk
```

---

### 11. Проверить на наличие ошибок созданную файловую систему в "безопасном режиме"
Для проверки в read-only режиме используем утилиту
``` bash
e2fsck -n /dev/sdb1
```

Вывод команды:
```
e2fsck 1.47.0 (5-Feb-2023)
Warning!  /dev/sdb1 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
/dev/sdb1 has been mounted 3 times without being checked, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdb1: 12/256000 files (0.0% non-contiguous), 20439/262144 blocks
```
Видим, что ошибок при проверке не обнаружено, и некоторую информацию, а именно:
- Использовано всего 12 inodes из 256000 доступных
- 0% файлов фрагментировано
- Используется 20439 из 262144 блоков на диске


---

### 12. Создание нового раздела в 12Мб а также перемещение в этот раздел журнала файловой системы из п.3
Создадим новый раздел с помощью `fdisk /dev/sdb` аналогично п.1
```
# lsblk /dev/sdb
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sdb      8:16   0   2G  0 disk 
├─sdb1   8:17   0   1G  0 part 
└─sdb2   8:18   0  12M  0 part 
```

Создадим файловую систему на разделе **sdb2** для хранения журнала (Размер блока должен быть такой же как у **/dev/sdb1**)
```
mkfs.ext4 -O journal_dev -b 4096 /dev/sdb2
```

Далее изменим местоположение журнала файловой системы **/dev/sdb1** на **/dev/sdb2**
``` bash
tune2fs -O ^has_journal /dev/sdb1		# Удалить существующий журнал
tune2fs -J device=/dev/sdb2 /dev/sdb1		# Создать журнал в файловой системе /dev/sdb2
```

Теперь проверим что журнал расположен в **/dev/sdb2**
```
# blkid /dev/sdb2
/dev/sdb2: UUID="d7ea4f06-a16c-4bef-b7dd-3270c0c66399" BLOCK_SIZE="4096" LOGUUID="d7ea4f06-a16c-4bef-b7dd-3270c0c66399" TYPE="jbd" PARTUUID="e0339f71-02"

# tune2fs -l /dev/sdb1 | grep "Journal UUID"
Journal UUID:             d7ea4f06-a16c-4bef-b7dd-3270c0c66399
```
Как видим UUID совпадают

---

### 13. Создать на 2-м и 3-м дисках разделы, занимающие весь объем и инициализировать их для LVM
Создаем разделы аналогично п.1 для дисков **/dev/sdc** и **/dev/sdd**
- Но в конце используем команду `t` - для определения типа раздела (указываем `8e` - LVM)

Далее инициализируем разделы для LVM используя `pvcreate /dev/sdc1 /dev/sdd1`
```
# pvdisplay
"/dev/sdc1" is a new physical volume of "<2,00 GiB"
--- NEW Physical volume ---
PV Name               /dev/sdc1
VG Name               
PV Size               <2,00 GiB
Allocatable           NO
PE Size               0   
Total PE              0
Free PE               0
Allocated PE          0
PV UUID               0Wco6Z-YzI1-6lq2-cB3I-vtvL-L0UQ-Ey3T5G

"/dev/sdd1" is a new physical volume of "<2,00 GiB"
--- NEW Physical volume ---
PV Name               /dev/sdd1
VG Name               
PV Size               <2,00 GiB
Allocatable           NO
PE Size               0   
Total PE              0
Free PE               0
Allocated PE          0
PV UUID               7aJ5lF-ZF6T-ExD8-SC8Y-npZa-NYvW-LF3y2H

```

---

### 14. Создать на дисках чередующийся LVM том и файловую систему ext4 на нем
Сначала  создадим группу томов из дисков
``` bash
vgcreate g1 /dev/sdc1 /dev/sdd1
```
Далее создаем логический том с чередованием
``` bash
lvcreate --extents 100%FREE --stripes 2 --name lv1 g1
```
Созданный логический том располагается по пути **/dev/g1/lv1**

Теперь создадим файловую систему с помощью `mkfs.ext4 /dev/g1/lv1`

---

### 15. Смонтировать том lv1 в каталог */mnt/vol01* и настроить автомонтирование
Аналогично п.6 монтируем том
``` bash
mkdir /mnt/vol01
mount /dev/g1/lv1 /mnt/vol01
```
Аналогично п.9 настраиваем автомонтирование - добавляем в **/etc/fstab** строку
```
/dev/g1/lv1	/mnt/vol01	ext4	defaults	0	2
```
Проверим результат
```
# df --human-readable /dev/g1/lv1
Файловая система   Размер Использовано  Дост Использовано% Cмонтировано в
/dev/mapper/g1-lv1   3,9G          24K  3,7G            1% /mnt/vol01
```

---

### 16. Получить информацию LVM о дисках, volume group и volume
```
# pvdispay
  --- Physical volume ---
  PV Name               /dev/sdc1
  VG Name               g1
  PV Size               <2,00 GiB / not usable 3,00 MiB
  Allocatable           yes (but full)
  PE Size               4,00 MiB
  Total PE              511
  Free PE               0
  Allocated PE          511
  PV UUID               0Wco6Z-YzI1-6lq2-cB3I-vtvL-L0UQ-Ey3T5G
   
  --- Physical volume ---
  PV Name               /dev/sdd1
  VG Name               g1
  PV Size               <2,00 GiB / not usable 3,00 MiB
  Allocatable           yes (but full)
  PE Size               4,00 MiB
  Total PE              511
  Free PE               0
  Allocated PE          511
  PV UUID               7aJ5lF-ZF6T-ExD8-SC8Y-npZa-NYvW-LF3y2H
   

# vgdisplay g1
  --- Volume group ---
  VG Name               g1
  System ID             
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               3,99 GiB
  PE Size               4,00 MiB
  Total PE              1022
  Alloc PE / Size       1022 / 3,99 GiB
  Free  PE / Size       0 / 0   
  VG UUID               EfmWQ6-awJp-QCIJ-VU2Y-U5Ys-sgTl-GcpwfB
   

# lvdisplay /dev/g1/lv1
  --- Logical volume ---
  LV Path                /dev/g1/lv1
  LV Name                lv1
  VG Name                g1
  LV UUID                m9fYzf-r2J8-ZLKD-aCpV-8HdI-UWxf-oWpsiJ
  LV Write Access        read/write
  LV Creation host, time d12, 2025-02-27 23:17:55 +0300
  LV Status              available
  # open                 1
  LV Size                3,99 GiB
  Current LE             1022
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     512
  Block device           254:0
   
```

---

### 17. Расширить группу на еще один диск и добавить в том 100% нового диска
1. Создадим на новом диске **/dev/sde** раздел для LVM аналогично п.13
2. Создадим для раздела физический том `pvcreate /dev/sde1`
3. Добавим физический том в существующую группу `vgextend g1 /dev/sde1`
4. Расширим логический том lv1 на 100% добавленного объема `lvextend --extents +100%FREE /dev/g1/lv1`

Но на самом деле логический том расширен не будет, потому что создавался с 2 полосами, а значит нужно чтобы число физических дисков было кратно 2

---


### 18. Расширить файловую систему на 100% диска
``` bash
resize2fs /dev/g1/lv1
```

Также не имеет эффекта по причине из п.17

---

### 19. Получить информацию о LVM о дисках, volume groupe и volume
```
# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sdc1
  VG Name               g1
  PV Size               <2,00 GiB / not usable 3,00 MiB
  Allocatable           yes (but full)
  PE Size               4,00 MiB
  Total PE              511
  Free PE               0
  Allocated PE          511
  PV UUID               0Wco6Z-YzI1-6lq2-cB3I-vtvL-L0UQ-Ey3T5G
   
  --- Physical volume ---
  PV Name               /dev/sdd1
  VG Name               g1
  PV Size               <2,00 GiB / not usable 3,00 MiB
  Allocatable           yes (but full)
  PE Size               4,00 MiB
  Total PE              511
  Free PE               0
  Allocated PE          511
  PV UUID               7aJ5lF-ZF6T-ExD8-SC8Y-npZa-NYvW-LF3y2H
   
  --- Physical volume ---
  PV Name               /dev/sde1
  VG Name               g1
  PV Size               <2,00 GiB / not usable 3,00 MiB
  Allocatable           yes 
  PE Size               4,00 MiB
  Total PE              511
  Free PE               511
  Allocated PE          0
  PV UUID               67flG7-1253-SAgi-siDy-wUW7-6mzD-JDecNf
   
# vgdisplay g1
  --- Volume group ---
  VG Name               g1
  System ID             
  Format                lvm2
  Metadata Areas        3
  Metadata Sequence No  7
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                3
  Act PV                3
  VG Size               <5,99 GiB
  PE Size               4,00 MiB
  Total PE              1533
  Alloc PE / Size       1022 / 3,99 GiB
  Free  PE / Size       511 / <2,00 GiB				# Как видим свобоное место есть
  VG UUID               EfmWQ6-awJp-QCIJ-VU2Y-U5Ys-sgTl-GcpwfB
 
# lvdisplay /dev/g1/lv1
  --- Logical volume ---
  LV Path                /dev/g1/lv1
  LV Name                lv1
  VG Name                g1
  LV UUID                LNdxxb-Ryb2-tG6G-8kwm-wuBe-m2Ln-2DQAyA
  LV Write Access        read/write
  LV Creation host, time d12, 2025-02-28 00:13:10 +0300
  LV Status              available
  # open                 1
  LV Size                3,99 GiB				# Но расширение про исходит, так как добавлен всего 1 диск
  Current LE             1022
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     512
  Block device           254:0
   
```

---
