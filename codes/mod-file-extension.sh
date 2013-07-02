#!/bin/bash

path=$1
origin_extension=$2
new_extension=$3
# path 必须为 . 或者是绝对路径，相对路径是不行的
cd $path
#echo "$path"
#echo "$origin_extension"
#echo "$new_extension"
#find $path -type f -name "*.$origin_extension" -exec echo  '{}' \;
# 下面的必须要用 “ ，因为 ” 能把 $ 转化为通配符，‘’ 不能，不要搞错
find $path -type f -name "*.$origin_extension" -exec rename "s/.$origin_extension$/.$new_extension/" '{}' \;
