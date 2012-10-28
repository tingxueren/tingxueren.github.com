#!/bin/bash  
#Author:digglife  
#Editor:zhangdongsheng
#Description:Convert the charset of text file.  
#version:0.2  
#Date:2011/05/12  
#EditorDate：2012/07/11
#To Be Resovled:  
#  1.get filename without using $fileExtension varable.  
  
#Get the parameters  
file=$1  
to_charset=$2  
  
#Get the first character of the $file  
first_char=${file:0:1}  
  
#Test if the file exists,break if it doesn't  
if [ ! -f "$file" ];then  
    echo "$file,No such file or directory"  
    exit 1  
#If the given $file contains the directory,get the basename of it,and change dir to its directory.  
#如果有“～”，shell会自动转化为绝对路径，不用担心,好像相对路径也会自动处理的
elif [ first_char="/" ];then  
    full_filename=$(basename $file)  
    cd $(dirname $file)  
else  
    full_filename=$file  
fi  
  
#Split the file extention and filename  
#在最后的.前加上\,才能得到正确的路径
file_extension=$(echo $full_filename | sed 's/^.*\.//g')  
#echo "file_extension=$file_extension"
filename=${full_filename%.$file_extension}  
#echo "filename=$filename"  
#Get the original charset  
charset_org=$(file -i $full_filename | sed 's/^.*charset=//g')  
#echo "charset_org=$charset_org"	
# if不能用于字符串相等的比较，-eq 是数字的比较
#if [ $charset_org -eq iso-8859-1 ] ; then 
case "$charset_org" in
	iso-8859-1)
	charset_org=GB18030;;
esac

#echo "charset_org=$charset_org"	
#Convert the charset,and change the full filename  
iconv  -f $charset_org -t $to_charset $full_filename > $filename.$to_charset.$file_extension
