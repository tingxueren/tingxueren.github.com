---
layout: post
title: "折腾vps手记"
date: 2012-10-20 18:55
comments: true
categories: 
---

前几天闲逛网页发现了个网站上介绍的一个美国 vps 首月免费，兴冲冲的去注册，把玩了一个下午。环境什么都配置好的时候突然发现登陆不上了，然后就收到了邮件，只提供 3 个小时的免费试用时间，然后我的 vps 就被删除了。靠他大爷的，郁闷了，气的都要吐血了。

一怒之下准备花钱买个 vps 好好玩玩的，linode 是首选，但是因为是穷学生，没米，而且也没有信用卡，玩不起啊。正好逛逛 G+ 发现有人买了个日本的 vps， 配置还可以，关键是还很便宜，很对胃口，还支持支付宝，真是大大的良心啊。下单，买了一个，5 分钟后就可以 ssh 登陆了，确实很快速。

vps 配置还可以，虽然是 openVZ 的架构，但是保证有 512M 的内存，最大 1G 的内存, 10G 硬盘，100M 网络，流量限，感觉基本上够用了。只要 490 日元， 淘宝支付 39 大洋，还是挺好的，延迟也能接受，实验室基本上是 100ms， 宿舍的话 200ms，都能接受。

## 初始化配置

vps 开通后，就要开始进行配置了。我选择的系统是 ubuntu 10.04, 毕竟用 ubuntu 桌面版很长一段时间了，前几个月也在实验室的旧机器配置过 ubuntu server ，我相信这个系统我还是能搞定的。拿到 vps 的时候想把它升级到 12.04, 换日本的源，然后升级，最后升级完成后重启 vps 一直卡死了。没有办法只得到网页的控制面板将 vps 重置了。查找了下资料发现 openVZ 的内核和 host 的内核要一样的，如果服务商不支持高版本的系统的话 vps 是不能升级到高版本的，那就这样吧，10.04 继续用吧。

 * 新建帐号
   
vps 开通的时候只有 root 帐号，一直用 root 帐号的话会不安全的，也没有必要，首先就要建立自己的常用帐号。可以使用以下命令：

        # 建立 you_name 帐号，并加入 sudo 组    
        # useradd  -G sudo -d /home/you_name -s /bin/bash   you_name
        
        # 设置密码
        # passwd you_name   

        # 加入 adm 组，阅读系统 log
        # usermod -G adm -a you_name

这样就建立了个有管理员权限的帐号，一般可以用这个帐号管理 vps，而不需要用
root 帐号。

 * 修改时区别和locale设置

由于 vps 所在地是日本，时区为东九区，vps 的时间比我们的本地时间快了 1 个小时，看起来很不爽，修改时区还是很简单的，执行下述命令就好。

        $ sudo dpkg-reconfigure tzdata
        # 选择 Asia/Shanghai 一切 ok

同样，因为是日本的服务器，locale 设置的不对，执行命令时常常会出现下面的报错
提示:

        perl: warning: Setting locale failed.
	perl: warning: Please check that your locale settings:

因为是服务器，en_US.utf8 才是王道，下面就来安装 en_US.utf8:


        root@ubuntu-vps:~# cd /usr/share/locales
        root@ubuntu-vps:/usr/share/locales# ls
        install-language-pack  remove-language-pack
        root@ubuntu-vps:/usr/share/locales# ./install-language-pack en_US
        Generating locales...
          en_US.UTF-8... done
          Generation complete.

执行 locale 看安装是否成功:	  
 
        roots@ubuntu-vps:~# locale
	LANG=en_US.UTF-8
	LANGUAGE=en_US:en
	LC_CTYPE="en_US.UTF-8"
	LC_NUMERIC=en_US.UTF-8
	LC_TIME=en_US.UTF-8
	LC_COLLATE="en_US.UTF-8"
	LC_MONETARY=en_US.UTF-8
	LC_MESSAGES="en_US.UTF-8"
	LC_PAPER=en_US.UTF-8
	LC_NAME=en_US.UTF-8
	LC_ADDRESS=en_US.UTF-8
	LC_TELEPHONE=en_US.UTF-8
	LC_MEASUREMENT=en_US.UTF-8
	LC_IDENTIFICATION=en_US.UTF-8
	LC_ALL=

