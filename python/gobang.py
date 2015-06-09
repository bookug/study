#! /usr/bin/env python

import os
import pdb

class Gobang:
	def __init__(self, maxx, maxy):
		self.maxx = maxx
		self.maxy = maxy
		self.chessboard = []
		for i in range(maxx):
			self.chessboard.append([])
			for j in range(maxy):
				self.chessboard[i].append(0)

	def start(self):
		who = False;
		os.system("cls")
		self.print_chessboard()
		while True:
			t=input('Please input(x,y),now is'+('O' if who else 'X')+':')
			t=t.split(',')
			if len(t)==2:                
				x=int(t[0])
				y=int(t[1])
				if self.chessboard[x][y]==0:
					self.chessboard[x][y]=1 if who else 2
					os.system('cls')
					self.print_chessboard()
					ans=self.isWin(x,y)
					if ans:
						print(('O'if who else 'X')+'Win')
						break
					who=not who
		os.system('pause')

	def isWin(self, xPoint, yPoint):
		pdb.set_trace
		flag = False;
		t=self.chessboard[xPoint][yPoint]
		x=xPoint
		y=yPoint
		count=0
		x=xPoint
		y=yPoint
		while (x>0 and t==self.chessboard[x][y]):
			count+=1
			x-=1
		x=xPoint
		y=yPoint
		while (x<self.maxx and t==self.chessboard[x][y]):
			count+=1
			x+=1
		if (count>5):return True
		count=0
		x=xPoint
		y=yPoint
		while (y>0 and t==self.qipan[x][y]):
			count+=1
			y-=1
			y=yPoint
		while (y<self.maxy and t==self.qipan[x][y]):
			count+=1
			y+=1
		if (count>5): return True
		count=0
		x=xPoint
		y=yPoint
		while (x>0 and y<self.maxy and t==self.chessboard[x][y]):
			count+=1
			x+=1
			y-=1
		x=xPoint
		y=yPoint
		while (x<self.maxx and y>0 and t==self.qipan[x][y]):
			count+=1
			x-=1
			y+=1
		if (count>5):return True
		count=0
		x=xPoint
		y=yPoint
		while (x>0 and y>0 and t==self.qipan[x][y]):
			count+=1
			x+=1
			y-=1
		x=xPoint
		y=yPoint
		while (x<self.maxx and y<self.maxy and t==self.qipan[x][y]):
			count+=1
			x-=1
			y+=1
		if (count>5): return True
		return False

	def print_chessboard(self):
		print(' 0123456789')
		for i in range(self.maxx):
			print(i,'')
			for j in range(self.maxy):
				if self.chessboard[i][j]==0:
					print('+','')
				elif self.chessboard[i][j]==1:
					print('O','')
				elif self.chessboard[i][j]==2:
					print('X','')
			print('\n')

if __name__ == '__main__':#run directly; as module when __name__ is the file without extending
	obj = Gobang(10, 10)
	#pdb.set_trace()
	obj.start()

