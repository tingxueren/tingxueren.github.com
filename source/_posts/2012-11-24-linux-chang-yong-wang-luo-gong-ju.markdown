---
layout: post
title: "Linux 常用网络工具"
date: 2012-11-24 18:22
comments: true
categories: 
---

既然享受了上网的便利，有时候就不得不忍受网络带来的痛苦。正上网看视频看的 high, 突然网页卡死了，刷新后网页都打不开，正聊 QQ 突然掉线了，想访问些国外网站发现输入域名后跳转到莫名其妙的网站，这时候你就要检查下自己的网络问题了。“工欲善其事，必先利其器”， Linux 下有很好用的网络工具，掌握了这些工具基本上就能找到网络出毛病的原因，自己动手修复了。

## 常用工具 

常用的工具一般有：ping、ifconfig、traceroute、nslookup、dig、whois、iftop、ntop等，下面简要介绍下

### ping 

ping 很简单，也是最常用的工具，常常用来测试网络是否联通，用法：ping ip/host 即可，Windows 下也用同样的命令 
``` sh
# 测试网络是否联通
$ ping  baidu.com
# 有时候 ping 的返回会很慢，这是因为 ping 会尽量将 ip 转化为域名，如果对应 ip 没有设置域名
# 解析的话会直到超时才返回，可以添加 -n 参数，让 ping 立即得到返回数据
$ ping -n 8.8.8.8

```

### ifconfig 

ifconfig 是用来查看本机网络的各种接口的， Windows 下对应命令为 ipconfig
``` sh
# 本机执行 ifconig
$ ifconfig
eth0      Link encap:Ethernet  HWaddr 8c:89:a5:39:**:**  
          inet addr:192.168.1.100  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::8e89:a5ff:fe39:5c96/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3591303 errors:0 dropped:10 overruns:0 frame:0
          TX packets:3219419 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3257148705 (3.2 GB)  TX bytes:448474566 (448.4 MB)
          Interrupt:43 Base address:0xe000 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:321987 errors:0 dropped:0 overruns:0 frame:0
          TX packets:321987 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:75444551 (75.4 MB)  TX bytes:75444551 (75.4 MB)

# MAC地址我做了注释，可以看到本机只用一个网卡 eth0，lo 为本地环回接口
# 本机 ip 为 192.168.1.100, 为一个私有地址，因为我的电脑是接在路由器下面的
# 其他参数可以 man ifconfig
```

### traceroute 

traceroute 是个路由跟踪命令，可以跟踪从本机到目标 ip 的具体路由过程，Windows 下对应的命令是 tracert
``` sh
# 本机跟踪到 baidu.com 的路由过程
$ traceroute baidu.com
traceroute to baidu.com (123.125.114.144), 30 hops max, 60 byte packets
 1  192.168.1.1 (192.168.1.1)  0.485 ms  1.117 ms  1.313 ms
 2  192.168.149.254 (192.168.149.254)  4.472 ms  4.754 ms  4.785 ms
 *
 *
 9  219.158.14.97 (219.158.14.97)  43.474 ms  43.522 ms  43.695 ms
10  123.126.0.66 (123.126.0.66)  47.145 ms  47.186 ms  47.248 ms
11  61.148.3.34 (61.148.3.34)  49.409 ms  49.523 ms  49.417 ms
12  202.106.43.66 (202.106.43.66)  39.283 ms 202.106.43.174 (202.106.43.174)  40.238 ms  40.661 ms
29  * * *
30  * * *

# 为了保密删除了开头的几条路径
# 有些路由禁止探测，比如第29, 30 跳
# 最多跳数为 30, 到了30 跳虽然还没有到 baidu.com 但是命令结束了
```

### nslookup 

