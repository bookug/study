#! /usr/bin/python
#coding=utf-8

import re, cStringIO, urllib, urllister, socket, Queue, threading, time
from threading import Thread
import list, urllister

socket.setdefaulttimeout(5)
#message queue
openurl = Queue.Queue(0)
class Class_url_www(threading.Thread):		#collect url
	def __init__(self, LS):
		threading.Thread.__init__(self)
		self.LS = LS
		self.urlname = "site.baidu.com"		#domain key name
		openurl.put("http://site.baidu.com", 0.5)	#insert into queue
	def run(self):
		try:
			print u"message queue:", openurl.qsize()
			print u"already scanned:", len(self.LS.list)
			if openurl.empty():
				print u"message queue is empty"
				time.sleep(20)
				self.run()
			self.data(self.Chost)			#traversal links in the page
			self.run()
		except:
			self.run()
	def data(self, url):
		try:
			if self.LS.list_CX(url):		#query if the link is visited
				print "this url is already visited:", url
				return 0
			self.LS.list_add(url)
			self.TXT_file(url)				#write the text
			print u"start to collect:", url
			list_2 = []
			list = self.getURL(url)
			for i in list:					#delete the multiple data
				if i not in list_2:
					if self.urlname in i:
						list_2.append(i)
			if len(list_2) > 0:
				for url in list_2:
					if "http://" in url:
						openurl.put(url.strip().lstrip().rstrip('\n'), 0.5) #insert into queue
		except Exception, e:
			print "error in data:", e
			self.run()
			return 0
	def getURL(self, url):					#put url of HTML in urls list
		try:
			try:
				usock = urllib.urlopen(url)
			except:
				print "error in getURL"
				return []
			parser = urllister.URLLister()
			parser.feed(usock.read())
			usock.close()
			parser.close()
			urls = parser.urls
			return urls
		except Exception, e:
			print u"error in getURL:", e
			return 0
	def TXT_file(self, data):		#write the text
		try:
			file_object = open("url.txt", "a")
			file_object.writelines(data)
			file_object.writelines("\n")
			file_object.close()
		except Exception, e:
			print u"fail to write text:", e
			return 0

if __name__ == '__main__':
	LS = list.Clist()
	threads = []
	for i in range(10):
		threads.append(Class_url_www(LS))
	for t in threads:
		t.start()


