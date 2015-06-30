/*
* THIS FILE IS FOR TCP TEST
*/

/*
struct sockaddr_in {
        short   sin_family;
        u_short sin_port;
        struct  in_addr sin_addr;
        char    sin_zero[8];
};
*/

#include "sysInclude.h"

extern void tcp_DiscardPkt(char *pBuffer, int type);

extern void tcp_sendReport(int type);

extern void tcp_sendIpPkt(unsigned char *pData, UINT16 len, unsigned int  srcAddr, unsigned int dstAddr, UINT8	ttl);

extern int waitIpPacket(char *pBuffer, int timeout);

extern unsigned int getIpv4Address();

extern unsigned int getServerIpv4Address();

#define MAX_TCP_CONNECTION_NUM 10
#define MIN_TCP_HEADER_SIZE 20
#define MAX_DATA_SIZE 2048
#define DEFAULT_TTL 64
#define MAX_TIME_OUT 1000

enum TcpState { CLOSED, SYN_SENT, ESTABLISHED, FIN_WAIT1, FIN_WAIT2, TIME_WAIT };

typedef struct Tcb
{
	bool is_used;
	unsigned srcAddr;
	unsigned dstAddr;
	unsigned short srcPort;
	unsigned short dstPort;
	unsigned seq, ack;
	unsigned short window_size;
	TcpState state;
}Tcb;
Tcb tcblist[MAX_TCP_CONNECTION_NUM];

typedef struct Pkt
{
	unsigned short srcPort;
	unsigned short dstPort;
	unsigned seq, ack;
	unsigned char hdr_len;
	unsigned char flag;
	unsigned short window_size;
	unsigned short checksum;
	unsigned short urg_ptr;	//urgent pointer
	unsigned char data[MAX_DATA_SIZE];
	//unsigned short data_len;
}Pkt;

typedef struct PseudoHeader		//just for verifying checksum
{
	unsigned srcAddr;
	unsigned dstAddr;
	char mbz;					//must-be-zero, used for aligning
	char protocol;				//8-bit protocol num
	unsigned short len;			//length of TCP package
}Header;

unsigned srcPort = 2007;
unsigned dstPort = 2006;
unsigned seqNum = 1234, ackNum = 0;	//QUERY: number here?
int current_sockfd = -1;

/* To compute checksum for TCP, need to add PseudoHeader
 * If not adding checksum itself, then the result should be equal to checksum
 * Else, the result should be equal to 0, and why this is as follows:
 * ~a = b <-> ~(a+b) = 0
 */
unsigned short
computeCheckSum(Header* p1, char* p2, unsigned short len)
{							//all Internet bytes
	unsigned sum = 0, i;	//sum need to be unsigned
	unsigned short* p = (unsigned short*)p1;
	for(i = 0; i < 6; ++i, ++p)
		sum = (sum + (*p)) % 0xffff;
	len /= 2;
	for(i = 0, p = (unsigned short*)p2; i < len; ++i, ++p)
		sum = (sum + (*p)) % 0xffff;
	return 0xffff - sum;
}

int 
stud_tcp_input(char *pBuffer, unsigned short len, unsigned int srcAddr, unsigned int dstAddr)
{
	Header head;
	Pkt* ppkt = (Pkt*)pBuffer;
	head.srcAddr = htonl(tcblist[current_sockfd].srcAddr);
	head.dstAddr = htonl(tcblist[current_sockfd].dstAddr);
	head.mbz = 0;
	head.protocol = IPPROTO_TCP;
	head.len = htons(MIN_TCP_HEADER_SIZE);
	//compare the checksum
	if(computeCheckSum(&head, pBuffer, len) != 0xffff)
		return -1;
	//check the seq and ack
	unsigned t = (tcblist[current_sockfd].state == FIN_WAIT2)?0:1;
	if(ntohl(ppkt->ack) != (tcblist[current_sockfd].seq + t))
	{
		tcp_DiscardPkt(pBuffer, STUD_TCP_TEST_SEQNO_ERROR);
		return -1;
	}
	//transfer the status
	tcblist[current_sockfd].ack = ntohl(ppkt->seq) + 1;
	tcblist[current_sockfd].seq = ntohl(ppkt->ack);
	switch(tcblist[current_sockfd].state)
	{
		case FIN_WAIT1:
			tcblist[current_sockfd].state = FIN_WAIT2;
			return 0;
		case FIN_WAIT2:
			tcblist[current_sockfd].state = TIME_WAIT;
			break;
		case SYN_SENT:
			tcblist[current_sockfd].state = ESTABLISHED;
			break;
		default:
			return -1;
	}
	//reply to ack package
	stud_tcp_output(NULL, 0, PACKET_TYPE_ACK, srcPort, dstPort, getIpv4Address(), getServerIpv4Address());
	return 0;
}

