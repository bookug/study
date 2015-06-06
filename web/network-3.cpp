/*
* THIS FILE IS FOR IP FORWARD TEST
*/
#include "sysInclude.h"

// system support
extern void fwd_LocalRcv(char *pBuffer, int length);

extern void fwd_SendtoLower(char *pBuffer, int length, unsigned int nexthop);

extern void fwd_DiscardPkt(char *pBuffer, int type);

extern unsigned int getIpv4Address( );

// implemented by students
typedef struct stud_route_msg
{
	unsigned dest;
	unsigned masklen;
	unsigned nexthop;
}stud_route_msg;

typedef struct route_table_item
{
	unsigned dest_ip;
	unsigned mask;
	unsigned masklen;
	unsigned nexthop;
}route_table_item;

#define MAX_ROUTE_NUM 1000

class RouteTable
{
private:
	unsigned count;
	route_table_item table[MAX_ROUTE_NUM];
public:
	RouteTable()
	{
		count = 0;
	}
	void push(route_table_item _item)
	{
		this->table[count] = _item;
		count++;
	}
	unsigned size()
	{
		return this->count;
	}
}route_table;

void stud_Route_Init()
{
	return;
}

void stud_route_add(stud_route_msg *proute)
{
	route_table_item route_item;
	route_item.masklen = ntohl(proute->masklen);
	route_item.mask = (1 << 31) >> (route_item.masklen - 1);
	route_item.dest_ip = ntohl(proute->dest) & route_item.mask;
	route_item.nexthop = ntohl(proute->nexthop);
	route_table.push(route_item);
	return;
}


int stud_fwd_deal(char *pBuffer, int length)
{
	unsigned short ihl = (*pBuffer) & 0xf, tlive = *(pBuffer + 8);
	unsigned short checksum = ntohs(*(unsigned short*)(pBuffer + 10));
	unsigned addr = ntohl(*((unsigned*)pBuffer + 4));

	if(addr == getIpv4Address())
	{
		fwd_LocalRcv(pBuffer, length);
		return 0;
	}

	if(tlive <= 0)
	{
		fwd_DiscardPkt(pBuffer, STUD_FORWARD_TEST_TTLERROR);
		return 1;
	}


	return 0;
}

