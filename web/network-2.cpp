/*
* THIS FILE IS FOR IP TEST
*/
// system support
#include "sysInclude.h"

extern void ip_DiscardPkt(char* pBuffer,int type);

extern void ip_SendtoLower(char*pBuffer,int length);

extern void ip_SendtoUp(char *pBuffer,int length);

extern unsigned int getIpv4Address();

// implemented by students

int stud_ip_recv(char *pBuffer,unsigned short length)
{
	unsigned short version, ihl, tlive, checksum;
	unsigned addr, sum, i;			//dest address

	version = (*pBuffer) >> 4;
	ihl = (*pBuffer) & 0xf;
	tlive = *(pBuffer + 8);
	checksum = ntohl(*(unsigned short*)(pBuffer + 10));
	addr = ntohl(*((unsigned*)pBuffer + 4));

	if(version != 4)
	{
		ip_DiscardPkt(pBuffer, STUD_IP_TEST_VERSION_ERROR);
		return 1;
	}
	if(ihl < 5)
	{
		ip_DiscardPkt(pBuffer, STUD_IP_TEST_HEADLEN_ERROR);
		return 1;
	}
	if(tlive == 0)
	{
		ip_DiscardPkt(pBuffer, STUD_IP_TEST_TTL_ERROR);
		return 1;
	}
	if(address != getIpv4Address() && address != 0xffffffff)
	{
		ip_DiscardPkt(pBuffer, STUD_IP_TEST_DESTINATION_ERROR);
		return 1;
	}

	sum = 0;
	ihl *= 4;
	for(i = 0; i < ihl; ++i)
	{
		sum += *(pBuffer + i);
	}
	for(i = 0; i < 2; ++i)
		sum = (sum >> 16) + (sum & 0xffff);
	if(sum != checksum)
	{
		ip_DiscardPkt(pBuffer, STUD_IP_TEST_TTL_ERROR);
		return 1;
	}

	ip_SendtoUp(pBuffer, length);		//QUERY: pBuffer?
	return 0;
}

int stud_ip_Upsend(char *pBuffer,unsigned short len,unsigned int srcAddr,
				   unsigned int dstAddr,byte protocol,byte ttl)
{
	unsigned newlen = 5 * 4 + len;
	char* newpBuffer = (char*)malloc(newlen);
	memcpy(newpBuffer + 20, pBuffer, len);
	*newpBuffer = (4 << 4) + 5;
	srand(NULL);
	*((unsigned short*)(newpBuffer + 4)) = rand();
	*(newpBuffer + 8) = ttl;
	*(newpBuffer + 9) = protocol;
	*((unsigned*)newpBuffer + 3) = htonl(srcAddr);
	*((unsigned*)newpBuffer + 4) = htonl(dstAddr);

	//TODO: compute the check-sum

	ip_SendtoLower(newpBuffer, newlen);

	return 0;
}

