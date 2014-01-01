---
layout: post
title: "最近折腾笔记"
date: 2014-01-01 12:43
comments: true
categories: 
---

最近论文写完了，不安分的心总是静不下来，又开始了一轮新的折腾。最近忙活的事情乱七八糟的，主要有下面的几件事：安装Arch， 重新投奔Arch旗下；申请到了Windows Azure的试用帐号，尝试国内的云服务；加入了WCG计划，开挖ripple币，貌似挖了那么久还不够电费的。

## 安装Arch

Arch是一个很优秀的发行版，哲学就是KISS，一切都遵循着最大的定制化的准则，像搭积木似的可以搭建出自己满意的一个实用的系统。和我常用的ubuntu不同的是不提供一个开箱即用的桌面环境，一切都要自己来搭建。Arch的包管理是很激进的，向来追求最新的软件，而不太考虑软件的稳定性，而且是滚动发行的版本，不是像有些发行版那样有个稳定的开发周期，如果系统关键部件调整而没有按照wiki的方法做好调整就升级的话常常造成系统损坏无法开机的悲剧。

曾经使用过Arch四个月，大概是2012.04-2012.07,当时的安装有一个自动化的脚本，安装起来比较简单，使用起来还好，就是笔记本无法正常的休眠和唤醒，这个比较头大，一直没有解决。最后在有一次升级的时候没有注意一些警告强行升级导致了GRUB的引导出错了，Windows 7和Arch 都找不到了，当时也用Arch烦就彻底的删除了Arch，装回了ubuntu了，还是它省心。最近ubuntu越来越慢，很臃肿，用时间长了又想尝试新的东西，加上笔记本的分区很不合理，C盘只有500M的剩余空间了，索性全部格掉重新安装成 Windows 7 + Arch 双系统。Widonws的安装没什么可说的，Arch的安装倒是有些需要注意的地方，Arch的wiki是很好的资料，基本上所有的操作都是参照着wiki的介绍。

### 分区

本次使用的安装介质是archlinux-2013.12.01-dual.iso，使用dd命令烧录到了u盘中安装的。从u盘启动后进入了Arch的live cd模式，第一步就是分区，因为是双系统，Windows已经安装好了，需要多重引导，分区方面需要特别的留意，双系统引导最好使用MBR引导，使用了cfdisk的分区工具，这个工具很直观，比fdisk好用。

```
 Name                   Flags                Part Type           FS Type                        [Label]                    Size (MB)
-----------------------------------------------------------------------------------------------------------------------------------------------
                                              Primary            Free Space                                                     2.10           *
 sda1                   Boot                  Primary            ntfs                           [Windows-7]                 85901.45           *
 sda5                   NC                    Logical            ntfs                           [D-Disk]                    85899.35           *
 sda6                   NC                    Logical            ntfs                           [E-Disk]                    85899.35           *
 sda7                                         Logical            swap                                                        4096.19           *
 sda8                   Boot                  Logical            ext4                                                       20480.95           *
 sda9                                         Logical            ext4                                                       37793.57           *
```

sda8挂载在`/`上，sda9挂载在`/home`上，注意要将挂载到根的分区设置为可引导的。然后格式化各个分区，并挂载swap。

```
# 根据自己的实际情况进行修改
mkfs.ext4 /dev/sda8    
mkfs.ext4 /dev/sda9
mkswap /dev/sda7 
swapon /dev/sda7
```

### 安装基本系统

这部分基本上按照wiki的操作就可以了：

```
# 挂载分区
mkdir /mnt/home
mount /dev/sda8 /mnt
mount /dev/sda9 /mnt/home
```
设置网络和安装源，这点不同人的情况不同，要按照自己的实际情况进行设置

安装基本系统

```
#pacstrap /mnt base base-devel
Generate an fstab
# genfstab -U -p /mnt >> /mnt/etc/fstab
# nano /mnt/etc/fstab
```

chroot 并配置基本的系统

