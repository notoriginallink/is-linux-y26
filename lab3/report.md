# Lab3 - report

### 1. Вывести список всех подключенных репозиториев
Все репозитории перечислены в файле `/etc/apt/sources.list` (или в каталоге `/etc/apt/sources.list.d/` для Debian)

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

### 4. Установка пакета *build-essentials*
Для установки используем команду
``` bash
apt install build-essentials
```
Предварительно, чтобы узнать какие пакеты будут установлены, а какие изменены можно выполнить команду с ключом `--simulate`

Вывод команды
```
Чтение списков пакетов…
Построение дерева зависимостей…
Чтение информации о состоянии…
Будут установлены следующие дополнительные пакеты:
  binutils binutils-common binutils-x86-64-linux-gnu cpp cpp-12 dirmngr
  dpkg-dev fakeroot fontconfig-config fonts-dejavu-core g++ g++-12 gcc gcc-12
  gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client gpg-wks-server
  gpgconf gpgsm libabsl20220623 libalgorithm-diff-perl
  libalgorithm-diff-xs-perl libalgorithm-merge-perl libaom3 libasan8
  libassuan0 libatomic1 libavif15 libbinutils libc-dev-bin libc-devtools
  libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdav1d6 libde265-0
  libdeflate0 libdpkg-perl libfakeroot libfile-fcntllock-perl libfontconfig1
  libgav1-1 libgcc-12-dev libgd3 libgomp1 libgprofng0 libheif1 libisl23
  libitm1 libjbig0 libjpeg62-turbo libksba8 liblerc4 liblsan0 libmpc3 libmpfr6
  libnpth0 libnsl-dev libnuma1 libquadmath0 librav1e0 libstdc++-12-dev
  libsvtav1enc1 libtiff6 libtirpc-dev libtsan2 libubsan1 libwebp7 libx265-199
  libxpm4 libyuv0 linux-libc-dev make manpages-dev pinentry-curses
  rpcsvc-proto
Предлагаемые пакеты:
  binutils-doc cpp-doc gcc-12-locales cpp-12-doc pinentry-gnome3 tor
  debian-keyring g++-multilib g++-12-multilib gcc-12-doc gcc-multilib autoconf
  automake libtool flex bison gdb gcc-doc gcc-12-multilib parcimonie
  xloadimage scdaemon glibc-doc bzr libgd-tools libstdc++-12-doc make-doc
  pinentry-doc
Следующие НОВЫЕ пакеты будут установлены:
  binutils binutils-common binutils-x86-64-linux-gnu build-essential cpp
  cpp-12 dirmngr dpkg-dev fakeroot fontconfig-config fonts-dejavu-core g++
  g++-12 gcc gcc-12 gnupg gnupg-l10n gnupg-utils gpg gpg-agent gpg-wks-client
  gpg-wks-server gpgconf gpgsm libabsl20220623 libalgorithm-diff-perl
  libalgorithm-diff-xs-perl libalgorithm-merge-perl libaom3 libasan8
  libassuan0 libatomic1 libavif15 libbinutils libc-dev-bin libc-devtools
  libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdav1d6 libde265-0
  libdeflate0 libdpkg-perl libfakeroot libfile-fcntllock-perl libfontconfig1
  libgav1-1 libgcc-12-dev libgd3 libgomp1 libgprofng0 libheif1 libisl23
  libitm1 libjbig0 libjpeg62-turbo libksba8 liblerc4 liblsan0 libmpc3 libmpfr6
  libnpth0 libnsl-dev libnuma1 libquadmath0 librav1e0 libstdc++-12-dev
  libsvtav1enc1 libtiff6 libtirpc-dev libtsan2 libubsan1 libwebp7 libx265-199
  libxpm4 libyuv0 linux-libc-dev make manpages-dev pinentry-curses
  rpcsvc-proto
Обновлено 0 пакетов, установлено 83 новых пакетов, для удаления отмечено 0 пакетов, и 4 пакетов не обновлено.
Inst binutils-common (2.40-2 Debian:12.9/stable [amd64])
Inst libbinutils (2.40-2 Debian:12.9/stable [amd64])
Inst libctf-nobfd0 (2.40-2 Debian:12.9/stable [amd64])
Inst libctf0 (2.40-2 Debian:12.9/stable [amd64])
Inst libgprofng0 (2.40-2 Debian:12.9/stable [amd64])
Inst binutils-x86-64-linux-gnu (2.40-2 Debian:12.9/stable [amd64])
Inst binutils (2.40-2 Debian:12.9/stable [amd64])
Inst libc-dev-bin (2.36-9+deb12u9 Debian:12.9/stable [amd64])
Inst linux-libc-dev (6.1.128-1 Debian-Security:12/stable-security [amd64])
Inst libcrypt-dev (1:4.4.33-2 Debian:12.9/stable [amd64])
Inst libtirpc-dev (1.3.3+ds-1 Debian:12.9/stable [amd64])
Inst libnsl-dev (1.3.0-2 Debian:12.9/stable [amd64])
Inst rpcsvc-proto (1.4.3-1 Debian:12.9/stable [amd64])
Inst libc6-dev (2.36-9+deb12u9 Debian:12.9/stable [amd64])
Inst libisl23 (0.25-1.1 Debian:12.9/stable [amd64])
Inst libmpfr6 (4.2.0-1 Debian:12.9/stable [amd64])
Inst libmpc3 (1.3.1-1 Debian:12.9/stable [amd64])
Inst cpp-12 (12.2.0-14 Debian:12.9/stable [amd64])
Inst cpp (4:12.2.0-3 Debian:12.9/stable [amd64])
Inst libcc1-0 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libgomp1 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libitm1 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libatomic1 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libasan8 (12.2.0-14 Debian:12.9/stable [amd64])
Inst liblsan0 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libtsan2 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libubsan1 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libquadmath0 (12.2.0-14 Debian:12.9/stable [amd64])
Inst libgcc-12-dev (12.2.0-14 Debian:12.9/stable [amd64])
Inst gcc-12 (12.2.0-14 Debian:12.9/stable [amd64])
Inst gcc (4:12.2.0-3 Debian:12.9/stable [amd64])
Inst libstdc++-12-dev (12.2.0-14 Debian:12.9/stable [amd64])
Inst g++-12 (12.2.0-14 Debian:12.9/stable [amd64])
Inst g++ (4:12.2.0-3 Debian:12.9/stable [amd64])
Inst make (4.3-4.1 Debian:12.9/stable [amd64])
Inst libdpkg-perl (1.21.22 Debian:12.9/stable [all])
Inst dpkg-dev (1.21.22 Debian:12.9/stable [all])
Inst build-essential (12.9 Debian:12.9/stable [amd64])
Inst libassuan0 (2.5.5-5 Debian:12.9/stable [amd64])
Inst gpgconf (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst libksba8 (1.6.3-2 Debian:12.9/stable [amd64])
Inst libnpth0 (1.6-3 Debian:12.9/stable [amd64])
Inst dirmngr (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst libfakeroot (1.31-1.2 Debian:12.9/stable [amd64])
Inst fakeroot (1.31-1.2 Debian:12.9/stable [amd64])
Inst fonts-dejavu-core (2.37-6 Debian:12.9/stable [all])
Inst fontconfig-config (2.14.1-4 Debian:12.9/stable [amd64])
Inst gnupg-l10n (2.2.40-1.1 Debian:12.9/stable [all])
Inst gnupg-utils (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst gpg (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst pinentry-curses (1.2.1-1 Debian:12.9/stable [amd64])
Inst gpg-agent (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst gpg-wks-client (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst gpg-wks-server (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst gpgsm (2.2.40-1.1 Debian:12.9/stable [amd64])
Inst gnupg (2.2.40-1.1 Debian:12.9/stable [all])
Inst libabsl20220623 (20220623.1-1 Debian:12.9/stable [amd64])
Inst libalgorithm-diff-perl (1.201-1 Debian:12.9/stable [all])
Inst libalgorithm-diff-xs-perl (0.04-8+b1 Debian:12.9/stable [amd64])
Inst libalgorithm-merge-perl (0.08-5 Debian:12.9/stable [all])
Inst libaom3 (3.6.0-1+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Inst libdav1d6 (1.0.0-2+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Inst libgav1-1 (0.18.0-1+b1 Debian:12.9/stable [amd64])
Inst librav1e0 (0.5.1-6 Debian:12.9/stable [amd64])
Inst libsvtav1enc1 (1.4.1+dfsg-1 Debian:12.9/stable [amd64])
Inst libjpeg62-turbo (1:2.1.5-2 Debian:12.9/stable [amd64])
Inst libyuv0 (0.0~git20230123.b2528b0-1 Debian:12.9/stable [amd64])
Inst libavif15 (0.11.1-1 Debian:12.9/stable [amd64])
Inst libfontconfig1 (2.14.1-4 Debian:12.9/stable [amd64])
Inst libde265-0 (1.0.11-1+deb12u2 Debian:12.9/stable [amd64])
Inst libnuma1 (2.0.16-1 Debian:12.9/stable [amd64])
Inst libx265-199 (3.5-2+b1 Debian:12.9/stable [amd64])
Inst libheif1 (1.15.1-1+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Inst libdeflate0 (1.14-1 Debian:12.9/stable [amd64])
Inst libjbig0 (2.1-6.1 Debian:12.9/stable [amd64])
Inst liblerc4 (4.0.0+ds-2 Debian:12.9/stable [amd64])
Inst libwebp7 (1.2.4-0.2+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Inst libtiff6 (4.5.0-6+deb12u2 Debian:12.9/stable [amd64])
Inst libxpm4 (1:3.5.12-1.1+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Inst libgd3 (2.3.3-9 Debian:12.9/stable [amd64])
Inst libc-devtools (2.36-9+deb12u9 Debian:12.9/stable [amd64])
Inst libfile-fcntllock-perl (0.22-4+b1 Debian:12.9/stable [amd64])
Inst manpages-dev (6.03-2 Debian:12.9/stable [all])
Conf binutils-common (2.40-2 Debian:12.9/stable [amd64])
Conf libbinutils (2.40-2 Debian:12.9/stable [amd64])
Conf libctf-nobfd0 (2.40-2 Debian:12.9/stable [amd64])
Conf libctf0 (2.40-2 Debian:12.9/stable [amd64])
Conf libgprofng0 (2.40-2 Debian:12.9/stable [amd64])
Conf binutils-x86-64-linux-gnu (2.40-2 Debian:12.9/stable [amd64])
Conf binutils (2.40-2 Debian:12.9/stable [amd64])
Conf libc-dev-bin (2.36-9+deb12u9 Debian:12.9/stable [amd64])
Conf linux-libc-dev (6.1.128-1 Debian-Security:12/stable-security [amd64])
Conf libcrypt-dev (1:4.4.33-2 Debian:12.9/stable [amd64])
Conf libtirpc-dev (1.3.3+ds-1 Debian:12.9/stable [amd64])
Conf libnsl-dev (1.3.0-2 Debian:12.9/stable [amd64])
Conf rpcsvc-proto (1.4.3-1 Debian:12.9/stable [amd64])
Conf libc6-dev (2.36-9+deb12u9 Debian:12.9/stable [amd64])
Conf libisl23 (0.25-1.1 Debian:12.9/stable [amd64])
Conf libmpfr6 (4.2.0-1 Debian:12.9/stable [amd64])
Conf libmpc3 (1.3.1-1 Debian:12.9/stable [amd64])
Conf cpp-12 (12.2.0-14 Debian:12.9/stable [amd64])
Conf cpp (4:12.2.0-3 Debian:12.9/stable [amd64])
Conf libcc1-0 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libgomp1 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libitm1 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libatomic1 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libasan8 (12.2.0-14 Debian:12.9/stable [amd64])
Conf liblsan0 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libtsan2 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libubsan1 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libquadmath0 (12.2.0-14 Debian:12.9/stable [amd64])
Conf libgcc-12-dev (12.2.0-14 Debian:12.9/stable [amd64])
Conf gcc-12 (12.2.0-14 Debian:12.9/stable [amd64])
Conf gcc (4:12.2.0-3 Debian:12.9/stable [amd64])
Conf libstdc++-12-dev (12.2.0-14 Debian:12.9/stable [amd64])
Conf g++-12 (12.2.0-14 Debian:12.9/stable [amd64])
Conf g++ (4:12.2.0-3 Debian:12.9/stable [amd64])
Conf make (4.3-4.1 Debian:12.9/stable [amd64])
Conf libdpkg-perl (1.21.22 Debian:12.9/stable [all])
Conf dpkg-dev (1.21.22 Debian:12.9/stable [all])
Conf build-essential (12.9 Debian:12.9/stable [amd64])
Conf libassuan0 (2.5.5-5 Debian:12.9/stable [amd64])
Conf gpgconf (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf libksba8 (1.6.3-2 Debian:12.9/stable [amd64])
Conf libnpth0 (1.6-3 Debian:12.9/stable [amd64])
Conf dirmngr (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf libfakeroot (1.31-1.2 Debian:12.9/stable [amd64])
Conf fakeroot (1.31-1.2 Debian:12.9/stable [amd64])
Conf fonts-dejavu-core (2.37-6 Debian:12.9/stable [all])
Conf fontconfig-config (2.14.1-4 Debian:12.9/stable [amd64])
Conf gnupg-l10n (2.2.40-1.1 Debian:12.9/stable [all])
Conf gnupg-utils (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf gpg (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf pinentry-curses (1.2.1-1 Debian:12.9/stable [amd64])
Conf gpg-agent (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf gpg-wks-client (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf gpg-wks-server (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf gpgsm (2.2.40-1.1 Debian:12.9/stable [amd64])
Conf gnupg (2.2.40-1.1 Debian:12.9/stable [all])
Conf libabsl20220623 (20220623.1-1 Debian:12.9/stable [amd64])
Conf libalgorithm-diff-perl (1.201-1 Debian:12.9/stable [all])
Conf libalgorithm-diff-xs-perl (0.04-8+b1 Debian:12.9/stable [amd64])
Conf libalgorithm-merge-perl (0.08-5 Debian:12.9/stable [all])
Conf libaom3 (3.6.0-1+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Conf libdav1d6 (1.0.0-2+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Conf libgav1-1 (0.18.0-1+b1 Debian:12.9/stable [amd64])
Conf librav1e0 (0.5.1-6 Debian:12.9/stable [amd64])
Conf libsvtav1enc1 (1.4.1+dfsg-1 Debian:12.9/stable [amd64])
Conf libjpeg62-turbo (1:2.1.5-2 Debian:12.9/stable [amd64])
Conf libyuv0 (0.0~git20230123.b2528b0-1 Debian:12.9/stable [amd64])
Conf libavif15 (0.11.1-1 Debian:12.9/stable [amd64])
Conf libfontconfig1 (2.14.1-4 Debian:12.9/stable [amd64])
Conf libde265-0 (1.0.11-1+deb12u2 Debian:12.9/stable [amd64])
Conf libnuma1 (2.0.16-1 Debian:12.9/stable [amd64])
Conf libx265-199 (3.5-2+b1 Debian:12.9/stable [amd64])
Conf libheif1 (1.15.1-1+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Conf libdeflate0 (1.14-1 Debian:12.9/stable [amd64])
Conf libjbig0 (2.1-6.1 Debian:12.9/stable [amd64])
Conf liblerc4 (4.0.0+ds-2 Debian:12.9/stable [amd64])
Conf libwebp7 (1.2.4-0.2+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Conf libtiff6 (4.5.0-6+deb12u2 Debian:12.9/stable [amd64])
Conf libxpm4 (1:3.5.12-1.1+deb12u1 Debian:12.9/stable, Debian-Security:12/stable-security [amd64])
Conf libgd3 (2.3.3-9 Debian:12.9/stable [amd64])
Conf libc-devtools (2.36-9+deb12u9 Debian:12.9/stable [amd64])
Conf libfile-fcntllock-perl (0.22-4+b1 Debian:12.9/stable [amd64])
Conf manpages-dev (6.03-2 Debian:12.9/stable [all])
```
Параметр `inst` означает, что пакет будет установлен, а параметр `conf` - что пакет уже загружен и распакован, но еще не настроен. Также возможны параметры
`remv` (remove), `upgr` (upgrade) и `held` (установка отложена)

