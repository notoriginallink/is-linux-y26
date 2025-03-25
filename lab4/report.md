# Lab4 - systemd

## Часть 1. Получение информации о времени загрузки

#### 1. Время, потраченное на загрузку системы
Команда `systemd-analyze`

Вывод
```
Startup finished in 3.510s (kernel) + 3.222s (userspace) = 6.732s 
graphical.target reached after 3.094s in userspace.
```
- **3.510s (kernel)** - время, потраченное на инициализацию (загрузка ядра, обнаруэение устройств, монтирофание ФС и старт `systemd`)
- **3.222s (userspace)** - время, потраченное на запуск `systemd` и остальных пользовательских демонов (сервисов, служб)
- **graphical.target reached after 3.094s in userspace** - время, которое загружалась графическая оболочка после загрузки *userspace*

---

#### 2. Список всех сервисов в порядке уменьшения времени, потраченного на загрузку
Команда `systemd-analyze blame`

Вывод
```
1.798s man-db.service
1.165s dev-sda1.device
1.072s logrotate.service
1.027s apt-daily.service
 945ms e2scrub_reap.service
 912ms systemd-timesyncd.service
 858ms networking.service
 762ms dpkg-db-backup.service
 751ms systemd-binfmt.service
 571ms apt-daily-upgrade.service
 483ms apparmor.service
 453ms keyboard-setup.service
 384ms systemd-udev-trigger.service
 366ms systemd-logind.service
 272ms fstrim.service
 253ms systemd-journald.service
 233ms modprobe@drm.service
 194ms modprobe@fuse.service
 180ms systemd-udevd.service
 179ms modprobe@dm_mod.service
 168ms systemd-user-sessions.service
 164ms systemd-journal-flush.service
 157ms systemd-remount-fs.service
 151ms wpa_supplicant.service
 148ms dbus.service
 146ms kmod-static-nodes.service
 137ms modprobe@configfs.service
 135ms systemd-sysusers.service
 133ms proc-sys-fs-binfmt_misc.mount
 127ms user@0.service
 124ms dev-hugepages.mount
 123ms dev-mqueue.mount
 122ms sys-kernel-debug.mount
 120ms modprobe@efi_pstore.service
 118ms sys-kernel-tracing.mount
 115ms systemd-modules-load.service
 112ms ssh.service
 108ms modprobe@loop.service
 105ms systemd-tmpfiles-clean.service
  95ms systemd-sysctl.service
  85ms systemd-tmpfiles-setup.service
  79ms e2scrub_all.service
  78ms systemd-tmpfiles-setup-dev.service
  75ms dev-disk-by\x2duuid-53b0ace9\x2d77d8\x2d476d\x2da359\x2dc1cc4d0002e6.swap
  68ms systemd-random-seed.service
  66ms console-setup.service
  53ms sys-kernel-config.mount
  41ms sys-fs-fuse-connections.mount
  41ms systemd-update-utmp.service
  38ms ifupdown-pre.service
  12ms systemd-update-utmp-runlevel.service
   7ms user-runtime-dir@0.service
```

---

#### 3. Зависимости сервиса `sshd`
Команда `systemctl list-dependencies sshd --before`

Вывод
```
sshd.service
● ├─multi-user.target
○ │ ├─systemd-update-utmp-runlevel.service
● │ ├─graphical.target
○ │ │ ├─systemd-update-utmp-runlevel.service
○ │ │ └─shutdown.target
○ │ └─shutdown.target
○ └─shutdown.target
```

---

#### 4. Граф загрузки системы в формате SVG
Команда `systemd-analyze plot > startup_plot.svg`

## Часть 2. Управление юнитами

#### 1. Список всех запущенных юнит сервисов
Команда `systemctl list-units --type=service --state=running` - выводит все юниты, которые сейчас в памяти (напрямую или через зависимости)

Вывод
``` 
  UNIT                      LOAD   ACTIVE SUB     DESCRIPTION
  cron.service              loaded active running Regular background program processing daemon
  dbus.service              loaded active running D-Bus System Message Bus
  getty@tty1.service        loaded active running Getty on tty1
  getty@tty2.service        loaded active running Getty on tty2
  getty@tty3.service        loaded active running Getty on tty3
  getty@tty6.service        loaded active running Getty on tty6
  ssh.service               loaded active running OpenBSD Secure Shell server
  systemd-journald.service  loaded active running Journal Service
  systemd-logind.service    loaded active running User Login Management
  systemd-timesyncd.service loaded active running Network Time Synchronization
  systemd-udevd.service     loaded active running Rule-based Manager for Device Events and Files
  user@0.service            loaded active running User Manager for UID 0
  wpa_supplicant.service    loaded active running WPA supplicant

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
13 loaded units listed.
```

