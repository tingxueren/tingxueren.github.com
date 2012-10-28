---
layout: post
title: "install dropbox in linux"
date: 2012-09-10 20:49
comments: true
categories: 
---

Dropbox 是个很神奇的工具，你可以用它来同步重要的文件，配置。可以放心的把文件放在云端，作为备份。Dropbox 有着齐全的平台覆盖，不但有 windows客户端，MAC 客户端，还有 ios 客户端，Android 客户端，最让我高兴的是还有 Linux 客户端，这点让我十分的欣赏。Dropbox 真正的实现了全平台覆盖，在不同的平台上都给人一致的体验。

## Dropbox 的安装

天朝是个神奇的地方，基本上好的互联网服务都会被 #GFW 认证。可以说被 #GFW 认证的服务才是靠谱和真正有价值的服务。

为了能正常的使用 Dropbox 请认真学习各种翻墙技能，常常温故知新，多准备些备用手段，以便应付 #GFW 层出不穷的攻击手段。推荐的梯子有 VPN、SSH、GAE（GoAgent，Wallproxy）等等。

 * 为了使用 Dropbox，必须先有个帐号，Dropbox 主页被墙，请自备梯子。客户端
   暂时还能正常的使用，但是有个问题，在两台电脑之间无法即时同步，因为提供即
   时同步功能的服务器与客户端用的是 http 协议，被 #GFW 干扰。但是重新关闭客
   户端后即可正常同步，天朝威武，把好好的自动工具搞成了半自动。

 * 在主页上有 Dropbox 软件下载, Windows 下客户端是一个单一个软件，Linux
   下却会给人带来点小麻烦。

 * 在 ubuntu 下软件中心有 Dropbox，但是安装后会有以下的画面：
 * ![](/images/dropbox-error.png  "dropbox error")

   原因是软件中心的 Dropbox 只是个 nautilus 插件，由它整合 Dropbox 和 nautilus
   本身并不是完整的客户端，需要从 Dropbox 官网下载完整的安装包。

 * 然后在下载的安装包的过程中，你会发现安装进程像卡死一样一动不同。
   不用怀疑，是 #GFW 发威了，它阻断了你与 Dropbox 官网的连接，为了正常的用 Dropbox，
   我们需要手动安装客户端。

 * 令人高兴的是 Dropbox 提供了安装包的完整的下载版本，可以在[Dropbox官网](https://www.dropbox.com/install?os=lnx)查看。

 * 下载安装有两种方式，一种是从浏览器下载，然后解压，执行; 另一种是自己在终
   端中执行所有的操作。

 * 翻墙方式首选 VPN ，然后终端中的命令可以顺利的执行，如果是用 GoAgent 等
   工具的话需要在执行前设置终端的代理，让终端接下来的操作都通过代理进行，
   即通过代理下载安装包，由于安装软件需要 root 权限，切记在设置代理前，切换
   为 root 用户，下面 GoAgent 为例说明设置（8087为GoAgent默认端口）。

        export http_proxy=http://127.0.0.1:8087   
        export https_proxy=http://127.0.0.1:8087   

 * 然后在终端中执行下面命令以完成安装：

        # 32 位系统执行下面命令
        $cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -

        # 64 位系统执行下面命令
        $cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

 * 最后执行下面的命令

        $ ~/.dropbox-dist/dropboxd


Dropbox 安装顺利完成，享受全平台同步的快感吧。	
