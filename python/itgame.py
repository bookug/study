#! /usr/bin/env python

import pygame
from pygame.locals import *

#initialize the game
pygame.init()
width, height = 640, 480
screen = pygame.display.set_mode((width, height))

image_path = "/home/syzz/project/data/resources/images/dube.png"
#load images
player = pygame.image.load(image_path).convert()

#keep looking through
while True:
	#clear the screen before drawing it again
	screen.fill(0)
	#draw the screen elements
	screen.blit(player, (100, 100))
	#update the screen
	pygame.display.flip()
	#look through the events
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			pygame.quit()
			exit(0)


