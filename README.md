# 树莓派如何安装配置Aria2

## 一、前言

> **Aria2是一款非常好用的下载器，它可以在任意平台上搭建运行，并支持多线程、BT、磁力、断点续传。**

## 二、安装

### 1、更新软件库

```shell
sudo apt-get update
sudo apt-get -y upgrude
```

2、安装Aria2

```shell
sudo apt-get install -y aria2
```

## 三、配置

### 1、创建配置文件

```shell
sudo mkdir /etc/aria2
sudo vim /etc/aria2/aria2.conf #点击i进入插入模式；冒号+w+q保存并退出
```

### 2、编写配置文件

#### 在/etc/aria2/aria2.conf中粘贴下面代码：

```shell
dir=/home/username/Downloads #注意username使用自己的用户名
# 启用磁盘缓存, 0为禁用缓存, 需1.16以上版本, 默认:16M disk-cache=32M 文件预分配方式, 能有效降低磁盘碎片, 
#默认:prealloc 预分配所需时间: none < falloc ? trunc < prealloc falloc和trunc则需要文件系统和内核支持 
#NTFS建议使用falloc, EXT3/4建议trunc, MAC 下需要注释此项 file-allocation=trunc
continue=true
## 下载连接相关 ##
# 最大同时下载任务数, 运行时可修改, 默认:5
max-concurrent-downloads=5
# 同一服务器连接数, 添加时可指定, 默认:1
max-connection-per-server=16
# 最小文件分片大小, 添加时可指定, 取值范围1M -1024M, 默认:20M 假定size=10M, 文件为20MiB 则使用两个来源下载; 
# 文件为15MiB 则使用一个来源下载
min-split-size=10M
# 单个任务最大线程数, 添加时可指定, 默认:5
split=5
# 整体下载速度限制, 运行时可修改, 默认:0 max-overall-download-limit=0 单个任务下载速度限制, 默认:0 
#max-download-limit=0
# 整体上传速度限制, 运行时可修改, 默认:0
max-overall-upload-limit=10K
# 单个任务上传速度限制, 默认:0
max-upload-limit=20
# 禁用IPv6, 默认:false
disable-ipv6=true
## 进度保存相关 ##
# 从会话文件中读取下载任务
input-file=/etc/aria2/aria2.session
# 在Aria2退出时保存`错误/未完成`的下载任务到会话文件
save-session=/etc/aria2/aria2.session
# 定时保存会话, 0为退出时才保存, 需1.16.1以上版本, 默认:0 save-session-interval=60
## RPC相关设置 ##
# 启用RPC, 默认:false
enable-rpc=true
# 允许所有来源, 默认:false
rpc-allow-origin-all=true
# 允许非外部访问, 默认:false
rpc-listen-all=true
# 事件轮询方式, 取值:[epoll, kqueue, port, poll, select], 不同系统默认值不同 event-poll=select RPC监听端口, 
#端口被占用时可以修改, 默认:6800 
rpc-listen-port=6800
# 设置的RPC授权令牌, v1.18.4新增功能, 取代 --rpc-user 和 --rpc-passwd 选项
rpc-secret=513568
# 设置的RPC访问用户名, 此选项新版已废弃, 建议改用 --rpc-secret 选项 rpc-user=<USER> 设置的RPC访问密码, 
#此选项新版已废弃, 建议改用 --rpc-secret 选项 rpc-passwd=<PASSWD>
## BT/PT下载相关 ##
# 当下载的是一个种子(以.torrent结尾)时, 自动开始BT任务, 默认:true follow-torrent=true BT监听端口, 
# 当端口被屏蔽时使用, 默认:6881-6999
listen-port=51413
# 单个种子最大连接数, 默认:55 bt-max-peers=55 打开DHT功能, PT需要禁用, 默认:true enable-dht=false 打开IPv6 
# DHT功能, PT需要禁用
enable-dht6=false
# DHT网络监听端口, 默认:6881-6999 dht-listen-port=6881-6999 本地节点查找, PT需要禁用, 默认:false 
#bt-enable-lpd=false
# 种子交换, PT需要禁用, 默认:true
enable-peer-exchange=false
# 每个种子限速, 对少种的PT很有用, 默认:50K bt-request-peer-speed-limit=50K 客户端伪装, PT需要 
#peer-id-prefix=-TR2770- user-agent=Transmission/2.77
# 当种子的分享率达到这个数时, 自动停止做种, 0为一直做种, 默认:1.0 seed-ratio=0 强制保存会话, 话即使任务已经完成, 
#默认:false 较新的版本开启后会在任务完成后依然保留.aria2文件 force-save=false
# BT校验相关, 默认:true bt-hash-check-seed=true 继续之前的BT任务时, 无需再次校验, 默认:false
bt-seed-unverified=true
# 保存磁力链接元数据为种子文件(.torrent文件), 默认:false
bt-save-metadata=true
```

### 3、创建会话日志文件

```shell
sudo vim /etc/aria2/aria2.session
```

### 4、测试文件

```shell
aria2c --conf-path=/etc/aria2/aria2.conf #启动Aria2
# Ctrl+C退出
```

## 四、添加WEB管理页

### 1、安装Nginx or  Apache2

```shell
sudo apt-get install nginx 
#或者
sudo apt-get install apache2
```

### 2、下载webUI

> 互联网上有许多开发者设计的开源webUI
>
> 如：Aria-NG、WebUI-aria、YAAW、Glutton 等等。
>
> 这里推荐并用Aria-NG做演示。

```shell
# 下载aira-ng
wget https://github.com/mayswind/AriaNg/releases/download/1.2.1/AriaNg-1.2.1.zip -O Aria.zip
# 解压g
unzip Aria.zip -d Aria
# 将aira-ng放到nginx的/var/www/html/目录下
mv Aria /var/www/html/
#设置Nginx开机启动
sudo stemctl enable nginx
```

#### 以下是其他UI的下载主页

```
YAAW:
下载地址: https://github.com/binux/yaaw
Glutton:
下载地址: https://github.com/NemoAlex/glutton
```

#### 在同局域网下，浏览器输入http://Pi-ip/Aria即可进入Aria2管理届面。

## 五、设置开机启动

### 1、创建aria2c的service服务

```shell
sudo vim /lib/systemd/system/aria2c.service
```

***插入以下代码***：

```shell
[Unit]
 Description=Aria2c download manager
 Requires=network.target
 After=dhcpcd.service
    
 [Service]
 Type=forking
 #默认用户
 User=pi 
 RemainAfterExit=yes
 ExecStart=/usr/bin/aria2c --conf-path=/etc/aria2/aria2.conf -D
 ExecReload=/usr/bin/kill -HUP $MAINPID
 RestartSec=1min
 Restart=on-failure
    
 [Install]
 WantedBy=multi-user.target
```

**2、重新载入systemctl服务添加启动项：**

```shell
sudo systemctl daemon-reload
sudo systemctl enable aria2c
```

### 3、最后重启

```shell
sudo reboot #重新启动
```

