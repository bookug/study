#! /usr/bin/python
#coding=utf-8

class Clist:
	def __init__(self):		#initialize class
		self.list = []
		self.list_2 = []
	def list_del(self):		#empty list
		try:
			del self.list
			del self.list_2
		except:
			print u"fail to empty\n"
			return 0
	def list_lsqc(self):	#remove multiple in list
		try:
			for i in self.list:
				if i not in self.list_2:
					self.list_2.append(i)
		except:
			print u"fail to remove multiple in list\n"
			return 0
	def list_add(self, data):
		try:
			self.list.append(data)
		except:
			print u"fail to add element to list\n"
			return 0
	def list_CX(self, data):	#query if exist
		try:
			E = 0		
			while E < len(self.list):
				if self.list[E] == data:
					return 1
				E = E + 1;
			return 0
		except:
			print u"fail to search in list\n"
			return 0