```
# 使用bash
# arch-chroot /mnt /bin/bash
# 设置hostname
# echo myhostname > /etc/hostname
# 设置时区
# ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
# 设置locale
# nano /etc/locale.gen
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
# locale-gen
# 设置硬件时钟为UTC
# hwclock --systohc --utc
# 设置网络，启用dhcpcd
# systemctl enable dhcpcd.service
# 设置无线网络
# pacman -S iw wpa_supplicant
# Make initramfs (RAM Disk) 
# mkinitcpio -p linux
# 设置 root 密码
# passwd
# 安装GRUB引导，现在GRUB有bug，这个bug导致了我尝试了5遍都没有正常的引导起来
# 解决方案很简单，具体参见这个[网页](https://bugs.archlinux.org/task/38041?project=1&cat%5B0%5D=31&string=grub)
Known issue with known workaround: add the following to /etc/default/grub
# fix broken grub.cfg gen
GRUB_DISABLE_SUBMENU=y
# 双系统引导还需要附加软件
# pacman -S os-prober
# grub-mkconfig -o /boot/grub/grub.cfg
# grub-install /dev/sda
# 退出chroot，卸载磁盘，然后重启
# exit
# umount -R /mnt
# reboot

```

### 安装gnome3桌面

一直用着gnome3的桌面，虽然说KDE桌面更漂亮，也用了一段时间，但是依然不习惯，gnome3看来更符合我的口味。Arch中安装起来也很简单，继续copy wiki：

#### 安装X

```
# 基本X组件
# pacman -S xorg-server xorg-server-utils xorg-xinit
Install mesa for 3D support:
# pacman -S mesa
# 安装显卡驱动,我的是Nvidia
# pacman -S nvidia
# 触摸板驱动
# pacman -S xf86-input-synaptics
# 测试X系统
# pacman -S xorg-twm xorg-xclock xterm
# 应该能看到图形界面了
# startx
# exit
```

#### 安装gnome3

```
# pacman -S gnome gnome-extra gdm
# 开机启动gdm，不使用startx
# systemctl enable gdm
# 建立常用的用户
# useradd -G wheel -m -s /bin/bash user_name
# passwd user_name
# usermod -G adm -a  user_name
```

#### 字体与输入法

Arch默认的字体配置是惨不忍睹的，gnome绑定的ibus输入法也不怎么样，准备都要重新调整，换成自己常用的，准备安装的输入法是fcitx，字体配置方案向ubuntu看齐，感觉ubuntu的字体配置相当的不错。

```
# pacman -S fcitx-im fcitx-config
# 在~/.xprofile和~/.xinitrc中加入下面三行
 export GTK_IM_MODULE=fcitx
 export QT_IM_MODULE=fcitx
 export XMODIFIERS="@im=fcitx"
# 重新登录应该就能用了
# 推荐sunpinyin
# pacman -S fcitx-sunpinyin
```