最后还要执行 update-locale 命令，否则在 /var/log/auth.log 中会出现 
“pam_env can't open /etc/default/locale " 的错误。

 * 修改 ssh 设置，增强安全性

ssh 基本是我们管理 vps 的最好的手段了，保护好 ssh 的连接对增强 vps 的安全性有重大的作用。可以从三个方面入手，一个是修改 ssh 默认的 22 端口到自定义端口；其二是禁止远程 root 登陆；其三是禁止密码登陆，只用密钥登陆。基本上是修改
ssh 的配置文件，下面是具体步骤。

1. 修改 ssh port ，禁止 root 远程登陆

        # 修改 ssh 配置文件，在文件中修改下面选项
        sudo vi /etc/ssh/sshd_config
        # 修改 ssh port， 先增加个端口，重启 ssh 成功后再把默认端口
        # 删除，防止发生不能ssh登陆的悲剧
        port ***
        # 禁止 root 登陆
        PermitRootLogin no
        # 重启 ssh 服务
        sudo service ssh restart

2. 设置密钥登录

        # 本地生成密钥，在本机 .ssh 目录下运行下面的命令
        # 密钥名可以自定义，如默认的id_rsa
        ssh-keygen
        # 拷贝公钥到 vps
        scp ~/.ssh/id_rsa.pub example_user@vps_ip
        # vps 上建立 .ssh 目录
        mkdir .ssh
        # 拷贝并重命名公钥 
        mv id_rsa.pub .ssh/authorized_keys
        # 增强公钥的安全性
        chown -R example_user:example_user .ssh
        chmod 700 .ssh
        chmod 600 .ssh/authorized_keys

        # 测试
        $ ssh -p port -i .ssh/id_rsa example_user@vps_ip
        # 如果成功可以禁止密码登陆
        sudo vi /etc/ssh/sshd_config
        PasswordAuthentication no
        # 重启 ssh  
        sudo service ssh restart

 * 修改主机名称

vps 的默认主机名称是一段数值，看起来很不爽，准备修改成自己喜欢的名字

        # 修改 /etc/hosts
        127.0.1.1    oldname
        替换为
        127.0.1.1    newname
        # 编辑 /etc/hostname
        $ sudo echo "newname" > /etc/hostname
        # 运行下面命令
        $ sudo hostname newname
        # 必要时可能要重启机器

##  安装 LNMP 环境

LNMP一键安装包是一个用Linux Shell编写的可以为CentOS/RadHat、Debian/Ubuntu
VPS(VDS)或独立主机安装LNMP(Nginx、MySQL、PHP、phpMyAdmin)生产环境的Shell程序。	

具体步骤可以参考 [lnmp.org](http://lnmp.org/) 的介绍。
安装时间比较长，需要耐心等待。

## 安装 openvpn 

在这个 GFW 猖狂的年代，vpn 已经成为了上网的必备工具，有了 vps 后在上面安装
好了 vpn 就可以享受无阻碍的网络，还省了购买 vpn 的钱。在 vps 上安装 openvpn
网上有很多不错的教程，我主要参考了以下的教程设置的。

教程1：[Linode VPS OpenVPN安装配置教程](http://www.vpser.net/build/linode-install-openvpn.html)
教程2：[OpenVZ vps下的openvpn安装](http://www.douban.com/note/97996409/)
	特别注意的是，因为是 openVZ 的 vps 要用DST NAT
	iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to vps_ip

基本上按照上述的教程即可安装好 openvpn。

## 设置 iptables

iptables 是 linux 的防火墙，为了 vps 的安全必须按照一定的规则过滤进出 vps 的
数据，准许必要的端口开放，关掉非必要的端口，减少被攻击的可能性。一般来说开放
ssh，ftp，http，https，mysql，openvpn 的端口即可，这个是我的 iptables 设置的[脚本](/codes/iptables_init.sh)。



## 参考资料

1. [library.linode.com](http://library.linode.com/)
2. [openvpn_server参数详解](http://blog.chinaunix.net/uid-27029423-id-3328463.html)
3. [使用 OpenVPN 服务器翻墙的相关问题解决](使用 OpenVPN 服务器翻墙的相关问题解决)
4. [Iptables 设置脚本一例](http://www.networkvps.com/index.php/archives/1135)
5. [VPS简单性能测试命令](http://www.zrblog.net/2284.html)


	








        	
