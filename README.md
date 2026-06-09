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

4.Shell 脚本与 con 自动化定时任务
-**实战**：编写 ‘sys_check.sh’提取内存与核心数据。
-**排错要点**：配置‘crontab -e’时，脚本路径要使用绝对路径，并通过“>>”将标准输出和错误输出(2>&1)

5.*** 跨机自动化集群搭建（Ansible 实战）
- **架构设计**：采用标准的主从架构（Master-Node）。控制节点负责发送指令，被控节点负责执行。
- **底层凭证**：使用‘ssh-keygen -t ed25519’生成高强度密钥，并通过 ‘ssh-copy-id’推送公钥，打通SSH免密登录的通道。
- **Ansible 集结**：编写‘hosts.ini’资产清单，使用‘ansible -i hosts.ini webservers -m ping’成功验证集群连通性。
- **Ad-Hoc 临时命令**：使用‘command’模块（例如：‘ansible ... -m command -a "free -h"’）成功实现跨服务器的批量信息采集与系统控制。

6.Ansible Playbook 剧本编写与幂等性实战
- **核心理念**：基础设施即代码 (IaC)。通过编写 YAML 格式的剧本，实现复杂部署流程的固化与复用。
- **YAML 语法铁律**：严格使用空格进行层级缩进，绝对禁止使用 Tab 键。
- **实战部署**：编写 `install_nginx.yml`。
  1. 使用 `dnf` 模块自动化安装 Nginx。
  2. 使用 `systemd` 模块配置开机自启 (`enabled: yes`) 并拉起服务。
  3. 使用 `firewalld` 模块全自动放行 HTTP 流量，并通过 `immediate: yes` 实现规则的热重载。
- **企业级特性理解（幂等性 Idempotency）**：重复执行同一个 Playbook，Ansible 会自动对比系统当前状态与期望状态，只执行有差异的部分（变更为黄色的 changed，无需变更则为绿色的 ok），保证系统安全与稳定。

7.Nginx 非标准端口迁移与 SElinux 排障复盘
.1.排障误区
- **日志参数错位**：使用 `journalctl` 查看特定服务日志时，带有参数值（如 `-u 服务名`）的选项必须放在最后。错误写法：`-xue`（系统会把 e 当作服务名）。正确写法：`-xeu nginx.service`。
- **盲目杀进程**：当服务启动失败时（`exited with error code`），代表进程根本不存在。此时使用 `ps -ef | grep` 只能抓取到 `grep` 命令本身。严禁对着空气执行 `kill -9`，更不能直接在 `kill` 后加程序名（必须接 PID）。

2. Web 服务排障标准流程
当 Nginx 启动失败时，严格遵守以下排查顺序：
1. **语法检查**：优先执行 `sudo nginx -t`。如果是修改配置文件导致的标点符号、空格遗漏，它会精准定位到报错行数。
2. **底层日志捕捉**：如果 `nginx -t` 显示 `syntax is ok` 但服务依然起不来，执行 `sudo journalctl -xeu nginx.service` 查看内核与系统级拦截日志。

3. SELinux 安全策略拦截与突破
- **故障现象**：Nginx 语法正确，但启动失败。`journalctl` 日志中出现 `bind() to 0.0.0.0:8088 failed (13: Permission denied)`。
- **根本原因**：CentOS 9 默认启用 SELinux。其安全策略的白名单中，HTTP 服务默认只允许绑定 80、443 等常规端口。修改为非标准端口（如 8088）会在系统内核层被直接阻断。
- **解决步骤（严禁直接关闭 SELinux）**：
  1. 安装 SELinux 管理工具：`sudo dnf install policycoreutils-python-utils -y`
  2. 将新端口加入 HTTP 白名单：`sudo semanage port -a -t http_port_t -p tcp 8088`
  3. 重启服务生效：`sudo systemctl restart nginx`

