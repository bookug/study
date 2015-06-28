/*=============================================================================
 *# Filename: dijkstra.c
 *# Author: syzz
 *# Mail: 1181955272@qq.com
 *# Last Modified: 2015-06-23 23:14
 *# Description: 
 *1. solve shortest-path problem using Dijkstra algorithm(requiring that rank>0;all connected)
 *2. this is the simple multi-thread solution, and the graph is seemed as undirected.
 *3. graph is big-sparse, so use adjacent-list instead of adjacent-matrix
 *4. vars inside functions are stored in stack, not exceeding several Ms;
 *   vars(maybe array...) out of all functions are stored in data-segment, 10^8~10^10;
 *   memory allocated dynamiclly can be as large as physical memory available
 *=============================================================================*/

#include <stdio.h>
#include <omp.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>

#define MAX_LINE_LEN 100
#define INF 0xffffffff

unsigned cnt_vetex = 0, cnt_edge = 0;

typedef struct Edge
{
	struct Edge* next;
	unsigned to;
	unsigned rank;
}Edge;
Edge** edges;

typedef struct Path
{
	unsigned count;
	unsigned length;
	unsigned visit;
}Path;
Path* paths;

unsigned 
search_edge(unsigned i, unsigned j)
{
	if(i < 0 || i >= cnt_vetex || j < 0 || j >= cnt_vetex)
		return INF;
	if(i == j)
		return 0;
	Edge* p = edges[i];
	while(p != NULL)
	{
		if(p->to == j)
			return p->rank;
		p = p->next;
	}
	return INF;
}

void
add_edge(unsigned i, unsigned j, unsigned k)
{
	if(i < 0 || i >= cnt_vetex || j < 0 || j >= cnt_vetex || i == j)
		return;
	Edge* p = malloc(sizeof(Edge));
	p->next = edges[i];
	p->to = j;
	p->rank = k;
	edges[i] = p;
	paths[i].count++;
	cnt_edge++;
}

void
dijkstra()
{
	//assume the source node is 0
	unsigned i, j, k;
#pragma omp parallel for
	for(i = 0; i < cnt_vetex; ++i)
		paths[i].length = search_edge(0, i);
	paths[0].visit = 1;
	for(k = 1; k < cnt_vetex; ++k)
	{
		unsigned min = INF;
		//maybe to divide into parts: #pragma omp for/critical/barrier
		for(i = 0; i < cnt_vetex; ++i)
			if(paths[i].visit == 0 && paths[i].length < min)
			{
				min = paths[i].length;
				j = i;
			}
		paths[i].visit = 1;
		Edge* p = edges[j];
		//to parallel, here requires something like vector
		for(i = paths[j].count; i > 0; --i)
		{
			if(paths[p->to].visit == 1)
			{
				p = p->next;
				continue;
			}
			unsigned t = paths[j].length + p->rank;
			if(paths[p->to].length > t)
				paths[p->to].length = t;
			p = p->next;
		}
	}
}

int
main(int argc, const char* argv[])
{
	FILE* fp = fopen(argv[1], "r");
	if(fp == NULL)
	{
		printf("open error!\n");
		exit(1);
	}

	unsigned i, j, k;
	char str[MAX_LINE_LEN], c;
	while(fgets(str, MAX_LINE_LEN, fp) != NULL)
	{
		if(str[0] == 'p')
		{
			i = 5;
			for(j = 6; str[j] != ' '; ++j);
			for(k = i; k < j; ++k)
				cnt_vetex = cnt_vetex * 10 + str[k] - '0';
			edges = (Edge**)malloc(sizeof(Edge*) * cnt_vetex);
			paths = (Path*)malloc(sizeof(Path) * cnt_vetex);
			for(i = 0; i < cnt_vetex; ++i)
			{
				edges[i] = NULL;
				paths[i].count = paths[i].visit = 0;
			}
		}
		else if(str[0] == 'a')
		{
			fscanf(fp, "%c %u %u %u\n", &c, &i, &j, &k);
			add_edge(i-1, j-1, k);
			add_edge(j-1, i-1, k);
			break;
		}
	}
	while(fgets(str, MAX_LINE_LEN, fp) != NULL)
	{
		fscanf(fp, "%c %u %u %u\n", &c, &i, &j, &k);
		add_edge(i-1, j-1, k);
		add_edge(j-1, i-1, k);
	}

    printf("vertexs num: %u\t\t\tedges num: %u\n", cnt_vetex, cnt_edge);
	struct timeval t1, t2; 
	double timeuse;
	gettimeofday(&t1, NULL);
	dijkstra();
	gettimeofday(&t2, NULL);
	timeuse = t2.tv_sec - t1.tv_sec + (t2.tv_usec - t1.tv_usec)/1000000.0;
	unsigned xorsum = 0;
	for(i = 0; i < cnt_vetex; ++i)
		xorsum ^= paths[i].length;
	printf("xorsum: %u\n", xorsum);
	printf("timeuse: %fs\n", timeuse);
	return 0;
}

