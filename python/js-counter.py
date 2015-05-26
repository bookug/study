#! /usr/bin/python
#coding=utf-8

import pycurl, re, cStringIO					#pycurl is better than urllib
from Tkinter import *							#import functions only when necessary

url0 = "http://site.baidu.com"					#begin from a navigate page
global MAXNUM									#the max num of web pages to visit
MAXNUM = 100					
global urlnum									#urls already visited successfully
urlnum = 0;
urlslist = []									#list to store url, here is like queue
dict_jquery = {}								#just like map in C++

#BETTER: when libs are too many, use map and struct to simplify code
#compile regex will save time
reg_link = re.compile(r'href="(https?://.+?)"')
reg_jquery = re.compile(r'<script .*?src=".+?jquery', re.IGNORECASE) 
reg_prototype = re.compile(r'<script .*?src=".+?prototype', re.IGNORECASE)
reg_moontools = re.compile(r'<script .*?src=".+?moontools', re.IGNORECASE)
reg_dojo = re.compile(r'<script .*?src=".+?dojo', re.IGNORECASE)
reg_yui = re.compile(r'<script .*?src=".+?yui', re.IGNORECASE)
reg_jqeury_version = re.compile(r'<script .*?src=".+?(jquery-.*?.js).*?"', re.IGNORECASE)

global Jquery									#num of pages using Jquery
Jquery = 0
global Prototype								#num of pages using Prototype
Prototype = 0
global MoonTools								#num of pages using MoonTools
MoonTools = 0			
global Dojo										#num of pages using Dojo
Dojo = 0
global YUI										#num of pages using YUI
YUI = 0

buf = cStringIO.StringIO()
c = pycurl.Curl()
c.setopt(c.WRITEFUNCTION, buf.write)			#web content will be put into buf now
c.setopt(c.CONNECTTIMEOUT, 5)					#out of time to connect
c.setopt(c.TIMEOUT, 5)							#out of time to download
c.setopt(pycurl.USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)")									  #simulate the browser
c.setopt(pycurl.MAXREDIRS, 5)					#max num to redirect
#maybe need to set PROXY and COOKIE
#c.setopt(c.PROXY, 'http://inthemiddle.com:8080')
#c.setopt(c.POST, 1)
#c.setopt(c.POSTFIELDS, 'pizza=Quattro+Stagioni&extra=cheese')
#c.setopt(c.VERBOSE, True)



def visit(cnturl):								#visit current url and analyse
	global urlnum
	global Jquery
	global Prototype
	global MoonTools
	global Dojo
	global YUI

	c.setopt(c.URL, cnturl)
	try:
		c.perform()								#connect and download
	except:										#exception or error: can't download, etc.
		pass

	urlnum = urlnum + 1;
	html = buf.getvalue()
	urls = reg_link.findall(html)

	if reg_jquery.search(html) != None:			#search successfully!
		Jquery = Jquery + 1
	if reg_prototype.search(html) != None:
		Prototype = Prototype + 1
	if reg_moontools.search(html) != None:
		MoonTools = MoonTools + 1
	if reg_dojo.search(html) != None:
		Dojo = Dojo + 1
	if reg_yui.search(html) != None:
		YUI = YUI + 1

	libs = reg_jqeury_version.findall(html)		#find all jquery versions
	libslist = []
	for each in libs:							#remove identical lib in a page
		if each not in libslist:
			libslist.append(each)
	for each in libslist:
		if each in dict_jquery:					#use diction to sum
			dict_jquery[each] = dict_jquery[each] + 1
		else:
			dict_jquery[each] = 1
	#set is also a good choice. However, both may have some identical urls due to link-cycle
	#BETTER: use another list, pop and add, sum in the final(or store pages)
	for each in urls:
		if each not in urlslist:				#ensure the url are unique
			urlslist.append(each)
	urlslist.pop(0)



