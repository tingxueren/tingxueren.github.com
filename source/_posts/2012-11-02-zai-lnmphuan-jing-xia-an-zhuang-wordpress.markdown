---
layout: post
title: "在LNMP环境下安装wordpress"
date: 2012-11-02 20:36
comments: true
categories: 
---

买了vps后感觉总是让它在空跑很浪费资源的感觉，前期在上面安装了openvpn和ssh只
用来翻墙，看到负载常常是0.00真的很郁闷。将github.com上以前用octopress生成的
blog放上去，负载基本上还是零，郁闷了，准备捣鼓wordpress了。

## 安装wordpress

本来以为安装起来很麻烦，但是看了下教程竟然如此的简单。wordpress 需要php环境
和mysql，现在想起来网上卖的虚拟主机是什么东西了。就是分配一块磁盘空间，给客
建立个mysql帐号，大不了再给个ftp帐号，就这样就拿来卖了，相当的简单。还是vps
自由度高，想怎么折腾就怎么折腾。

vps上现在安装的是LNMP的一键安装包0.9版，有php和mysql环境，安装wordpress的环
境要求得到了满足。只需要以root权限运行 /vhost.sh 的脚本添加个新的网站，比如
myblog.com 就会在 /home/wwwroot/ 文件夹下生成网站的文件夹：myblog.com
以下的操作都会在这个文件夹进行。

        #下载wordpress中文包 
        $wget http://cn.wordpress.org/wordpress-3.4.2-zh_CN.tar.gz
        #解压到本地
        $tar xzvf wordpress-3.4.2-zh_CN.tar.gz -C myblog.com
        #将文件转移到myblog.com
        $cp wordpress/* .
        $rm -rf wordpress

现在还需要个mysql帐号就好了，登陆phpadmin为blog专门建立个帐号，权限配置暂时
没搞清楚，除了管理权限什么都给了，应该有点多，以后搞懂后再修改吧，现在先用
着。然后访问域名 www.myblog.com 就会看到 wordpress 的欢迎页面，创建你的帐号
就可以用了。

## wordpress 调整

一直对wordpress的可折腾性抱有很高的期望，在网上看到各种不同风格的wordpress
网站一直搞不懂是怎么做出来的。进入后台明白了，主要归功于wordpress的架构，可
以随心所欲的更换主题和添加插件。而且大部分的布局还可以自己调整，就是这种灵
活性造就了同样的架构，表现起来却千变万化。只要耐心，能折腾自己也能搞不独一
无二的blog。

### wordpress 主题

主题还是比较容易更换的，在仪表盘上直接有主题的选项，点击安装新的主题即可，
比较郁闷的是我的wordpress不管安装了多少个主题，当前可用主题一直只有当前主题
其他的都不见了，最后搜索了原来是 LNMP 安装包的 php 设置的问题，修改下配置就
好了，可以看另一篇博文。

### wordpress 代码高亮显示

作为未来的程序猿，免不了要在blog里贴点代码什么的，用 octopress 的时候，编辑
文章是自己写 Markdown 文档，只要按照规定的格式写就能自动的转化成不错的 html
代码，wordpress 是需要插件的，就是这个插件折腾的我都要崩溃了。

 * 网上推荐的是用的WP-Syntax，具体的使用可以参看这篇[文章](http://www.boke8.net/wordpress-wp-syntax-plugin.html), 还有一个button可以方便的在可视化状态
 下插入代码。这个插件最郁闷的地方是插入代码必须在html视图下插入，但是转到可
 视化的视图查看后再转回来就常常造成html代码混乱了，无法正常的代码高亮。开始
 的时候插件工作的还很正常，但是经过几次实验后就彻底的罢工了，怎么也搞不成代
 高亮了。

 * 我的替代方案是用SyntaxHighlighter，简要介绍在[这里](http://codeup.org/archives/128)。这个方案的特点是使用够简单，而且不需要在不同的视图之间转换。比
 如添加 c++ 代码，只需要在可视化视图下[cpp] your code [/cpp] 即可，相当的 
 方便。

 * 现在用的代码高亮的插件用起来还不错，不过有点很郁闷，wordpress 会自动的删
 除 tab 的空白。本来本地的代码，用 tab 缩进的好好的，但是贴在 wordpress 就
 会因为把 tab 缩进删除导致了漂亮的代码看起来惨不忍睹。解决方案有2种，一种是
 自己手动添加空格，不用 tab 缩进，但是工程量很大；另一个方案是用万能的vim，
 强大的vim竟然有直接将当前代码生成 html 的命令，确实强大到让人无语，这里有
 简要的[介绍](http://openwares.net/vim/vim_wordpress_syntax.html)。这里是
 [效果](http://www.mars.tingxueren.com/index.php/2012/11/01/%E4%BB%A3%E7%A0%81%EF%BC%8C%E5%BA%94%E7%94%A8vim-vim-%E5%91%BD%E4%BB%A4-tohtml/)。 但是对
 与 html 的代码无任何了解，vim 直接生成的代码贴上去后整个页面就无法编辑了, 
 如果编辑的话会产生莫名奇妙的错误，等以后了解了 html 后再用 vim 生成的代码
 了。

### 虾米音乐插件

 用了wordpress发现它的插件是很强大的，因为的有php的网页，动态交互什么的也
 不在话下。在网页中插个播放器什么的比 octopress 的话方便很多。我用的是个
 [TinyMCE Xiami Music for WordPress](http://www.appinn.com/tinymce-xiami-music/), 直接抓取虾米的音乐放在页面，挺不错的。

### 关于图片和媒体及版本控制

 用了一段 wordpress 后我总算是明白了mysql数据库是干什么的，插入的媒体，图片
 什么的都会存储在 mysql 数据库中，可以方便的在文章中插入，这点在 Markdown
 中插入图片方便。同时 mysql 数据库还保留了同一篇文章你不同时间修改的版本，
 当你发现当前的版本不合适时可以很容易的恢复到历史版本。

wordpress 的强大功能还有待发掘，就这么短短的试用时间来说还是不错的，基本上
比较满意。以后 wordpress 的 blog 主要放图片比较多的文章，毕竟 wordpress 插
入媒体比较方便，octopress 的 blog 适合随手写的东西，毕竟在本地 vim 中码点字
比用 wordpress 的在线编辑器体验好很多。