4. Firewall 针对非标准端口的放行策略
- 当服务不使用标准端口时，防火墙放行不能再使用服务名（`--add-service=http`），必须精确放行端口号加协议：
  `sudo firewall-cmd --permanent --add-port=8088/tcp`
  `sudo firewall-cmd --reload`

8. Ansible 多模块复合剧本与系统日志高级过滤

1. 高级日志过滤与多行截断排障
- **核心经验**：在生产环境中，使用 `journalctl -n 15` 容易被突发的系统高频日志冲掉真正报错，或由于单行过长导致关键死因被 `>` 截断。
- **最佳实践**：必须结合管道符与 `grep` 进行关键字狙击。例如：`sudo journalctl | grep 服务名`，可以跨越时间限制，精准剥离出如 `Unit not found` 等核心线索。

2. Ansible 批量文件分发与定时任务闭环管理
- **资产下发 (`copy` 模块)**：通过 `src` 和 `dest` 实现文件的跨服务器推送。必须配合 `mode: '0755'` 参数，在推送到远程的同时赋予执行权限，否则脚本无法后台运转。
- **账本托管 (`cron` 模块)**：通过定义唯一的 `name` 参数，实现定时任务的幂等性管理。Ansible 会以此名字在被控端生成标识，避免重复写入对原有 crontab 造成破坏。

9.Docker 容器化起航与网络穿透特性

1. 运行首个容器 (Nginx)
- **命令语法**：`docker run -d -p 8080:80 --name my_first_container nginx`
- **核心参数解析**：
  - `-d`：后台静默运行 (detach)。
  - `-p 宿主机端口:容器内端口`：端口映射，将宿主机流量转发至容器内部。

2. 企业级警示：Docker 与 Firewalld 的冲突
- **现象记录**：在未配置 `firewall-cmd` 放行 8080 端口的情况下，通过 Docker 映射的 8080 端口依然可以直接从外部访问。
- **底层原理**：Docker 守护进程在启动端口映射时，会**直接修改内核底层的 iptables 规则**，从而绕过上层的 firewalld 限制。
- **运维规范**：在生产环境中暴露 Docker 端口时必须极其谨慎，切勿过度依赖 firewalld 进行容器层面的安全防护。

10.Infrastructure as Code - Dockerfile 定制专属镜像
1. 核心理念与价值
从传统的“基于宿主机挂载目录 (`-v`)” 进化为 “将环境与代码整体打包”。通过 Dockerfile，实现真正的“一次构建，到处运行”，彻底消除环境差异导致的部署故障。

2. 标准造箱流水线
- **编写图纸 (Dockerfile)**：
  - `FROM` 指令：定义基础环境底座（如 `nginx:latest`）。
  - `COPY` 指令：将宿主机本地代码（货物）精准注入到镜像内部路径。
- **启动机床 (Build)**：
  `sudo docker build -t ernestine-web:v1 .`
  *(注意：命令末尾的 `.` 代表构建上下文路径为当前目录，极其关键。)*
- **独立运行**：
  `sudo docker run -d -p 8081:80 --name my_custom_website ernestine-web:v1`

11.Ansible 跨主机 Docker 自动化编排与 SSH 权限陷阱复盘

1. 跨主机容器编排架构
- **核心逻辑**：利用 Ansible 的 `command` 或 `shell` 模块，将宿主机（控制端）的编排指令跨越网络下发至被控端，直接调度远端的 Docker 引擎。
- **实战命令**：在剧本中通过 `command: docker run -d -p 9090:80 --name remote_nginx nginx` 实现了在被控端全自动拉起标准集装箱。

