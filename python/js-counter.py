#! /usr/bin/python
#coding=utf-8

#在 Linux 环境下利用 Python 完成常用 JavaScript 库(如: jQuery、
#Prototype、MooTools 等)在众多网站中的使用率统计
#Python 能进行可视化开发,将上述开发结果以可视化方式呈现
#注:jQuery 等有多个版本,多个版本视为一个
#感兴趣的同学,可以做出多种统计,如:jQuery 的每个版本的分布等

#Jquery.js
#<script src="Js/jquery-1.8.2.min.js" type="text/javascript"></script>

#1. download common sites to a file from site.baidu.com
#2. ...

import pycurl, re, cStringIO

buf = cStringIO.StringIO()
c = pycurl.Curl()
c.setopt(c.URL, 'http://site.baidu.com')
c.setopt(c.WRITEFUNCTION, buf.write)
c.setopt(c.CONNECTTIMEOUT, 10)
c.setopt(c.TIMEOUT, 10)
#c.setopt(c.PROXY, 'http://inthemiddle.com:8080')
#c.setopt(c.POSTFIELDS, 'pizza=Quattro+Stagioni&extra=cheese')
#c.setopt(c.VERBOSE, True)
c.perform()

#print buf.getvalue()
#fo = open("sites.html", "w+")
#fo.write(buf.getvalue())
#fo.close() 
linksList = re.findall('<a href=\"(.*?)\".*?>.*?</a>', buf.getvalue())
for link in linksList:
	print link
buf.close()