---

### 5. Найти пакет, в описании которого присутствует *"clone with a bastard algorithm"*
Для поиска пакетов используется команда `apt search`, она ищет по именам и описаниям и выводит найденные совпадения
``` bash
apt search "clone with a bastard algorithm"
```

Вывод команды
```
Сортировка…
Полнотекстовый поиск…
bastet/stable 0.43-7+b1 amd64
  ncurses Tetris clone with a bastard algorithm
```
Найденный пакет - `bastet`

---

### 6. Скачать исходный код найденного в п.5 пакета
Создадим директорию *bastet_src* в домашнем каталоге и скачаем исходный код с помощью **git**
``` bash
mkdir ~/bastet_src
cd ~/bastet_src
apt-get source bastet
```

---

### 7. Установить пакет из исходных кодов
Для работы bastet дополнительно потребовалось установить библиотеки **Boost** (`libboost-all-dev`) и **ncurses** (`libncurses5-dev` и `lincursesw5-dev`)
``` bash
cd bastet-0.43	# каталог, содержащий Makefile
make
```
После этого в каталоге появился исполняемый файл `bastet`

---

### 8. Изменение Makefile пакета
Для изменения каталога установки нужно изменить (добавить) переменные
```
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
```

Далее нужно изменить (добавить) шаг **install**
``` makefile
install: 
	cp bastet $(BINDIR)
	chmod 755 $(BINDIR)/bastet
```
Теперь заново установим пакет
``` bash
make clean
make
make install
```