nslookup 是用来查询 DNS 解析的，通过这个命令可以明显的看到 GFW 的常用手段 “DNS污染”。Windows 下的命令相同
``` sh
# 执行 nslookup 用国内 DNS 服务器
# 命令格式: nslookup 域名 DNS服务器
# 查询 twitter.com 通过国内DNS服务器
$ nslookup twitter.com  221.12.1.227 
Server:		221.12.1.227
Address:	221.12.1.227#53

Non-authoritative answer:
Name:	twitter.com
Address: 59.24.3.173
# 通过 whois 查询可知 59.24.3.173 是个韩国ip
# 挂上 vpn 通过 google dns 查询得到正确ip
$ nslookup twitter.com  8.8.8.8
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	twitter.com
Address: 199.59.150.39
Name:	twitter.com
Address: 199.59.149.230
Name:	twitter.com
Address: 199.59.148.10
```
### dig 

dig 命令和 nslookup 十分相似，也是用来进行 DNS查询的，命令格式也很简单 `dig @server host` 即可。
``` sh
# 我把我的另一个域名 tingxueren.info 指向了 tingxueren.github.com 在 github 上面维护了自己的blog，可以用
# dig 查询下，会发现 ip 一致
# dig tingxueren.info
$ dig @8.8.8.8 tingxueren.info

; <<>> DiG 9.8.1-P1 <<>> @8.8.8.8 tingxueren.info
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16481
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;tingxueren.info.		IN	A

;; ANSWER SECTION:
tingxueren.info.	1800	IN	A	204.232.175.78

;; Query time: 368 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Sat Nov 24 19:23:45 2012
;; MSG SIZE  rcvd: 49
# dig tingxueren.github.com
dig @8.8.8.8 tingxueren.github.com

; <<>> DiG 9.8.1-P1 <<>> @8.8.8.8 tingxueren.github.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 51234
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;tingxueren.github.com.		IN	A

;; ANSWER SECTION:
tingxueren.github.com.	43200	IN	A	204.232.175.78

;; Query time: 180 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Sat Nov 24 19:26:58 2012
;; MSG SIZE  rcvd: 55
```
### whois  
[WHOIS](http://zh.wikipedia.org/zh-cn/WHOIS)（读作“Who is”，而非缩写）是用来查询互联网中域名的IP以及所有者等信息的传输协议。上面才查找 twitter 的错误 ip 的时候已经用过了，现在把刚才信息贴出来。
``` sh
$ whois 59.24.3.173
# 韩文显示不正常，省略
# ENGLISH

KRNIC is not an ISP but a National Internet Registry similar to APNIC.

[ Network Information ]
IPv4 Address       : 59.0.0.0 - 59.31.255.255 (/11)
Service Name       : KORNET
Organization Name  : Korea Telecom
Organization ID    : ORG1600
Address            : 206, Jungja-dong, Bundang-gu, Sungnam-ci
Zip Code           : 463-711
Registration Date  : 20040831

[ Admin Contact Information ]
Name               : IP Administrator
Phone              : +82-2-500-6630
E-Mail             : kornet_ip@kt.com

[ Tech Contact Information ]
Name               : IP Manager
Phone              : +82-2-500-6630
E-Mail             : kornet_ip@kt.com

[ Network Abuse Contact Information ]
Name               : Network Abuse
Phone              : +82-2-100-0000
E-Mail             : abuse@kornet.net
# GFW 常常会把 “非法网站” 进行 DNS 投毒，解析到韩国的 ip，韩国是躺着也中枪
```
### iftop 和 ntop 
这两个工具是用来做流量监控的，iftop 比较简陋，提供的是字符界面，ntop 安装后可以在本机浏览器打开 3000 端口会有图形界面的，内容相当的详细。对这两个工具了解的不多，只是刚开始用，可以看下下面这两个帖子。
1. [Linux流量监控工具 - iftop (最全面的iftop教程)](http://www.vpser.net/manage/iftop.html)
2. [在RHEL5下使用NTOP监测网络流量](http://netslyz.blog.51cto.com/1006247/407510/)