def Application_button_result():
	reply.delete('0.0', END)	
	#% is used to catenate strings
	content = "%s%d%s"%("Total num of pages: ", MAXNUM, "\n") 
	content += "%s%d%s"%("jquery: ", Jquery, "%\n")
	content += "%s%d%s"%("prototype: ", Prototype, "%\n")
	content += "%s%d%s"%("moontools: ", MoonTools, "%\n")
	content += "%s%d%s"%("dojo: ", Dojo, "%\n")
	content += "%s%d%s"%("yui: ", YUI, "%\n")
	reply.insert(END, content, 'green')			#insert new content into text area



def Application_button_clear():
	reply.delete('0.0', END)					#clear the text area



def Application_button_more():
	reply.delete('0.0', END)
	content = "%s%d%s%d%s"%("More about Jquery\nTotal num of pages: ", MAXNUM, "\nAll Jquery verision percentage: ", Jquery, "%\n\n")
	for each in dict_jquery:
		content += "%s%s%d%s"%(each, " :  ", dict_jquery[each], "%\n")
	reply.insert(END, content, 'green')



start = True
urlslist.append(url0)							#insert first element, just like queue
while urlslist != [] and urlnum < MAXNUM:		#notice the loop border
	visit(urlslist[0])
	if start == True and urlslist == []:
		print "Please ensure you have connected to the Internet!"
		exit()
	elif start == True:
		start = False

#compute the percentage for each JS lib
Jquery = Jquery * 100 / MAXNUM
Prototype = Prototype * 100 / MAXNUM
MoonTools = MoonTools * 100 / MAXNUM
Dojo = Dojo * 100 / MAXNUM
YUI = YUI * 100 / MAXNUM
for each in dict_jquery:
	dict_jquery[each] = dict_jquery[each] * 100 / MAXNUM

#use Tkinter to show result
root = Tk()
root.title(unicode('Javascript Statistics', 'utf-8'))

#create several frames as container
frame_left_top = Frame(width=400, height=300, bg='white')
frame_left_center_left = Frame(width=130, height=100)
frame_left_center_mid = Frame(width=130, height=100)
frame_left_center_right = Frame(width=130, height=100)
#frame_left_bottom = Frame(width=400, height=300, bg='white')
frame_right = Frame(width=200, height=700, bg='white')

#create elements needed, frame_left_bottom not used
info = Text(frame_left_top)
button_result = Button(frame_left_center_left, text=unicode('result', 'utf-8'), command=Application_button_result)
button_clear = Button(frame_left_center_mid, text=unicode('clear', 'utf-8'), command=Application_button_clear)
button_more = Button(frame_left_center_right, text=unicode('more', 'utf-8'), command=Application_button_more)
reply = Text(frame_right)

#use grid to set the position of containers
frame_left_top.grid(row=0, column=0, columnspan=3, padx=2, pady=5)
frame_left_center_left.grid(row=1, column=0)
frame_left_center_mid.grid(row=1, column=1)
frame_left_center_right.grid(row=1, column=2)
frame_right.grid(row=0, column=3, padx=4, pady=5)
#frame_left_bottom.grid(row=2, column=0, columnspan=3, padx=2, pady=5)

#father element's position/size is not relevant to child element
frame_left_top.propagate(False)			#True by default
frame_left_center_left.propagate(False)
frame_left_center_mid.propagate(False)
frame_left_center_right.propagate(False)
frame_right.propagate(False)

#put elements into frame
info.grid()												#sticky=E+W+S+N   how to extend
button_result.grid()
button_clear.grid()
button_more.grid()
reply.grid(sticky=S)

content =																\
"This application will show the distribution of JavaScript Libs.		\
\n\nFor each of [Jquery, Prototype, MoonTools, Dojo, YUI], we will		\
compute the rate of using it in web pages.								\
\n\nWhat's more, we will analyse the distribution of different version	\
of Jquery.																\
\n\nIf time permitted, we can do more statistics!\n"
info.insert(END, content, 'red')
root.mainloop()											#main loop for Tk GUI

#print buf.getvalue()
#fo = open("data/sites.html", "w+")
#fo.write(buf.getvalue())
#fo.close() 

buf.close()												#close the cStringIO buf
print "---END---"

