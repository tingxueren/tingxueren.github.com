---
layout: post
title: "tar 排除指定目录"
date: 2013-03-06 19:07
comments: true
categories: 
---

很久没有写 blog 了感觉 blog 已经荒废了。上一篇文章在 2012 年底，现在都 2013 年了，2 个多月就这么过去了。在这两个多月从大部分时间在家过年什么都没有做，一直在歇着。1 月底的时候 yardvps 打 5 折， 把 blog 迁移到了这个新的 vps 了，感觉运行很稳定，价格还是很实惠的。blog 搬家没有遇到什么问题，但是今天在用 tar 备份网站的时候遇到点问题，如何排除指定的目录。

## 什么是 tar
Unix和类Unix系统上的压缩打包工具，可以将多个文件合并为一个文件，打包后的文件名亦为“tar”。目前，tar文件格式已经成为POSIX标准，最初是POSIX.1-1988，目前是POSIX.1-2001。 本程序最初的设计目的是将文件备份到磁带上(tape archive)，因而得名tar。(摘抄自维基百科)

## 问题
我准备是用 tar 备份我的 wordpress 网站的，但是里面有一个目录是 wp-content 下面的 backup 目录有以前的备份，我想把这个排除掉，想起以前用 tar 备份系统的时候用的 --exclude 参数，开始是这么写的：
``` sh
cd /home/wwwroot
tar cpzf www.mars.tingxuere.com.tar.gz www.mars.tingxueren.com --exclude=www.mars.tingxueren.com/wp-content/backup/
```
很遗憾运行后还是不行，我以为是路径写的有问题，下面用绝对路径
``` sh
cd /home/wwwroot
tar cpzf www.mars.tingxuere.com.tar.gz www.mars.tingxueren.com --exclude=/home/wwwroot/www.mars.tingxueren.com/wp-content/backup/
```
同样还是不行的，不知道为什么，感觉可能是 --exclude 参数我的理解有问题。

## 实验
首先 man tar 看看 --exclude 参数是干吗的:
``` sh
     --exclude=PATTERN
           exclude files, given as a PATTERN
```
从上面看到 --exclude 排除的目录不是目录的路径，而是按照正则表达式的形式排除的，PATTERN是也。理解错误在 --exclude 后面跟路径当然达不到我的目标，下面是个很简单的实验：
``` sh
$ pwd
/home/user
$ mkdir test
$ cd test
$ mkdir test01 test02
$ cd test01
$ touch test01.txt
$ cd ../test02
$ touch test02.txt
$ cd 
$ tar cvzf test.tar.gz test --exclude=/home/user/test/test02
test/
test/test01/
test/test01/test01.txt
test/test02/
test/test02/test02.txt
# 可以看到 --exclude 没有起到效果
$ tar cvzf test.tar.gz test --exclude=test02/
test/
test/test01/
test/test01/test01.txt
test/test02/
test/test02/test02.txt
# --exclude 依然没有效果，因为 tar 打包过程中找不到与 test02/ 匹配的项目，注意最后的`/`
$ tar cvzf test.tar.gz test --exclude=test02
test/
test/test01/
test/test01/test01.txt
# 顺利的达到目标
# --exclude 后面是正则表达式，还可以排除文件夹中具体的文件
# 保留 test02 文件夹，去除 test02.txt
$ tar cvzf test.tar.gz test --exclude=test02/*.txt
test/
test/test01/
test/test01/test01.txt
test/test02/
```

## 疑惑
在搜索过程中看到了有人写到：在 GNU tar 中用 --exclude 参数时，被打包的文件必须要放在最后，否则没有效果，但是我实验了下发现被打包文件放在前面和后面都是一样的，不知是这个 bug 被修复了，还是以讹传讹的错误：
``` sh
$ tar --version
tar (GNU tar) 1.26
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by John Gilmore and Jay Fenlason.
# test 放在 --exclude 前面
$ tar cvzf test.tar.gz test --exclude=test02
test/
test/test01/
test/test01/test01.txt
# test 放在 --exclude 后面
$ tar cvzf test.tar.gz  --exclude=test02 test
test/
test/test01/
test/test01/test01.txt
# 可以看到上述两种写法，执行效果一致
```
