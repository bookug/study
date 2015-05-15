#! /usr/bin/python
#coding=utf-8

#在 Linux 环境下利用 Python 完成常用 JavaScript 库(如: jQuery、
#Prototype、MooTools 等)在众多网站中的使用率统计
#Python 能进行可视化开发,将上述开发结果以可视化方式呈现
#注:jQuery 等有多个版本,多个版本视为一个
#感兴趣的同学,可以做出多种统计,如:jQuery 的每个版本的分布等

#Jquery.js
#<script src="Js/jquery-1.8.2.min.js" type="text/javascript"></script>

import pycurl, re, cStringIO


url0 = "http://site.baidu.com"
global MAXNUM
MAXNUM = 100					#the max num of urls
global urlnum
urlnum = 0;
urlslist = []
reg = re.compile('href="(.+?)"')

buf = cStringIO.StringIO()
c = pycurl.Curl()
c.setopt(c.WRITEFUNCTION, buf.write)
c.setopt(c.CONNECTTIMEOUT, 5)	#out of time to connect
c.setopt(c.TIMEOUT, 5)			#out of time to download
c.setopt(pycurl.USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)")	#simulate the browser
c.setopt(pycurl.MAXREDIRS, 5)	#max num to redirect
#maybe need to set PROXY and COOKIE
#c.setopt(c.PROXY, 'http://inthemiddle.com:8080')
#c.setopt(c.POST, 1)
#c.setopt(c.POSTFIELDS, 'pizza=Quattro+Stagioni&extra=cheese')
#c.setopt(c.VERBOSE, True)

def visit(cnturl):	
	global urlnum
	c.setopt(c.URL, cnturl)
	try:
		c.perform()
	except:
		pass
	urlnum = urlnum + 1;
	urls = reg.findall(buf.getvalue())
	print urls
	for each in urls:
		if each not in urlslist:
			urlslist.append(each)
	urlslist.pop(0)

urlslist.append(url0)
while urlslist != [] and urlnum < MAXNUM:
	visit(urlslist[0])

#print buf.getvalue()
#fo = open("data/sites.html", "w+")
#fo.write(buf.getvalue())
#fo.close() 

buf.close()
print "---END---"

