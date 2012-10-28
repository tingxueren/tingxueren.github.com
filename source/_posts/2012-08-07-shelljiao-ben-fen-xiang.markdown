---
layout: post
title: "shell脚本分享"
date: 2012-08-07 21:26
comments: true
categories: 
---

用着 linux 免不了要和 shell 打交道，shell 是个很强大的工具，内置了多有用的程序，配合着 linux 的管道机制，可以将这些小工具组合成各种各样的脚本，为你服务。下面简单的介绍并分享我的几个小脚本。

## 脚本的结构

* 脚本的第一行一般是 `#!/bin/bash` 或者是 `#!/bin/sh`, 表明执行脚本的程序为
  `bash` 或者是 `sh` 。

* 以 `#` 开头的为注释，执行时会自动忽略。

* 脚本在执行时可以从外界获取参数，一般执行脚本的格式为 `test.sh arg[1] arg[2] ... ` , 在脚本内部 `$0` 代表脚本的名称， `$1` 代表第一个参数，以此类推。

* 脚本中常用的命令

  - find 和 exec

        # 一般用 find 命令找到符合要求的项目，然后调用 command 处理每一项
        find path [-type] [f]  [-name] ["*.txt"]  -exec command argument '{}' \;

  - sed awk cut 
    
        # 这三个一般都是用来对获取的文本进行处理
        # 获取文件扩展名, 即如果输入为test.txt, 输出为txt
        sed 's/^.*\.//g'
        # 输出 ps aux 的输出项的前两列
        ps aux | awk '{print $1, $2}' 
        # cut 即剪切工具，下面是取出以空格为分隔符，取出第一部分的命令
        cut -d ' '  -f 1   

## 我的小脚本

* [文本格式转换脚本](/codes/iconv_shell.sh)

  用 linux 有一个很头疼的问题就就是中文的乱码问题，linux 下中文的编码格式是
  utf-8, windows 默认编码格式是 GB2312， 这导致了 windows 下的文本文件在
  linux 下常常是乱码的，同理 linux 下编辑的文本文件在 windows 下也会乱码。
  为此我们要进行字符编码的转换，即利用 `iconv` 命令。`iconv` 命令的基本格式
  如下：
        iconv -f oldcharset -t newcharset  file -o newfile 
  脚本实现了自动获取字符编码，并转换为 UTF-8 编码的功能，为了解决常常遇到的
  未知编码问题，加入了个默认功能，如果编码未知，强制性的进行 GB18030 到 
  UTF-8 的功能，运行起来效果还好。根据这个又修改成了一个右键调用的
  [nautilus-script](/codes/UTF8.sh)。

* [批量更改文件权限脚本](/codes/chmod_recursion.sh)
  
  在拷贝文件时常常遇到拷贝回来的文件的权限不对，一个个更改很麻烦，
  脚本主要用`find`命令查找对应的项目，然后通过 `exec` 调用 `chmod`
  而成，具体请看脚本。

* [批量更改文件所有者脚本](/codes/chown_recursion.sh)
  
  和上面的脚本很相似，也是用 `find`, `exec`, `chown`,组合而成，
  `chown`可以同时更改文件的所有者和所属组。

* [更改文件后缀名](/codes/mod-file-extension.sh)

  有时候文件的后缀名不符合要求，如要把 `htm` 后缀换成 `html` 后缀，这个脚本
  就很有用。主要用到了一个命令 `rename`。
       
        # 将说用的 *.htm 后缀换成 html
        renam 's/htm$/html' *.htm
       
    
 	
       
    
