/*=============================================================================
# Filename: dijkstra.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-06-23 23:14
# Description: 
1. solve shortest-path problem using Dijkstra algorithm(requiring that rank>0)
2. this is the single-thread solution, and the graph is seemed as undirected.
3. graph is big-sparse, so use adjacent-list instead of adjacent-matrix
4. vars inside functions are stored in stack, not exceeding several Ms;
   vars(maybe array...) out of all functions are stored in data-segment, 10^8~10^10;
   memory allocated dynamiclly can be as large as physical memory available
=============================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_VERTEX_NUM 1000000
#define MAX_EDGE_NUM 1000000
#define MAX_LINE_LEN 100
#define INFINITE 0xffffffff

unsigned cnt_vetex =0, cnt_edge = 0;

typedef struct Edge 
{
	struct Edge* next;
	unsigned to;
	unsigned rank;
}Edge;
Edge* edges[MAX_EDGE_NUM];

unsigned search_edge(unsigned i, unsigned j)
{
	if(i < 0 || i >= cnt_vetex || j < 0 || j >= cnt_vetex)
		return INFINITE;
	unsigned k;
	if(i == j)
		return 0;
	else if(i > j)
	{
		k = i;
		i = j;
		j = k;
	}
	Edge* p = edges[i];
	while(p != NULL)
	{
		if(p->to == j)
			return p->rank;
		p = p->next;
	}
	return INFINITE;
}

void add_edge(unsigned i, unsigned j, unsigned k)
{
	if(i < 0 || i >= cnt_vetex || j < 0 || j >= cnt_vetex || i == j)
		return;
	unsigned t;
	if(i > j)
	{
		t = i;
		i = j;
		j = t;
	}
	Edge* p = malloc(sizeof(Edge));
	p->next = edges[i];
	p->to = j;
	p->rank = k;
	edges[i] = p;
}


typedef struct Path
{
	unsigned to;
	unsigned length;
}Path;
Path paths[MAX_VERTEX_NUM];


void dijkstra()
{
	//assume the source node is 0
	unsigned i, j, k;		//k is the num of nodes added
	Path t;
	//initialize the paths array
	for(i = 0; i < cnt_vetex; ++i)
	{
		paths[i].length = search_edge(0, i);
		paths[i].to = i;
	}

	for(k = 1; k < cnt_vetex; ++k)
	{
		unsigned min = INFINITE;
		for(i = k; i < cnt_vetex; ++i)	
			if(paths[i].length < min)
			{
				min = paths[i].length;
				j = i;
			}
		if(j != k)
		{
			t = paths[k];
			paths[k] = paths[j];
			paths[j] = t;
		}
		for(i = k + 1; i < cnt_vetex; ++i)
		{
			j = paths[k].length + search_edge(paths[k].to, paths[i].to);
			if(paths[i].length > j)
				paths[i].length = j;
		}
	}
}

int main(int argc, const char* argv[])
{
	printf("the program starts!\n");
	FILE* fp = fopen("/home/qzxx/project/data/USA-road-d.NY.gr", "r");
	if(fp == NULL)
	{
		printf("open error!\n");
		exit(1);
	}

	unsigned i, j, k;
	for(i = 0; i < MAX_EDGE_NUM; ++i)
		edges[i] = NULL;
	char str[MAX_LINE_LEN], c;
	while(fgets(str, MAX_LINE_LEN, fp) != NULL)
	{
		//puts(str);
		if(str[0] == 'p')
		{
			i = 5;
			for(j = 6; str[j] != ' '; ++j);
			for(k = i; k < j; ++k)
				cnt_vetex = cnt_vetex * 10 + str[k] - '0';
		}
		else if(str[0] == 'a')
		{
			fscanf(fp, "%c %u %u %u\n", &c, &i, &j, &k);
			/*
			edges[cnt_edge].v1 = i;
			edges[cnt_edge].v2 = j;
			edges[cnt_edge].rank = k;
			*/
			cnt_edge++;
			if(i == 0 || j == 0)
				printf("error index!\n");
			else
				add_edge(i-1, j-1, k);
			break;
		}
	}
	while(fgets(str, MAX_LINE_LEN, fp) != NULL && cnt_edge < MAX_EDGE_NUM)
	{
		fscanf(fp, "%c %u %u %u\n", &c, &i, &j, &k);
		/*
		edges[cnt_edge].v1 = i;
		edges[cnt_edge].v2 = j;
		edges[cnt_edge].rank = k;
		*/
		cnt_edge++;
		if(i == 0 || j == 0)
			printf("error index!\n");
		else
			add_edge(i-1, j-1, k);
	}

	printf("vertexs num: %u\t\t\tedges num: %u\n", cnt_vetex, cnt_edge);
	for(i = 0; i < cnt_vetex; ++i)
	{
		for(j = 0; j < cnt_vetex; ++j)
			printf("%u ", search_edge(i, j));
		printf("\n");
	}
	clock_t time = clock();
	dijkstra();
	time = clock() - time;
	unsigned xorsum = 0;
	for(i = 0; i < cnt_vetex; ++i)
	{
		printf("vertex%u: %u\n", paths[i].to, paths[i].length);
		xorsum ^= paths[i].length;
	}
	printf("xorsum: %u\n", xorsum);
	printf("time cost: %us\n", time/CLOCKS_PER_SEC);
	return 0;
}