void 
stud_tcp_output(char *pData, unsigned short len, unsigned char flag, unsigned short srcPort, unsigned short dstPort, unsigned int srcAddr, unsigned int dstAddr)
{
	//verify the sockfd
	if(current_sockfd < 0 || current_sockfd >= MAX_TCP_CONNECTION_NUM || tcblist[current_sockfd].is_used == false)		
	{
		current_sockfd = 0;
		tcblist[current_sockfd].is_used = true;
		tcblist[current_sockfd].window_size = 1;
		tcblist[current_sockfd].seq = seqNum;
		tcblist[current_sockfd].ack = ackNum;
		tcblist[current_sockfd].srcAddr = srcAddr;
		tcblist[current_sockfd].dstAddr = dstAddr;
		tcblist[current_sockfd].srcPort = srcPort;
		tcblist[current_sockfd].dstPort = dstPort;
		tcblist[current_sockfd].state = CLOSED;
	}
	//transfer the state 
	if(flag == PACKET_TYPE_SYN && tcblist[current_sockfd].state == CLOSED)
		tcblist[current_sockfd].state = SYN_SENT;
	if(flag == PACKET_TYPE_FIN_ACK && tcblist[current_sockfd].state == ESTABLISHED)
		tcblist[current_sockfd].state = FIN_WAIT1;
	//send the package
	Pkt* ppkt = (Pkt*)malloc(len + MIN_TCP_HEADER_SIZE);
	if(pData != NULL)
		memcpy((char*)ppkt+MIN_TCP_HEADER_SIZE, pData, len);
	ppkt->srcPort = htons(tcblist[current_sockfd].srcPort);
	ppkt->dstPort = htons(tcblist[current_sockfd].dstPort);
	ppkt->seq = htonl(tcblist[current_sockfd].seq);
	ppkt->ack = htonl(tcblist[current_sockfd].ack);
	ppkt->hdr_len = 0x50;		//4-bit for header len, it's 5 * 4-bytes
	ppkt->flag = flag;		//just one byte
	ppkt->window_size = htons(1);
	ppkt->urg_ptr = 0;
	Header head;
	head.srcAddr = htonl(tcblist[current_sockfd].srcAddr);
	head.dstAddr = htonl(tcblist[current_sockfd].dstAddr);
	head.mbz = 0;
	head.protocol = IPPROTO_TCP;
	head.len = htons(MIN_TCP_HEADER_SIZE + len);
	ppkt->checksum = 0;	//this is must needed!
	ppkt->checksum = computeCheckSum(&head, (char*)ppkt, MIN_TCP_HEADER_SIZE + len);
	tcp_sendIpPkt((unsigned char*)ppkt, MIN_TCP_HEADER_SIZE + len, srcAddr, dstAddr, DEFAULT_TTL);
}

int 
stud_tcp_socket(int domain, int type, int protocol)
{
	if(domain != AF_INET || type != SOCK_STREAM || protocol != IPPROTO_TCP)
		return -1;
	//NOTICE: sockfd 0 is assigned to system communication
	unsigned i;
	for(i = 1; i < MAX_TCP_CONNECTION_NUM; ++i)
		if(tcblist[i].is_used == false)
			break;
	if(i == MAX_TCP_CONNECTION_NUM)
		return -1;
	tcblist[i].is_used = true;
	tcblist[i].window_size = 1;
	tcblist[i].seq = seqNum;
	tcblist[i].ack = ackNum;
	tcblist[i].srcAddr = getIpv4Address();
	tcblist[i].dstAddr = getServerIpv4Address();
	tcblist[i].srcPort = srcPort++;		//need to update
	tcblist[i].dstPort = dstPort;
	tcblist[i].state = CLOSED;
	return i;
}

int 
stud_tcp_connect(int sockfd, struct sockaddr_in *addr, int addrlen)
{
	if(sockfd < 0 || sockfd >=MAX_TCP_CONNECTION_NUM || tcblist[sockfd].is_used == false)
		return -1;
	current_sockfd = sockfd;
	//initialize the tcb struct
	tcblist[current_sockfd].dstPort = ntohs(addr->sin_port);
	tcblist[current_sockfd].state = SYN_SENT;
	//send SYN package to request for connection
	stud_tcp_output(NULL, 0, PACKET_TYPE_SYN, tcblist[current_sockfd].srcPort, tcblist[current_sockfd].dstPort, tcblist[current_sockfd].srcAddr, tcblist[current_sockfd].dstAddr);
	//wait for server's SYN_ACK package
	Pkt* ppkt = new Pkt;
	while(true)
	{
		if(waitIpPacket((char*)ppkt, MAX_TIME_OUT) != -1)
			break;
	}
	//deal with the SYN_ACK package received
	if(ppkt->flag = PACKET_TYPE_SYN_ACK)
	{
		tcblist[current_sockfd].ack = ntohl(ppkt->seq) + 1;
		tcblist[current_sockfd].seq = ntohl(ppkt->ack);
		stud_tcp_output(NULL, 0, PACKET_TYPE_ACK, tcblist[current_sockfd].srcPort, tcblist[current_sockfd].dstPort, tcblist[current_sockfd].srcAddr, tcblist[current_sockfd].dstAddr);
		tcblist[current_sockfd].state = ESTABLISHED;
		return 0;
	}
	return -1;
}