Итоговый Makefile выглядит так
``` makefile
SOURCES=Ui.cpp main.cpp Block.cpp Well.cpp BlockPosition.cpp Config.cpp BlockChooser.cpp BastetBlockChooser.cpp
PROGNAME=bastet
LDFLAGS+=-lncurses
#CXXFLAGS+=-ggdb -Wall
CXXFLAGS+=-DNDEBUG -Wall
#CXXFLAGS+=-pg
#LDFLAGS+=-pg
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

all: $(PROGNAME)

depend: *.hpp $(SOURCES)
	$(CXX) -MM $(SOURCES) > depend

include depend

$(PROGNAME): $(SOURCES:.cpp=.o)
	$(CXX) -ggdb -o $(PROGNAME) $(SOURCES:.cpp=.o) $(LDFLAGS) -lboost_program_options

clean:
	rm -f $(SOURCES:.cpp=.o) $(PROGNAME)

mrproper: clean
	rm -f *~

install:
	cp $(PROGNAME) $(BINDIR)
	chmod 755 $(BINDIR)/$(PROGNAME)
```

---

### 9. Проверить, что все пользователи могут запускать утилиту
Зайдем под пользователем myuser и убедимся, что команда `bastet` запускает игру

---

### 10. Вывести в файл список всех установленных пакетов
``` bash
apt list --installed >> task10.log
```

