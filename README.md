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

6.**查看设备状态（Device）**
-命令： nmcli device status
-我的输出：DEVICE  TYPE      STATE         CONNECTION 
ens192  ethernet  已连接        ens192     
ens160  ethernet  已连接        ens160     
lo      loopback  连接（外部）  lo 
-理解：这条命令是用来检测底层的物理网卡，现在有三块儿网卡

7.**查看连接状态**
- 命令：'nmcli connection show'
- 我的输出：NAME    UUID                                  TYPE      DEVICE 
ens192  200f934a-4e77-3c47-8989-2470902617f9  ethernet  ens192 
ens160  9bba0e7a-2a2c-3cc7-8605-741bdcd53837  ethernet  ens160 
lo      a5ed8ef2-996b-41ea-bba4-783efb16f9f8  loopback  lo 
- 理解： 已经有了两块物理网卡和一块虚拟网卡的配置信息文件

8.**配置网卡信息**
- 命令： 'nmcli connection modify ens160 ipv4.method manual ipv4.addresses 192.168.100.20/24 autoconnect yes ipv4.gateway ""'
- 我的输出：
-理解： 配置修改网卡ens160为静态IP并手动配置IP设置开机自启并把网关设为空

9.**重启网卡**
- 命令： nmcli connection up ens160
- 我的输出：
- 理解：重启ens160使其配置生效。

10.**查看服务状态**
- 命令： systemctl status nginx
- 我的输出：
- 理解： 用来查看服务的状态

11.**启动服务**
- 命令： systemctl start nginx
- 我的输出：
- 理解： 用于启动服务

12.**设置开机自启动**
- 命令： systemctl enable nginx
- 我的输出：
- 理解：让服务在以后的开机时自启动

13.**关闭开机自启动**
- 命令： systemctl disable nginx
- 我的输出：
- 理解：关闭服务的开机自启动

### Day 2: Nginx 服务与 Firewall 防火墙排障实战
1. **接管与验证系统服务 (systemd)**
   - 启动并设置开机自启：`sudo systemctl start nginx` / `sudo systemctl enable nginx`
   - 端口监听检查：`ss -tulnp | grep 80` (查看到 0.0.0.0:80 处于 LISTEN 状态，代表服务内部运行正常)

2. **故障排查：Nginx 启动正常但浏览器访问超时**
   - **故障现象**：终端显示服务运行正常，但宿主机浏览器访问静态 IP 时提示 `ERR_CONNECTION_TIMED_OUT`。
   - **排错逻辑**：服务在虚拟机内部正常监听，但外部请求进不来，果断判定为 CentOS 9 默认的防火墙 (`firewalld`) 拦截了流量。
   - **解决步骤**：
     1. `sudo firewall-cmd --state` (确认防火墙正在运行)
     2. `sudo firewall-cmd --permanent --add-service=http` (永久放行 80 端口的 Web 流量)
     3. `sudo firewall-cmd --reload` (平滑重载，使规则生效)
     4. `sudo firewall-cmd --list-all` (复核规则，确认 services 中已包含 http)
   - **结果**：重新刷新浏览器，成功看到 Nginx 默认欢迎页。

3. Nginx 日志监控与 HTTP 状态码分析
--**实战操作**：使用‘tail -f /var/log/nginx/access。log’实时监控外部访问流量。
--**系统级排错**：使用‘journalctl -u nginx -e’查看服务器底层的最新运行日志。
-**理解**：
    -状态码 ‘200’:请求访问成功，服务端正常交货。
    -状态码 ’404‘：基础设施（网络，防火墙，web服务）100%正常，但客户端请求的文件或页面服务器端不存在。
