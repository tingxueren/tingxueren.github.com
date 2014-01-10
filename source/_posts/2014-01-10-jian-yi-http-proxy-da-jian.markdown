---
layout: post
title: "简易http proxy搭建"
date: 2014-01-10 15:10
comments: true
categories: 
---

最近学校的网络超级的不爽，原来上下行都能达到几十M的网速被生生的限制为下行3M，上行0.3M不说而且屏蔽了很多网站，使用的手段相当的龌龊，直接在出口路由上将网站直接指向了127.0.0.1，十分的郁闷。我的迅雷会员算是废了，无法在线看视频了，WTF。

还好最近申请到了Windows Azure的试用名额，除了开着Boinc做WCG任务获取点XRP就是在闲着，就想着用这服务器搭建个http proxy脱离学校的魔掌，使用正常的网络。但是普通的http proxy无法访问那些“不存在”的网站，因此需要该http proxy自动的处理正常网站和被封锁网站之间的关系。基本的思路是做个路由表使得正常的网站走国内网络，“不存在”网站走国外的代理。

## 基本需求

### 硬件

国外vps一台（Digitalocean）

国内vps一台（Windows Azure）

上述两台服务器使用的都是ubuntu 12.04.3 LTS

### 软件

[shadowsocks](http://shadowsocks.org/1.4/index.html)

[obfsproxy](https://www.torproject.org/projects/obfsproxy.html.en)

privoxy

squid3

## 步骤

### shadowsocks和obfsproxy

在国外vps上运行shadowsocks和obfsproxy，shadowsocks提供socks代理服务，obfsproxy负责将流量进行混淆，使得代理更加的安全，不使用obfsproxy也可以。这两个软件的安装配置都比较简单，在各自的官方网站上都有详细的介绍。这样国外的vps上的工作已经做完了，重点在于国内vps上的配置。

国内vps上同样也要先安装shadowsocks和obfsproxy，不同的是国外安装的都是服务器版本，国内安装的都是客户端版本不要搞混淆了。配置好后国内的vps上就有了一个可以用的socks代理，通过这个代理可以访问自由世界的互联网，没有伟大的GFW的干扰了。但是很多的服务不支持socks代理，http代理支持的范围比较广泛，幸好socks代理转化为http代理还是比较容易的，使用privoxy就可以了。

### 安装privoxy

```
$ sudo apt-get install privoxy
```
privoxy的配置比较简单，只需要指定socks代理的端口和转化出来的http代理的端口就好，配置文件为`/etc/pvivoxy/config`,下面是简单的例子：
```
# /etc/privoxy/config

user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
actionsfile match-all.action
actionsfile default.action
#actionsfile block.action
filterfile default.filter
#filterfile user.filter
logfile logfile
forward-socks5 / 127.0.0.1:1234 . #socks代理的端口1234
listen-address *:5678             #转化的http代理端口5678
toggle 1
enable-remote-toggle 1
enable-remote-http-toggle 0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 5120
#connection-sharing 0
forwarded-connect-retries 3
accept-intercepted-requests 0
allow-cgi-request-crunching 0
activity-animation 1
split-large-forms 0
keep-alive-timeout 0
socket-timeout 120
handle-as-empty-doc-returns-ok 1
```
privoxy安装好后我们就有了一个http代理，这个代理可以自由的访问所有的网络，所有的请求都会转到国外的vps上执行然后将执行的结果回传，所有的流量都要在国外转一圈，这样访问国内的网站是很慢的，而且有些国内网站屏蔽了国内ip，这样的网络体验并不好。下一步骤就该squid大显身手的时候了，squid是一个代理和缓存服务器，可以指定规则使得不同的网络请求走不同的路径，还有缓存加速的功能，可以加速网络的访问，squid的安装比较简单。

### 安装squid

```
$ sudo apt-get install squid
```
squid的配置文件位于`/etc/squid3/squid.conf`,下面是我使用的配置，稍后我会简单的介绍下：

```
#代理服务器的监听端口
http_port 9999

##########################
 
cache_peer localhost parent 5678 0 no-query
# 默认走shadowsocks, 国内ip走国内
acl chinaip dst "/etc/squid3/chinaip"
always_direct allow chinaip
acl ALL src all
never_direct allow ALL

##########################

#内存缓冲区的大小
cache_mem 2048 MB
#设置硬盘缓冲区最大4096MB，16个一级目录，256个二级目录。
cache_dir ufs /var/spool/squid 4096 16 256
#设置访问日志文件
cache_access_log /var/log/squid3/access.log
#设置缓存日志文件
cache_log /var/log/squid3/cache.log
#设置网页缓存日志文件
cache_store_log /var/log/squid3/store.log
#定义允许名称为all的http请求。
http_access allow all
```

squid支持父代理，而且指定了父代理后默认的全部流量都从父代理走，由于GFW的威力日益强大，为了一劳永逸，配置中使用了比较暴力的手段，找出了所有的中国ip，将ip段放在`/etc/squid3/chinaip`这个文件中，使国内ip直连，国外ip都通过shadowsocks代理。虽然会使得有些未被墙掉的网站访问变慢，但是照着GFW这样疯狂的势头这个方案还是比较行得通的，不用蛋疼的手动添加被墙的网站了。

`/etc/squid3/chinaip`中的条目都是形如`192.168.1.0/24`或者`192.168.1.0/255.255.255.0`，每行一个网段，squid同时支持这两种网络的写法。获取国内的ip地址可以访问该[网站](https://code.google.com/p/chnroutes/),下载后的文件一般需要使用`sed、awd`等工具修改成满足squid需求的格式。这样就得到了一个全能的http proxy，国内国外网站随意遨游了。

## 参考资料
1. [简易 APN Proxy (APN代理）的搭建](http://bao3.blogspot.com/2012/01/apn-proxy-apn.html)
2. [简易apn代理搭建](https://www.fdb713.com/set-up-an-easy-apn-proxy/)
3. [GFWList 兼容 Squid](https://sorz.org/squid-blacklist/)
4. [Squid中文权威指南](http://home.arcor.de/pangj/squid/index.html)	
