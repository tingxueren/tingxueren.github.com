---
layout: post
title: use goagent for apt get
description: ""
category: 
tags: [goagent, apt-get, 代理]
---
{% include JB/setup %}
## 简介

goagent 干什么用的 我就不说了 安装百度有大把的教程，apt-get 在安装一些软件的话 如果要从国外下载 那么可以考虑使用这种方法，apt-get 设置代理的方法：

root@bt :~# export http_proxy=http://127.0.0.1:8087
设置完代理 再

root@bt :~# apt-get update && sudo apt-get install libreoffice

goagent 速度很快，我没使用 下载速度是 2k/s 收不鸟了 代理下后 速度 200k/s .。。
### 安装goagent

apt-get 设置代理的方法具体看下面的文章:

http://blog.163.com/fanning_7213/blog/static/24965052011026104010570/

想安个xchm看CHM的书，由于自己的机子网络有问题，本想自己下个包安装，没想到信赖包太多，最后只得做罢。

自己是通过代理上网的，到网上搜下了这篇文章，直接按第一种方法，然后sudo apt-get update ; sudo apt-get install xchm

### 可以通过三种方法为apt-get设置http代理
- 方法一: 这是一种临时的手段，如果您仅仅是暂时需要通过http代理使用apt-get，您可以使用这种方式。
在使用apt-get之前，在终端中输入以下命令（根据您的实际情况替换yourproxyaddress和proxyport）。
export http_proxy=http://yourproxyaddress:proxyport
- 方法二: 这种方法要用到/etc/apt/文件夹下的apt.conf文件。如果您希望apt-get（而不是其他应用程序）一直使用http代理，您可以使用这种方式。
注意： 某些情况下，系统安装过程中没有建立apt配置文件。下面的操作将视情况修改现有的配置文件或者新建配置文件。
gksudo gedit /etc/apt/apt.conf
在您的apt.conf文件中加入下面这行（根据你的实际情况替换yourproxyaddress和proxyport）。
Acquire::http::Proxy “http://yourproxyaddress:proxyport”;
保存apt.conf文件。
- 方法三: 这种方法会在您的主目录下的.bashrc文件中添加两行。如果您希望apt-get和其他应用程序如wget等都使用http代理，您可以使用这种方式。
gedit ~/.bashrc
在您的.bashrc文件末尾添加如下内容（根据你的实际情况替换yourproxyaddress和proxyport）。
http_proxy=http://yourproxyaddress:proxyport
export http_proxy
保存文件。关闭当前终端，然後打开另一个终端。
### 测试
使用apt-get update或者任何您想用的网络工具测试代理。我使用firestarter查看活动的网络连接。
如果您为了纠正错误而再次修改了配置文件，记得关闭终端并重新打开，否自新的设置不会生效。
代理服务器的登录
如果代理服务器需要登录，那么可以在指定代理服务器地址的时候，用如下格式（根据情况把username，password， yourproxyaddress和proxyport替换为相应内容）：
http_proxy=http://username:password@yourproxyaddress:proxyport