2. 经典大坑：Sudo 隐式触发的 SSH 认证失败 (UNREACHABLE)
- **故障现象**：执行剧本时满屏报红，提示 `UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: root@192.168.100.10: Permission denied..."}`。
- **根本原因**：
  - 在控制端错误地使用了 `sudo ansible-playbook ...`。
  - 当加上 `sudo` 时，Ansible 进程在本地以 `root` 身份运行，从而默认会以 `root@目标IP` 的身份去尝试 SSH 远程连接。
  - 现代企业级 Linux（如 CentOS 9）的安全策略中，默认通过 `/etc/ssh/sshd_config` 中的 `PermitRootLogin no` **禁止了 root 用户直接进行远端 SSH 登录**，导致连接被坚决拒绝。
- **正确规范（提权最佳实践）**：
  1. **大门留给普通用户**：不加 `sudo`，让 Ansible 默认以普通用户（如 `qing`）的身份建立 SSH 免密通道进入目标机。
  2. **进门内部提权**：进入目标机后，依靠剧本内部声明的 `become: yes` 结合外部输入的提权密码参数（`-K`），在系统内部临时切换至 root 权限干活。

12.Docker Compose 多容器集群编排与 IaC 实践

1. 核心价值
解决单体容器 (docker run) 无法高效管理多组件复杂依赖的痛点。通过声明式的 YAML 文件，一键完成多容器的拉取、网络打通、挂载配置及启动顺序控制。

2. Compose 剧本 (docker-compose.yml) 核心语法
- `services`: 定义集群中包含的各个集装箱模块（如 Web 前端、DB 后端）。
- `environment`: 注入容器所需的系统环境变量（如数据库的账号密码）。
- `depends_on`: 声明启动顺序优先级，避免业务端因数据库未就绪而崩溃。
- `networks` & `volumes`: 自动在底层构建隔离的局域网与持久化数据通道。

3. 舰队调度指令
- `sudo docker compose up -d`：读取图纸，后台一键拉起整个集群。
- `sudo docker compose ps`：检阅当前目录下集群的运行状态。
- `sudo docker compose down`：一键摧毁集群容器及网络（但通过 volumes 挂载的数据会安全保留）。


> **核心心法**：拒绝死记硬背枯燥的英文报错，用工具精准“切”出关键指标。
> **排错三板斧**：一查网络通不通，二查资源满不满，三查日志报啥错。

13. 进程与资源监控（服务器累不累）

当系统卡顿、容器无故崩溃时，优先排查资源占用。

| 诊断目标 | 实操命令 | 核心盯防指标与避坑要点 |
| :--- | :--- | :--- |
| **内存剩余可用** | `free -m` | 绝不能只看 `free`，必须死死盯住 **`available`**（真实可用）。只要它还有数值，系统就不会崩。 |
| **磁盘空间占用** | `df -h` | 盯住挂载点为 `/`（根目录）行的 **`Use%`**。超过 85% 必须告警并清理日志。 |
| **高占用内鬼抓捕** | `top` | 动态查看 `%CPU` 和 `%MEM` 列，找出霸占资源的具体进程。按 `q` 退出。 |
| **底层服务状态** | `systemctl status 服务名` | 如查 Docker 状态。看 `Active` 是否为绿色 `running`，若为红色 `failed`，直击下方错误日志。 |

---

14. 网络与端口排查（门通没通，被谁占了）

部署新项目（如 WordPress、Nginx）启动失败，或者网页打不开时使用。

| 诊断目标 | 实操命令 | 核心盯防指标与避坑要点 |
| :--- | :--- | :--- |
| **全局端口巡检** | `ss -tulnp` | 速度极快。看 `Local Address:Port` 和最右侧 `pid=xxx`。 |
| **抓捕特定端口占用** | `lsof -i:端口号` | 极其精准（如查 80 端口）。直接输出占用该端口的进程号 `PID`。 |
| **探测对方服务死活** | `nc -vz IP 端口` | 验证特定端口（如 3306 数据库）是否开放。返回 `succeeded!` / `Connected` 为通，`refused` 为防火墙拦截。 |
| **强行释放端口** | `kill -9 PID` | 拿到进程号后直接击杀。**警告：确认是非核心业务后再杀。** |

---

