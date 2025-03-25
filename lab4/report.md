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
