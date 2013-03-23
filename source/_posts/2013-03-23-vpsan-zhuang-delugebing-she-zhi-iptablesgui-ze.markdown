---
layout: post
title: "vps 安装 deluge 并设置 iptables 规则"
date: 2013-03-23 15:46
comments: true
categories: 
---

昨天 HDC 的下载网站终于恢复了，换了个马甲 [hdwing.com](www.hdwing.com) 重新开始提供 PT 服务。原有的 HDC 的数据都还在，网站也迁移到了美国感觉靠谱多了，至少不用担心莫名其妙的被拔网线的问题了。登陆后看了下，除了 logo 更换了，其他的都是那么的熟悉，看到了自己的数据都还在，顿时泪流满面。

## 下载工具
Windows 下没什么挑剔的，用 utorrent 就一切 ok。Linux 却要费一番思量，PT 网站支持的客户端还挺多的，有 ktorrent、rtorrent、transmission 和 deluge 等等。以前一直在用 ubuntu 自带的 transmission, 挺简洁也很小巧，但是悲剧的是从 ubuntu 12.04 起，transmission 升级到了2.77 版，HDC 支持的 transmission 最新也直到了 2.73 版，所以就悲剧了。deluge 貌似支持的到了最新的 1.3.5 版本了，所以就准备安装 deluge 作为下载工具了。
``` sh

$ sudo apt-get install deluged deluge-web
```
 执行上述的命令就安装好了，具体的如何设置的可以参见这篇 [blog](http://sunsea.im/deluge-config.html)。

## 设置 nginx 代理
deluge 安装后默认的在 8182 端口打开 web 服务，但是因为 vps 上已经安装上了 LNMP 环境，所以想用 nginx 将 8182 端口映射到 80 端口，减少端口暴露，同时也便于管理。本文参考了 [Seedbox配置实例](http://blog.dayanjia.com/2012/12/seedbox-configuration-example/) ,和 [deluge forum](http://forum.deluge-torrent.org/viewtopic.php?f=8&t=39329)。

### nginx 文件配置
``` sh
将下列配置写入 nginx 域名配置文件
server {
   ### server port and name ###
   listen            0.0.0.0:80;
   listen            [::]:80;
   server_name         your.domain.net;
   if ($host !~* ^(your.domain.net)$ ) { return 444; } #URL non matché par le domaine
   

   ### Compression ###
   gzip            on;
   gzip_static         on;
   gzip_buffers         32 8k;
   gzip_comp_level         3;
   gzip_http_version      1.1;
   gzip_types         text/css text/xml application/x-javascript application/atom+xml text/mathml text/plain t
ext/vnd.sun.j2me.app-descriptor text/vnd.wap.wml text/x-component image/x-ms-bmp image/svg+xml application/msword application/rt
f application/xml application/xhtml+xml application/xml+rss text/javascript application/javascript application/json;
   gzip_vary         on;

   location / {
      proxy_pass      http://localhost:8112/;
      proxy_next_upstream   error timeout invalid_header http_500 http_502 http_503;

      ### Set headers ####
      proxy_set_header   Host         $host;
      proxy_set_header   X-Real-IP      $remote_addr;
      proxy_set_header   X-Forwarded-For      $proxy_add_x_forwarded_for;

      ### By default we don't want to redirect it ####
      proxy_redirect      off;
   }

   location ~*^.+(ico|css|js|gif|jpe?g|png)$ {
                proxy_pass              http://localhost:8112;
      expires         max;

                proxy_next_upstream     error timeout invalid_header http_500 http_502 http_503;

                ### Set headers ####
                proxy_set_header        Host                    $host;
                proxy_set_header        X-Real-IP               $remote_addr;
                proxy_set_header        X-Forwarded-For         $proxy_add_x_forwarded_for;

                ### By default we don't want to redirect it ####
                proxy_redirect          off;
   }
}
```
通过上面的设置你可以通过 `http://your.domain.net` 来管理 deluge，和通过 `http:// your-ip:8112` 效果一致。

## iptables 设置
默认的情况 deluge 的 incoming ports 和 outgoing ports 都使用的是 random ports,也就是随机端口，这样无法使用 iptables 控制 vps 的访问，造成很大的安全漏洞。deluge 也提供了端口设置，默认的是 6881 到 6891，但是郁闷的是我将 6881-6891的端口的进出都在 iptables 规则中设置为了 accept，连接 pt 服务器的时候还是会显示 blocked, 来回的折腾，关掉/打开 iptables、重启 deluge、甚至最后重启 vps，都是一样的效果。搞了一下午无任何进展，然后突然我想起来是不是端口被服务商封锁了，将默认的端口从 6881-6891 设置为了 56800-56810,然后就工作正常了，WTF。
### iptables 规则
``` sh
iptables -A INPUT -p TCP --dport 56800:56810 -j ACCEPT
iptables -A INPUT -p UDP --dport 56800:56810 -j ACCEPT
iptables -A OUTPUT -p TCP --sport 56800:56810 -j ACCEPT
iptables -A OUTPUT -p UDP --sport 56800:56810 -j ACCEPT
```
经过了上面的设置，deluge 运行还是比较平稳的，占用的资源不是很多。vps 网速特别给力， 上传高峰可达到 5M/s，真是相当不错, 只是硬盘容量太小很遗憾啊。




