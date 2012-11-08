---
layout: post
title: "代码高亮折腾笔记"
date: 2012-11-08 17:19
comments: true
categories: 
---

这几天 wordpress 也搭建好了，就开始折腾了，别的配置都是比较简单的，基本上就是换主题，改插件的事情。不懂php也就没有大的改动，就是找了个能看的过去的主题用了个 cache 的插件优化了下，为了听音乐还在侧边栏贴上了个虾米播播，虾米的服务挺好的，赞一个。作为个程学猿还是想在 blog 上分享点代码的，代码显示的不好，连写字的心情都没有。折腾代码的高亮和漂亮的显示是最头疼的事情，还好最后找到了个基本完美的方案，在折腾 wordpress 的同时也研究了下 octopress 的代码高亮，写个日志以为记。

## wordpress 代码高亮方案

总体上 wordpress 方案就是找插件，但是找到个可以用的，用着顺手的插件真的好麻烦,经过了很多的测试终于选定了现在用的插件。下面是各个插件的试用感受。

 * [WP-Syntax](http://www.boke8.net/wordpress-wp-syntax-button.html) 

   这个插件是我用的第一个插件，还有个 `WP-Syntax Button` 配套的按钮，用起来还是凑合。但是用了一段后发现严重的问题，在编辑的时候如果来回的在可视化视图和 html 视图之间切换的话会造成代码不能正常的高亮，排版被破坏，而且不支持 tab 缩进，这点是我最不能忍受的。我所有的代码都是 tab 缩进的贴在网页上却把所有的 tab 都删除了，代码看起来就一团糟了。

 * [SyntaxHighlighter](http://codeup.org/archives/128)

   因为 WP-Syntax 的不靠谱我又换了这个插件，这个插件比 WP-Syntax 好用的多了，一切都在可视化视图中修改就好，语法也很简单：[lang]code[/lang],这样做就好了而且切换可视化视图和 html 视图的话代码也不会乱掉。但是不支持 tab 缩进的问题依然没有解决。

 * [SyntaxHighlighter++](http://www.guansoft.com/syntaxhighlighter.html)   

   这个插件完美的解决了我的问题不得不赞个，安装后会在编辑页面出现个新的编辑窗口，把代码贴上去，然后点击插入就好了。支持 tab 缩进，不需要改动 html 代码用着很舒服，还是国人写的，更要支持下，以后不出意外的话这个插件会一直用下去。

## octopress 代码高亮方案

   以前用 octopress 写东西的时候没注意代码高亮的问题，原来插入代码为了美观只是在 markdown 文本里面把代码行缩进8个空格，排整齐，效果还凑合，但是这样不会有高亮的效果的，而且手动的打空格是很憋屈的事情。查找了下官方的教程终于找到了适合的方案。

   官方的[ octopress 代码高亮教程](http://octopress.org/docs/blogging/code/),同时还有篇[非官方中文翻译](http://xiongbupt.github.com/blog/2012/06/08/octopressdai-ma-gao-liang/)。
   
   看了这两篇文章后我就准备尝试，但是还是不知道markdown源文件到底该怎么写，幸好 octopress 的[官网](https://github.com/imathis/octopress)就托管在 github 上，上面有生成的页面，也有 markdown 源代码,这下可以对照着看了。

   我很喜欢`backtick-codeblock`的代码高亮方式，很简单，在代码前后加上三个反引号就好了，在 github 上找到了[ markdown 文件](https://github.com/imathis/octopress/blob/site/source/docs/plugins/backtick-codeblock/index.markdown)。下面是简单的摘录。

 * 语法

        ``` [language] [title] [url] [link text] [linenos:false] [start:#] [mark:#,#-#]
        code snippet
        ```

 * Basic options

        [language] - Used by the syntax highlighter. Passing 'plain' disables highlighting.
        [title] - Add a figcaption to your code block.
        [url] - Download or reference link for your code.
        [Link text] - Text for the link, defaults to 'link'.

 * 源码

        ``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
        class Fixnum
          def prime?
            ('1' * self) !~ /^1?$|^(11+?)\1+$/
          end
         end
        ```
 * 显示效果

``` ruby Discover if a number is prime http://www.noulakaz.net/weblog/2007/03/18/a-regular-expression-to-check-for-prime-numbers/ Source Article
    class Fixnum
      def prime?
        ('1' * self) !~ /^1?$|^(11+?)\1+$/
      end
    end
```
### 注意事项
    
   指定高亮的代码的语言时要写清楚，shell 脚本的语言类型是 `sh`，即使是 `Bash` 的脚本也应该用 `sh`，写作 `bash` 在  `rake generate` 的阶段会报错的。

### 高亮代码展示

``` sh shell 命令行
# 升级源，并更新系统
$ sduo apt-get update && sudo apt-get upgrade
# 得到系统的内核信息
$ uname -a
```

``` c++ c++ 代码
#include <iostream>  
#include <algorithm>  
#include <string>  
using namespace std;  
  
int main()  
{  
   string str1;  
   string str2;  
   while(cin>>str1>>str2)  
   {  
       int nLen1, nLen2, nLen;  
       nLen1 = str1.length();  
       nLen2 = str2.length();  
       nLen = nLen1 > nLen2 ? nLen1 : nLen2;  
         
       reverse(str1.begin(), str1.end());  
       reverse(str2.begin(), str2.end());  
         
       //高位补零  
       if (nLen > nLen1) str1.append(nLen - nLen1, '0');   
       if (nLen > nLen2) str2.append(nLen - nLen2, '0');  
         
       int temp = 0;   //进位数目  
       int i = 0;  
       string strResult;    //存储结果  
         
       while (i < nLen)  
       {  
           if(str1[i] -0x30 + str2[i] + temp > '9')  
           {  
               strResult.append(1, str1[i] + str2[i] - '9' - 1 + temp);  
               temp = 1;  
           }  
           else  
           {  
               strResult.append(1, str1[i] + str2[i] - '0' + temp);  
               temp = 0;  
           }  
           i++;  
       }  
         
       if(temp == 1)  
          strResult.append(1, '1');  
       reverse(strResult.begin(), strResult.end());  
       cout<<strResult<<endl;  
   }  
   return 0;  
}  
```
