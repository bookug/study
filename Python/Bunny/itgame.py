#! /usr/bin/env python

import pygame
#from pygame.locals import *

pygame.init()
#width, height = 640, 480
width = 640
height = 480
screen = pygame.display.set_mode((width, height))

player = pygame.image.load("/home/bookug/project/study/Python/Bunny/resources/images/dube.png")

while True:
	screen.fill(0)
	screen.blit(player, (100, 100))
	pygame.display.flip()
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			pygame.quit()
			exit(0)