int 
stud_tcp_send(int sockfd, const unsigned char *pData, unsigned short datalen, int flags)
{
	if(sockfd < 0 || sockfd >= MAX_TCP_CONNECTION_NUM || tcblist[sockfd].is_used == false || tcblist[sockfd].state != ESTABLISHED)
		return -1;
	current_sockfd = sockfd;
	if(tcblist[current_sockfd].window_size == 0)
		return -1;
	else
		tcblist[current_sockfd].window_size = 0;
	stud_tcp_output((char*)pData, datalen, PACKET_TYPE_DATA, tcblist[current_sockfd].srcPort, tcblist[current_sockfd].dstPort, tcblist[current_sockfd].srcAddr, tcblist[current_sockfd].dstAddr);
	//wait for server's ack package
	Pkt* ppkt = new Pkt;
	while(true)
	{
		if(waitIpPacket((char*)ppkt, MAX_TIME_OUT) != -1)
			break;
	}
	//deal with ack package received, if carried
	if(ppkt->flag == PACKET_TYPE_ACK)
	{
		if(ntohl(ppkt->ack) != (tcblist[current_sockfd].seq + datalen))
		{
			tcp_DiscardPkt((char*)ppkt, STUD_TCP_TEST_SEQNO_ERROR);
			return -1;
		}
		tcblist[current_sockfd].ack = ntohl(ppkt->seq) + datalen;
		tcblist[current_sockfd].seq = ntohl(ppkt->ack);
		tcblist[current_sockfd].window_size = 1;
		return 0;
	}
	return -1;
}

int 
stud_tcp_recv(int sockfd, unsigned char *pData, unsigned short datalen, int flags)
{
	if(sockfd < 0 || sockfd >= MAX_TCP_CONNECTION_NUM || tcblist[sockfd].is_used == false || tcblist[sockfd].state != ESTABLISHED)
		return -1;
	current_sockfd = sockfd;
	Pkt* ppkt = new Pkt;
	int size;
	while(true)
	{
		if((size = waitIpPacket((char*)ppkt, MAX_TIME_OUT)) != -1)
			break;
	}
	size = (size > datalen)?datalen:size;
	for(unsigned i = 0; i < size; ++i)
		pData[i] = ppkt->data[i];
	stud_tcp_output(NULL, 0, PACKET_TYPE_ACK, tcblist[current_sockfd].srcPort, tcblist[current_sockfd].dstPort, tcblist[current_sockfd].srcAddr, tcblist[current_sockfd].dstAddr);
	return 0;
}

//To destroy a tcb arrowed by sockfd, sockfd is valid by default
void
destroyTcb(int sockfd)
{
	tcblist[sockfd].is_used = false;
	tcblist[sockfd].srcAddr = 0x0;
	tcblist[sockfd].dstAddr = 0x0;
	tcblist[sockfd].srcPort = 0x0;
	tcblist[sockfd].dstPort = 0x0;
	tcblist[sockfd].state = CLOSED;
}

int 
stud_tcp_close(int sockfd)
{
	if(sockfd < 0 || sockfd >= MAX_TCP_CONNECTION_NUM || tcblist[sockfd].is_used == false || tcblist[sockfd].state != ESTABLISHED)
		return -1;
	current_sockfd = sockfd;
	//send FIN_ACK package to request for closing
	stud_tcp_output(NULL, 0, PACKET_TYPE_FIN_ACK, tcblist[current_sockfd].srcPort, tcblist[current_sockfd].dstPort, tcblist[current_sockfd].srcAddr, tcblist[current_sockfd].dstAddr);
	tcblist[current_sockfd].state = FIN_WAIT1;
	//wait for server's ACK package
	Pkt* ppkt = new Pkt;
	while(true)
	{
		if(waitIpPacket((char*)ppkt, MAX_TIME_OUT) != -1)
			break;
	}
	if(ppkt->flag != PACKET_TYPE_ACK)
	{
		destroyTcb(current_sockfd);
		return -1;
	}
	//wait for server's FIN_ACK package
	tcblist[current_sockfd].state = FIN_WAIT2;
	while(true)
	{
		if(waitIpPacket((char*)ppkt, MAX_TIME_OUT) != -1)
			break;
	}
	if(ppkt->flag != PACKET_TYPE_FIN_ACK)
	{
		destroyTcb(current_sockfd);
		return -1;
	}
	tcblist[current_sockfd].ack = ntohl(ppkt->seq) + 1;
	tcblist[current_sockfd].seq = ntohl(ppkt->ack);
	stud_tcp_output(NULL, 0, PACKET_TYPE_ACK, tcblist[current_sockfd].srcPort, tcblist[current_sockfd].dstPort, tcblist[current_sockfd].srcAddr, tcblist[current_sockfd].dstAddr);
	tcblist[current_sockfd].state = TIME_WAIT;
	destroyTcb(current_sockfd);
	return 0;
}