15. 磁盘 I/O 高级排错（隐藏的性能杀手）

当 CPU 和内存充裕，但系统依然响应极慢时，大概率是硬盘读写（I/O）卡死。

* **看大盘（抓瓶颈）：**
  * **命令：** `iostat -dx 1`
  * **怎么看：** 死死盯住 `vda`（系统盘）行的最右侧 **`%util`**。低于 80% 健康，逼近 100% 说明磁盘通道已完全堵死。按 `Ctrl+C` 退出。
* **抓内鬼（查谁在写）：**
  * **命令：** `iotop -o`
  * **怎么看：** 类似 top，重点看谁的 `DISK WRITE` 飙得最高。按 `q` 退出。

---

16. 日志分析三剑客（无视大段英文）

利用管道符 `|`，将前置命令的输出作为后置命令的输入，层层过滤。

1. **`grep`（找错小能手）**
   * `cat app.log | grep -i "error"` ：忽略大小写，挑出所有报错行，过滤掉正常日志。
2. **`awk`（精准切分器）**
   * `grep "Failed" secure.log | awk '{print $11}'` ：按空格切分，精准提取目标数据（如第11列的黑客 IP）。
3. **`sed`（批量魔术师）**
   * `sed -i 's/8080/80/g' nginx.conf` ：不打开文件，直接在后台将所有 8080 端口替换为 80。


17.502 报错与磁盘打满

**故障场景**：网站突然打不开，报错 `502 Bad Gateway` 或请求一直在转圈。
**底层逻辑**：当硬盘 `Use%` 达到 100% 时，系统和数据库无法再写入任何临时文件或日志，导致程序瞬间假死崩溃，并引发极高的磁盘 I/O 拥堵。

第一步：排查大盘（锁定磁盘元凶）
1. `df -h` ：重点看根目录 `/` 的 `Use%` 是否达到 100%。
2. `iostat -dx 1` ：重点看 `vda` 磁盘的 `%util` 是否达到 100%（即磁盘通道因疯狂写入被彻底卡死）。
*(注：排查时也要顺手看一眼 `free -m` 和 `top`，确保不是内存耗尽或 CPU 跑满引发的故障。)*

d第二步：精准定位（揪出巨型垃圾文件）
当确认是磁盘满了之后，使用以下命令找内鬼：

* **命令A：找单体大文件**
  find / -type f -size +500M
