/*=============================================================================
# Filename: hello.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-06-04 15:04
# Description: 
=============================================================================*/

#include <stdio.h>
#include <ncurses.h>

#define LEFTEDGE 10
#define RIGHTEDGE 30
#define ROW 10

int
main(int argc, const char* argv[])
{
	int i;
	char message[] = "hello";
	char blank[] = "     ";
	int dir = +1;
	int pos = LEFTEDGE;

	initscr();
	clear();

	while(1)
	{
		move(ROW, pos);
		addstr(message);
		move(LINES - 1, COLS - 1);
		refresh();
		sleep(1);
		move(ROW, pos);
		addstr(blank);
		pos += dir;
		if(pos >= RIGHTEDGE)
			dir = -1;
		if(pos <= LEFTEDGE)
			dir = +1;
	}

	/*
	for(i = 0; i < LINES; ++i)
	{
		move(i, i + i);
		if(i % 2 == 1)
			standout();
		addstr("Hello, world");
		if(i % 2 == 1)
			standend();
		refresh();
		sleep(1);
		move(i, i + i);
		addstr("            ");
	}
	*/
	endwin();
	return 0;
}

