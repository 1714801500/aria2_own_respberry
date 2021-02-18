#!/bin/env bash

#Auther: Wang Linbo
#Created Time: 2021/2/19
#Script DEscription: raspberry install aria2 script


######## 安装aria2 ###########

sudo apt-get update
sudo apt-get -y upgrade 

sudo apt install -y aria2 unzip git apache2

#配置

#下载
weget https://github.com/wanglinbo-z/aria2_own_respberry/archive/master.zip -O conf.zip

#解压

unzip conf.zip -d aria2

#将aria2放到/etc目录下

mv aria2 /etc

#设置Nginx开机启动

sudo stemctl enable nginx


######### END ###########

####### WEBUI #######

# 下载aira-ng

wget https://github.com/mayswind/AriaNg/releases/download/1.2.1/AriaNg-1.2.1.zip -O Aria.zip

# 解压g

unzip Aria.zip -d Aria

# 将aira-ng放到nginx的/var/www/html/目录下

mv Aria /var/www/html/

######### END ##########

######## 设置aria2c开机启动 ########

sudo vim /lib/systemd/system/aria2c.service  
echo "
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
" > /lib/systemd/system/aria2c.service

#重新载入systemctl服务添加启动项#

sudo systemctl daemon-reload

sudo systemctl enable aria2c

######### END ##########

####### 启动aria2 ########

aria2c --conf-path=/etc/aria2/aria2.conf 
