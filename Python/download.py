#! /usr/bin/bash
#coding=utf-8

#this class is mainly used to crawl the deep url in the urls 

import urlparse, urllib, re, os

class SpiderMulti:  
	def read(self, url):
		urlli=self.analy(url)  
		urldic = {}  
		cutli=urlli[1:]  
		for x in cutli:  
			urldic.update(x)  
		for url in [x.keys()[0] for x in cutli]:  
			if self.islink(url, urldic):  
				print url  
				self.read(url)
			else:  
				self.download(url, urldic)  
	def analy(self, url):
		urlli = []
		try:
			html=urllib.urlopen(url).read().split('\n')
			originalUrl = url
			for line in html:
				currentFind = re.search(r'href="(.*?)"', line, re.IGNORECASE|re.DOTALL)
				if currentFind:
					urldict = {}
					curUrl = urlparse.urljoin(orignalUrl,currentFind.group(1)) 
					dirFind = re.search(r'class="t".*?>(.*?)<',line,re.IGNORECASE|re.DOTALL)
					curDir = dirFind.group(1)
					urldic[curUrl] = curDir
					urlli.append(urldic)
		except:
			print "can not open: ", url
			pass
		return urlli
	def islink(self, url, urldic):
		if urldic[url] == 'Directory':
			return True
		else:
			return False
	def isfile(self, url):
		if re.search(r'doc$|pdf$', url, re.IGNORECASE|re.DOTALL):  
			return True  
		else:  
			return False
	def download(self, url, urldic):
		print '=====:', url, urldic[url]  
		if (self.isfile(url)):  
			name = os.path.join(r'd:\data', url.split('/')[-1])  
			print 'down: ', url, name  
			try:  
				f = urllib.urlretrieve(url, name)  
			except:  
					print 'can not writtofile'  
					pass
	
if __name__ == '__main__':
	t=SpiderMulti()  
	url='http://kalug.linux.org.tw/~shawn/project/thesis/'  
	t.read(url)