---

### 11. Вывести в файл список всех необходимых для установки gcc зависимостей
``` bash
apt show gcc | grep -E "Depends|Recommends|Suggests" >> task11.log
```
- **Depends** - необходимые для установки пакеты (и их минимальные версии)
- **Recommends** - рекомендуемые для установки пакеты (по умолчанию установятся, если не передан ключ `--no-install-recommends`)
- **Suggests** - предлагаемые к установке пакеты, по умолчанию не устанавливаются

Также можно посмотреть с помощью `apt-cache depends gcc`

---

### 12. Вывести в файл список всех пакетов, которые зависят от пакета libgpm2
``` bash
apt-cache rdepends libgpm2 >> task12.log
```

---

### 13. Скачать в каталог localrepo 5 разных версий утилиты htop
``` bash
mkdir ~/localrepo
wget http://snapshot.debian.org/archive/debian/20240101T000000Z/pool/main/h/htop/htop_3.4.0-2_amd64.deb
wget http://snapshot.debian.org/archive/debian/20250310T101857Z/pool/main/h/htop/htop_3.4.0-1_amd64.deb
wget http://snapshot.debian.org/archive/debian/20250209T210016Z/pool/main/h/htop/htop_3.3.0-5_amd64.deb
wget http://snapshot.debian.org/archive/debian/20230217T025930Z/pool/main/h/htop/htop_3.2.2-2_amd64.deb
wget http://snapshot.debian.org/archive/debian/20210502T143907Z/pool/main/h/htop/htop_3.0.5-7_amd64.deb
```

---