---

#### 2. Перечень юнитов сервисов с автозагрузкой
Команда `systemctl list-unit-files --type=service | grep "enabled"` - выводит все юниты в системе (в том числе и неактивные)

Вывод
```
UNIT FILE				STATE		PRESET
anacron.service                        enabled         enabled
apparmor.service                       enabled         enabled
bluetooth.service                      enabled         enabled
console-setup.service                  enabled         enabled
cron.service                           enabled         enabled
cryptdisks-early.service               masked          enabled
cryptdisks.service                     masked          enabled
e2scrub_reap.service                   enabled         enabled
getty@.service                         enabled         enabled
hwclock.service                        masked          enabled
ifupdown-wait-online.service           disabled        enabled
keyboard-setup.service                 enabled         enabled
networking.service                     enabled         enabled
nftables.service                       disabled        enabled
powertop.service                       disabled        enabled
rc.service                             masked          enabled
rcS.service                            masked          enabled
serial-getty@.service                  disabled        enabled
ssh.service                            enabled         enabled
sudo.service                           masked          enabled
systemd-fsck-root.service              enabled-runtime enabled
systemd-network-generator.service      disabled        enabled
systemd-networkd-wait-online@.service  disabled        enabled
systemd-networkd.service               disabled        enabled
systemd-pstore.service                 enabled         enabled
systemd-remount-fs.service             enabled-runtime enabled
systemd-sysext.service                 disabled        enabled
systemd-timesyncd.service              enabled         enabled
wpa_supplicant-nl80211@.service        disabled        enabled
wpa_supplicant-wired@.service          disabled        enabled
wpa_supplicant.service                 enabled         enabled
wpa_supplicant@.service                disabled        enabled
x11-common.service                     masked          enabled
```

---

#### 3. Юниты, от которых зависит sshd
Команда `systemctl list-dependencies sshd` - информация о всех необходимых юнитах, загруженных в память

Вывод
```
sshd.service
● ├─-.mount
● ├─system.slice
● └─sysinit.target
●   ├─apparmor.service
●   ├─dev-hugepages.mount
●   ├─dev-mqueue.mount
●   ├─keyboard-setup.service
●   ├─kmod-static-nodes.service
●   ├─proc-sys-fs-binfmt_misc.automount
●   ├─sys-fs-fuse-connections.mount
●   ├─sys-kernel-config.mount
●   ├─sys-kernel-debug.mount
●   ├─sys-kernel-tracing.mount
●   ├─systemd-ask-password-console.path
●   ├─systemd-binfmt.service
○   ├─systemd-firstboot.service
●   ├─systemd-journal-flush.service
●   ├─systemd-journald.service
○   ├─systemd-machine-id-commit.service
●   ├─systemd-modules-load.service
○   ├─systemd-pcrphase-sysinit.service
○   ├─systemd-pcrphase.service
○   ├─systemd-pstore.service
●   ├─systemd-random-seed.service
○   ├─systemd-repart.service
●   ├─systemd-sysctl.service
●   ├─systemd-sysusers.service
●   ├─systemd-timesyncd.service
●   ├─systemd-tmpfiles-setup-dev.service
●   ├─systemd-tmpfiles-setup.service
●   ├─systemd-udev-trigger.service
●   ├─systemd-udevd.service
●   ├─systemd-update-utmp.service
●   ├─cryptsetup.target
●   ├─integritysetup.target
●   ├─local-fs.target
●   │ ├─-.mount
○   │ ├─systemd-fsck-root.service
●   │ └─systemd-remount-fs.service
●   ├─swap.target
●   │ └─dev-disk-by\x2duuid-53b0ace9\x2d77d8\x2d476d\x2da359\x2dc1cc4d0002e6.swap
●   └─veritysetup.target
```
Юниты помеченные ○ - косвенно зависимые

---

#### 4. Определить, запущен ли сервис *cron*
Команда `systemctl is-active cron`, Результат: `active`

---

#### 5. Вывести все параметры юнита *cron* (даже те, которые были назначены автоматически)
Команда `systemctl show cron`

---

#### 6. Запретить автозагрузку *cron*, оставив возможность загружаться по зависимостям
Команда `systemctl disable cron`

---
