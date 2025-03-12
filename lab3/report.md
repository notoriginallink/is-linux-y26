# Lab3 - report

### 1. Вывести список всех подключенных репозиториев
Все репозитории перечислены в файле `/etc/apt/sources.list` (или в файле `/etc/apt/sources.list.d` для Debian)

Содержимое файла
```
deb http://deb.debian.org/debian/ bookworm main non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware

deb http://deb.debian.org/debian/ bookworm-updates main non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-updates main non-free-firmware
```

---

### 2. Обновить локальные индексы пакетов в менеджере пакетов
Для обновления информации о доступных пакетах используется утилита **apt**
``` bash
apt update	# Или apt-get update
```

---

### 3. Вывести информацию о пакете *build-essential*
Для вывода информации о пакете также используется утилита **apt**
``` bash
apt show build-essential
```
 
Вывод команды
```
Package: build-essential
Version: 12.9
Priority: optional
Build-Essential: yes
Section: devel
Maintainer: Matthias Klose <doko@debian.org>
Installed-Size: 20,5 kB
Depends: libc6-dev | libc-dev, gcc (>= 4:10.2), g++ (>= 4:10.2), make, dpkg-dev (>= 1.17.11)
Tag: devel::packaging, interface::commandline, role::data, role::program,
 scope::utility, suite::debian
Download-Size: 7 704 B
APT-Sources: http://deb.debian.org/debian bookworm/main amd64 Packages
Description: информационный список пакетов необходимых для сборки
 Этот пакет вам не нужен, если вы не хотите собирать пакеты Debian. Начиная
 с dpkg версии 1.14.18 этот пакет требуется для сборки пакетов Debian.
 .
 Пакет содержит информационный список пакетов, считающихся необходимыми для
 сборки пакетов Debian. Он также зависит от них для упрощения его установки.
 .
 Если этот пакет установлен, то вам требуется установить то, что указано в
 зависимостях времени сборки пакета, который вы собираете. Или, если вы
 определяете зависимости времени сборки вашего пакета, вы можете пропустить
 пакеты, от которых зависит этот пакет.
 .
 Этот пакет не является определением пакетов необходимых для сборки; такое
 определение дано в Руководстве по политике Debian. Этот пакет всего лишь
 содержит информационный список, то что нужно большинству. Но, если есть
 противоречие в этом пакете и Руководстве, последнее имеет приоритет.

```

---


