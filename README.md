# 云计算运维一个月通关计划
# Day 1: Centos 9 系统基础知识采集

1.**查看系统内核与版本**
- 命令：'uname -r'
- 我的输出: '5.14.0-708.el9.x86_64'
- 理解:这代表我正在使用的是5.14版本的Linux内核。

2.**查看操作系统信息**
- 命令： 'cat /etc/os-release'
- 我的输出： NAME="CentOS Stream"
VERSION="9"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="9"
PLATFORM_ID="platform:el9"
PRETTY_NAME="CentOS Stream 9"
ANSI_COLOR="0;31"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:centos:centos:9"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://issues.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 9"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
- 理解：这代表我使用的是centos strea 操作系统。

3.**查看IP地址**
- 命令： 'ip addr'
- 我的输出：''1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0c:29:a8:e2:23 brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 192.168.100.20/24 brd 192.168.100.255 scope global noprefixroute ens160
       valid_lft forever preferred_lft forever
    inet 192.168.100.130/24 brd 192.168.100.255 scope global secondary dynamic noprefixroute ens160
       valid_lft 1490sec preferred_lft 1490sec
    inet6 fe80::20c:29ff:fea8:e223/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0c:29:a8:e2:2d brd ff:ff:ff:ff:ff:ff
    altname enp11s0
    inet 192.168.109.133/24 brd 192.168.109.255 scope global dynamic noprefixroute ens192
       valid_lft 1251sec preferred_lft 1251sec
    inet6 fe80::20c:29ff:fea8:e22d/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
- 理解:lo是本地回环地址是127.0.0.1/8，仅主机的ip地址是192.168.100.20子网掩码是255.255.255.0，NAT的ip地址是动态分配的。

4.**查看内存使用情况**
-命令： 'free -h'
-我的输出： '               total        used        free      shared  buff/cache   available
Mem:           3.5Gi       1.1Gi       2.0Gi        21Mi       651Mi       2.4Gi
Swap:          3.9Gi          0B       3.9Gi'
-理解： -h 参数让容量以人类可读的 Gi/Mi 单位显示。在评估系统是否还有足够内存运行新服务时，不能看 free（完全未被分配的内存，当前仅 21Mi），而必须看 available（系统当前实际可提供给新进程使用的内存，当前有 2.4Gi）。这台机器目前内存非常充足。

5.**查看磁盘空间**
-命令： 'df -h'
-我的输出： ''文件系统             容量  已用  可用 已用% 挂载点
devtmpfs             1.8G     0  1.8G    0% /dev
tmpfs                1.8G     0  1.8G    0% /dev/shm
tmpfs                725M  9.7M  715M    2% /run
efivarfs             256K   55K  197K   22% /sys/firmware/efi/efivars
/dev/mapper/cs-root   35G  5.2G   30G   16% /
/dev/nvme0n1p2       960M  432M  529M   45% /boot
/dev/nvme0n1p1       599M  7.3M  592M    2% /boot/efi
tmpfs                363M   96K  363M    1% /run/user/1000
/dev/sr0              15G   15G     0  100% /run/media/qing/CentOS-Stream-9-BaseOS-x86_64

-理解： 核心关注挂载点为 /（根目录）的那一行。我当前的根目录所在分区是 /dev/mapper/cs-root，总容量 35G，已用 5.2G，使用了 16%。在日常运维中，如果这个挂载点的使用率超过 80%，就需要立刻通过 du -sh * 命令去寻找并清理大文件（通常是无用的旧日志）了

