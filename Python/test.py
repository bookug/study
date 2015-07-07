#! /usr/bin/env python

import sys

print sys.platform
print 2 ** 100
print "sb!" * 10
raw_input()		#needed in windows to avoid fast-disappearing
#NTC: in Python2.x, raw_input receives a string, while input computes for a string
#However, in Python3.x, input is used instead of raw_input

import pygame

if pygame.font is None:
	print "The font module is not available!"
	exit()
background_image_filename = "/home/syzz/project/data/sushiplate.jpg"
mouse_image_filename = "/home/syzz/project/data/fugu.png"
from pygame.locals import *

#initialize the hardware
pygame.init()
#create a Surface object. set_mode: resolution, flag, color-depth
screen = pygame.display.set_mode((640, 480), 0, 32)
pygame.display.set_caption("Hello World!")
background = pygame.image.load(background_image_filename).convert()
mouse_cursor = pygame.image.load(mouse_image_filename).convert_alpha()

while True:
	for event in pygame.event.get():
		if event.type == QUIT:
			exit()
	screen.blit(background, (0, 0))
	x, y = pygame.mouse.get_pos()
	x -= mouse_cursor.get_width() / 2
	y -= mouse_cursor.get_height() / 2
	#Surface, left-top position
	screen.blit(mouse_cursor, (x, y))
	#update the real screen, otherwise all black
	pygame.display.update()