字体的配置可以参考[Archlinux 字体配置](http://blog.chinaunix.net/uid-25906175-id-3072940.html)。 

### 杂项

双系统设置时钟的问题，参考[archlinux入门--设置时钟](http://webdancer.is-programmer.com/posts/29553.html)。

使用octopress的问题，参考[Octopress 在 Arch Linux 下的一些問題](http://shadow.ma/blog/2013/04/07/octopress-on-arch-linux/)。

## Windows Azure 

Windows Azure是微软家的云服务，由于天朝的特殊环境，分成了国际版和中国版，我试用的是中国版，由世纪互联公司运营。还是蛮幸运的，在v2ex上看到了可以免费试用的消息就填了个邮箱，写了个申请，就很快的得到了试用的机会。

试用的配置还是很不错的，最多可以用4个核心，磁盘空间上面Windows虚拟机有120+G的C盘，还有100+G的D盘，据说是临时的盘，但是我没有发现什么区别，Linux的磁盘空间少了点，`/`有29G，`/mnt`有135G，为NTFS的盘。我在上面建立了一个ubuntu 12.04的虚拟机和一个Windows Server 2012虚拟机，正好把cpu分配的额度用完。

Windows的服务器是使用远程桌面登录的，Linux可以正常的使用ssh登录管理。Azure自带的有防火墙，上面可以指定相应的端口的策略，看文档上写的暂时不支持iptables的设置，所以Linux的机器上就没有开防火墙，只是在管理界面上开了必要的端口。管理界面是比较清爽的，看起来很错，但是不清楚如何通过web直接访问机器，比如防火墙配置错误，无法ssh登录了，或者ssh挂掉了如何修复。管理界面上只有关闭、重启等寥寥几个选项，不知道遇到这种情况怎么办，是不是只有重装了，原来的数据又怎么办？

Windows Azure的虚拟机的带宽还是不错的，虽然不能和国外的VPS的100M或者1G的带宽相比，但是至少不差。据说是共享的带宽，在服务器中下载速度能达到5MB/s，出口带宽感觉也能达到4M。还有点不爽的是服务器禁止ping，无法在服务器内部使用ping，在外面也无法ping通服务器，有一个替代的方式是使用tcpping，Windows下的具体的使用方法可以参见这篇[文章](http://blog.sharepointsaigon.com/2012/12/ping-azure-vm.html), Linux的使用方法[在此](http://xmodulo.com/2013/01/how-to-install-tcpping-on-linux.html)。

由于blog架设在Digitalocean上了，科学上网的服务也无法在国内服务器上部署，因此Windows Azure的服务器在我的手上基本上在浪费，只用来当个迅雷下载工具了，学校最近封锁了迅雷，还限制了网速，有个不限速的服务器用着也很爽。

## ripple矿工

下介绍下WCG，因为XRP是通过在WCG上做贡献才能换到的。下面是WCG的官方介绍：

我们的任务、工作以及志愿者
World Community Grid 的任务是创建世界上最大的公共计算网格，以执行能够造福人类的项目。

我们已经开发了技术基础结构，该结构可作为用于科学研究的网格的基础。我们的成功依靠大家共同贡献各自空闲的计算机时间，让世界变得更美好。

World Community Grid 仅将这项技术用于公共非盈利组织的人道主义研究，如果没有公共网格，这些研究就会因高昂的计算机基础结构成本而无法完成。作为我们对促进人类福祉的承诺，所有的研究结果都将公开，以供全球的研究团体共享。

至于ripple是什么就不介绍了，想知道干什么的，请google。

首先去WCG官网注册个帐号，官网[在此](https://secure.worldcommunitygrid.org/index.jsp)，然后你需要关联你的ripple帐号与WCG帐号，这样你在WCG上做的贡献才能获得ripple官方的奖励，关联的网站[在此](http://www.computingforgood.org/)。

在网站下载[WCG软件](https://secure.worldcommunitygrid.org/reg/ms/viewDownloadAgain.do)，Windows下和Linux下的图形界面基本类似，Linux下的字符界面的操作略有不同，下面简要介绍下步骤。

全命令行进行挖矿教程如下：
最好用包管理器安装boinc相关软件，Ubuntu、Debain系统安装命令：
```
sudo apt-get install boinc-client boinc-manager

安装完成之后boinc-client已经启动，现只需运行wcg项目，命令如下
sudo boinccmd --project_attach http://www.worldcommunitygrid.org/ 弱账户密钥

其中弱账户密钥在 https://secure.worldcommunitygrid.org/ “setting” -> “我的概要文件”

关于BOINC客户端的命令详情参考：http://www.equn.com/wiki/Boinccmd
```
关于收益，貌似比较少，最近的行情是300个贡献点数能换1个XRP，1个XRP成交价大概是0.16RMB左右。一般一天一台普通的电脑的贡献点数是5000点左右，不到3块钱，不过聊胜于无，也算是为世界做出点贡献，毕竟计算机闲着也是闲着。

