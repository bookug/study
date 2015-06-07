/*
* THIS FILE IS FOR IP FORWARD TEST
*/
#include "sysInclude.h"

// system support
extern void fwd_LocalRcv(char *pBuffer, int length);

extern void fwd_SendtoLower(char *pBuffer, int length, unsigned int nexthop);

extern void fwd_DiscardPkt(char *pBuffer, int type);

extern unsigned int getIpv4Address();

// implemented by students

unsigned short computeCheckSum(char* p, unsigned ihl)
{
	unsigned sum = 0, i;
	ihl *= 2;
	for(i = 0; i < ihl; ++i)
		if(i != 5)				//not include checksum itself
		{
			sum += ntohs(*((unsigned short*)p + i));
			sum %= 0xffff;		//in case of exceed
		}
	return 0xffff - (unsigned short)sum;	//~(unsigned short)sum
}
/*
typedef struct stud_route_msg
{
	unsigned dest;
	unsigned masklen;
	unsigned nexthop;
}stud_route_msg;
*/
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
	route_table_item get(unsigned _index)
	{
		return this->table[_index];
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
	route_item.mask = (1 << 31) >> (route_item.masklen - 1);	//QUERY:add 1 in left?
	route_item.dest_ip = ntohl(proute->dest) & route_item.mask;
	route_item.nexthop = ntohl(proute->nexthop);
	route_table.push(route_item);
	return;
}


int stud_fwd_deal(char *pBuffer, int length)
{
	unsigned short ihl = (*pBuffer) & 0xf, tlive = *(pBuffer + 8);
	unsigned short checksum;
	unsigned addr = ntohl(*((unsigned*)pBuffer + 4));

	//if need to check: checksum, ihl or others

	if(addr == getIpv4Address())  //QUERY:how about broadcast?
	{
		fwd_LocalRcv(pBuffer, length);
		return 0;
	}

	if(tlive <= 0)
	{
		fwd_DiscardPkt(pBuffer, STUD_FORWARD_TEST_TTLERROR);
		return 1;
	}

	//find the longest masklen match
	unsigned maxMasklen = 0;
	unsigned i, j = route_table.size();
	int ans = -1;
	route_table_item route_item;
	for(i = 0; i < j; ++i)
	{
		route_item = route_table.get(i);
		if(route_item.masklen > maxMasklen && route_item.dest_ip == (addr & route_item.mask))
		{
			maxMasklen = route_item.masklen;
			ans = i;
		}
	}

	if(ans == -1)
	{
		fwd_DiscardPkt(pBuffer, STUD_FORWARD_TEST_NOROUTE);
		return 1;
	}

	char* newpBuffer = (char*)malloc(length);
	memcpy(newpBuffer, pBuffer, length);
	*(newpBuffer+8) = tlive - 1;
	//compute checksum again
	checksum = computeCheckSum(newpBuffer, ihl);
	*((unsigned short*)newpBuffer + 5) = htons(checksum);
	fwd_SendtoLower(newpBuffer, length, route_table.get(ans).nexthop);
	return 0;
}