****命令B： 查臃肿的文件夹
  du -sh /*
统计根目录下第一层各个文件夹的总大小。如果发现 /var 特别大，继续执行 du -sh /var/* 顺藤摸瓜，直到找出占用空间最大的子目录。
** 清空方法：echo "" > /路径/到/那个巨大的日志文件.log

18.CentOS 9 底层部署 Nginx 与 MySQL 8.0

**测试环境**：腾讯云 4C4G 轻量应用服务器 (公网直连，无 NAT 转换)
**操作系统**：CentOS 9
**部署方式**：包管理器 (dnf) 纯手工底层安装

模块一：Nginx 反向代理网关部署

1. 核心安装与控制指令
使用包管理器安装 Nginx (-y 自动确认)
sudo dnf install nginx -y

启动 Nginx 并设置开机自启 (一条命令打通)
sudo systemctl enable --now nginx

检查运行状态 (寻找 active running 绿字)
sudo systemctl status nginx

2. 目录结构与底层架构解密
默认网页存放路径 (胃)：/usr/share/nginx/html/

实战操作：使用 echo "<h1>Hello Server</h1>" > /usr/share/nginx/html/index.html 可直接覆盖默认网页进行快速测试。

核心配置文件路径 (大脑)：/etc/nginx/nginx.conf

严禁直接大改主配置文件！主配置中通过 include /etc/nginx/conf.d/*.conf; 实现了配置解耦。

企业规范做法：在 conf.d/ 目录下为每个新网站创建独立的 .conf 文件。

模块二：MySQL 8.0 关系型数据库底层铸造
1. 安装与守护进程唤醒
安装 MySQL 服务端
sudo dnf install mysql-server -y

唤醒 MySQL 守护大老板 (注意末尾的 d)
sudo systemctl enable --now mysqld

2. 核心大闸：纯命令行安全加固向导
刚装好的 MySQL 无密码且存在漏洞，必须立刻执行安全初始化：
sudo mysql_secure_installation

3. 控制台登录与基础 SQL
Bash
以 root 身份登录，并请求输入密码
mysql -u root -p

【SQL 实战】查看当前系统核心数据库 (务必加分号！)
mysql> show databases;

安全退出数据库控制台
mysql> exit;

4.**实战场景**：为了保障服务器数据安全，绝不能在代码中直接暴露 root 超级管理员密码。必须为每个独立的业务系统开辟专属的“小金库”，并配备权限严格受限的“专属业务账号”。

核心操作流（DBA 标准规范）

1. 以最高指挥官身份登舰
使用 root 账号登录 MySQL
mysql -u root -p

2. 开辟专属业务金库 (创建数据库)
企业级规范：必须指定兼容全球字符和 Emoji 的 utf8mb4 字符集，防止未来业务出现中文乱码。
CREATE DATABASE app_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

3. 招募专属业务员 (创建普通账号)
企业安全红线：限制账号只能从服务器本地 (localhost) 登录，彻底切断公网直连的被黑风险。

4.颁发专属钥匙 (权限下放与授权)
将 app_db 的所有操作权限授予该业务账号。

排错避坑笔记：
SQL 语法极其严格，务必注意单词拼写，切勿将 GRANT (授予) 误敲为 CRANT，否则会引发 ERROR 1064 (42000) SQL syntax 语法报错。
若敲击中途漏掉分号导致出现 -> 提示符，可使用 Ctrl + C 强制中断当前错误输入。
正确的授权指令
GRANT ALL PRIVILEGES ON app_db.* TO 'app_user'@'localhost';

刷新系统权限表，使授权立刻生效！(极其重要)
FLUSH PRIVILEGES;

5. 安全撤离与权限验证
退出 root 身份
mysql> exit;

模拟业务代码，使用新账号重新登录验证
mysql -u app_user -p

查看当前视野内的数据库
mysql> show databases;

19.CentOS 9 底层部署 Redis 极速缓存与安全加固

**实战场景**：为缓解 MySQL 数据库的并发读写压力，在服务器底层部署 Redis 纯内存缓存引擎。为防止沦为公网“肉鸡”，必须通过修改底层配置实现严格的鉴权与网络隔离。

核心操作流

1. 底层安装与引擎点火
使用包管理器极速安装
sudo dnf install redis -y

唤醒守护进程并写入开机启动项
sudo systemctl enable --now redis

2. 核心大闸：企业级安全加固 (vi 高阶搜索实战)
默认安装的 Redis 处于极其危险的无密码状态，必须深潜入 /etc/redis.conf 进行加固。
sudo vi /etc/redis.conf

vi 搜索脱困绝技：

输入 /requirepass 开启全局搜索。

遇到大量 # If the master is... 等官方说明文档干扰时，果断按 n 键 (next) 跳跃匹配，直到锁定真正的配置项 # requirepass foobared。

核心修改动作：

上锁：按 i 删掉 # 解除注释，将密码替换为强密码（如 requirepass Redis@2026）。

断网：搜索并确认 bind 127.0.0.1 存在，死守网络边界，彻底切断公网直连的可能。

3. 重启生效与鉴权测试
踢醒系统管家，重新加载配置
sudo systemctl restart redis

踏入控制台
redis-cli

鉴权拦截测试：直接敲击 ping，触发 (error) NOAUTH Authentication required. 报错，验证防盗锁生效。

合法授权通行：
127.0.0.1:6379> auth 你的密码
  OK
  127.0.0.1:6379> ping
  PONG
