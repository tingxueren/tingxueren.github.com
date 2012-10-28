---
layout: post
title: ubuntu开启打印机服务
date: 2012-08-03 22:32
comments: true
categories: 
---

## 目的

局域网中有空闲的打印机，可以做成打印机服务器，局域网中的用户添加网络打印机就可以自由的使用，方便，且节省资源，达到了设备充分利用的效果。

### 软硬件情况
- 服务器: 运行着ubuntu11.10 x64系统，现在运行着NTF，FTP，PT下载，迅雷下载等服务。
- 打印机: HP LaserJet M1319 Multifunction Printer series, 官方网站提供的有linux驱动。
- 客户端: windows, ubuntu, fedora。


### 具体步骤
- 第一步: 下载对应版本的linux驱动[下载地址](http://hplipopensource.com/hplip-web/index.html?)，
	选择64位的驱动，访问比较慢。

- 第二步: 在终端中对照着[安装指南](http://hplipopensource.com/hplip-web/install/install/index.html), 一步步安装。在下载驱动的时候，
	由于驱动托管在sourceforge.net,被墙掉了，请科学上网进行下载。在第13步的时候，还要下载一个插件，由于网络的原因，一直卡死，这时候
	可以手动取消，把插件下载到本地，然后运行sudo ph-plug 或者是 hp-setup 进行手动安装。驱动安装后，本机测试就可以打印了，网络打印的
	话需要进一步的设置。

- 第三步: 网络打印需要CUPS，在以前的版本中可以直接安装cpus的软件包，但是最近的ubuntu版本这个包被修改成了cupsys-driver-gutenprint,
	可以用命令 sudo apt-get install cupsys-driver-gutenprint。安装完成后要对cups服务进行设置，在浏览器中输入http://127.0.0.1:631,
	可以进入CUPS的设置页面，选Administration，选上Show printers shared by other systems
	Share published printers connected to this system
	新版本的还有一个也选上
	Allow printing from the Internet

- 第四步: CUPS设置完毕后，服务器端已经设置完毕，可以设置客户端了。linux下测试可以添加网络打印机，输入服务器的ip可自动的识别出服务上
	的打印机，选择下一步就好。windows下首先要安装对应的打印机驱动，然后添加网络打印机，在地址栏目输入的可是如下：
	http://服务器ip:631/printers/打印机名称
	linux下如果不识别可以按照下面格式输入
	ipp://服务器ip:631/printers/打印机名称
	设置好后都有测试页可供打印。客户端设置完毕。
