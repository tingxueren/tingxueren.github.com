---
layout: post
title: "install goagent3.0 in ubuntu12.04"
date: 2013-07-02 18:37
comments: true
categories: 
---

最近 goagent 升级了, 从 2.x 升级到了 3.0 速度貌似没太大的变化，但是感觉稳定了不少。最重要的变化莫过于原来是基于 python2.7 的，新版的直接依赖 python3.3,感觉真的是有点激进了。windows 下用没有任何问题，作者直接在安装包中打包了个精简版本的 python3，但是自己常用的 ubuntu 12.04 还没有安装 python3 还是要自己手动安装下的。具体的步骤可以参考官网的[wiki](https://code.google.com/p/goagent/wiki/GoAgent_Linux), 在按照上面的步骤安装的时候还遇到点小问题，下面是解决的过程。

## Python3 ImportError: No module named zlib

我采用的安装方式是编译安装，按照 wiki 的命令是
``` sh
wget http://python.org/ftp/python/3.3.2/Python-3.3.2.tar.bz2 && tar jxvf Python-3.3.2.tar.bz2 && cd Python-3.3.2 && ./configure && make && sudo make install
```
安装后在运行时就会提示 `ImportError: No module named zlib`, google 后发现有人遇到[同样的问题](http://stackoverflow.com/questions/4134708/python3-no-gzip-or-zlib), 页面上同样还有解决方案的[链接](http://www.1stbyte.com/2005/06/26/configure-and-compile-python-with-zlib/)。默认编译的时候没有加上 zlib 的参数，所以将 zlib 模块添加进编译参数，重新编译安装就好。完整的编译安装的命令如下所示：
``` sh
wget http://python.org/ftp/python/3.3.2/Python-3.3.2.tar.bz2 && tar jxvf Python-3.3.2.tar.bz2 && cd Python-3.3.2 && ./configure -with-zlib=/usr/include && make && sudo make install
```
注意 `./configure` 后面的 `-with-zlib=/usr/include` 参数。

## 安装 PyOpenSSL 问题
在执行
``` sh
wget http://pypi.python.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.13.tar.gz && tar zxvf pyOpenSSL-0.13.tar.gz && cd pyOpenSSL-0.13 && sudo python3 setup.py install
```
安装 PyOpenSSL 的时候会遇到 `src/crypto/x509.h:17:25: error: openssl/ssl.h: No such file or directory` 的问题，和这个[页面](https://tahoe-lafs.org/pipermail/tahoe-dev/2009-July/002469.html)描述的情况一致。还是缺少某些依赖包，这个页面上也给出了解决方案，执行下面的语句，安装上 `libssl-dev` 后继续编译就好了。
``` sh
sudo apt-get install libssl-dev
```
自此 goagent3.0 应该可以在 ubuntu 12.04 下正常的工作了，记得还有个包需要安装，不过不影响运行，且有提示，按照提示安装好需要的包就可以了。
