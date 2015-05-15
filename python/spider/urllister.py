#! /usr/bin/bash
#coding=utf-8

from sgmllib import SGMLParser

class URLLister(SGMLParser):	#this class dealing with html is child of SGMLParser
	def reset(self):
		try:
			SGMLParser.reset(self)
			self.urls = []
		except Exception, e:
			print "fail to reset", e, "\n"
			return 0
	def start_a(self, attrs):	#search all <a> flag
		try:
			href = [v for k, v in attrs if k == 'href']		#return a list
			if href:
				self.urls.extend(href)
		except Exception, e:
			print "fail to search all <a>", e, "\n"
			return 0

