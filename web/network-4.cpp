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

#define MAX_TCP_CONNECTIONS 5

enum TcpState { CLOSED, SYN_SENT, ESTABLISHED, FIN_WAIT1, FIN_WAIT2, TIME_WAIT };

typedef struct Tcb
{
	TcpState state;
	unsigned client_ip;
	unsigned server_ip;
	unsigned short client_port;
	unsigned short server_port;
	unsigned seq, ack;
	unsigned char flag;
	unsigned io_type, data_ack;
	bool is_used;
	unsigned char data[2048];
	unsigned short data_len;
}Tcb;
Tcb tcblist[MAX_TCP_CONNECTIONS];

typedef struct Pkt
{
	unsigned short src_port;
	unsigned short dst_port;
	unsigned seq;
	unsigned ack;
	unsigned char hdr_len;	//higher 4 bits
	unsigned char flag;
	unsigned short window_size;
	unsigned short checksum;
	unsigned short urg_ptr;	//urgent pointer
	unsigned char data[2048];
	unsigned short data_len;
}Pkt;

unsigned client_port = 2007;
unsigned server_port = 2006;
unsigned seq_num = 1234, ack_num = 0;
bool is_ready = false;

unsigned short
computeCheckSum(Tcb* p1, Pkt* p2)
{
	unsigned sum = 0, i = 0, len = 0;
	unsigned short* p = (unsigned short*)p2;
	if(p1 == NULL || p2 == NULL)
		return 0;
	//TODO
	return 0xffff - sum;
}

int 
stud_tcp_input(char *pBuffer, unsigned short len, unsigned int srcAddr, unsigned int dstAddr)
{
	Pkt pkt;
	int sock_fd = -1;
	if(len < 20)
		return -1;
	if(is_ready == false)
	{
		tcp_init(1);
		tcblist[1].server_ip = getServerIpv4Address();
		tcblist[1].server_port = ...
		is_ready = true;
	}
	memcpy(&pkt, pBuffer, len);
	return 0;
}

void 
stud_tcp_output(char *pData, unsigned short len, unsigned char flag, unsigned short srcPort, unsigned short dstPort, unsigned int srcAddr, unsigned int dstAddr)
{

}

int 
stud_tcp_socket(int domain, int type, int protocol)
{
	return 2;
}

int 
stud_tcp_connect(int sockfd, struct sockaddr_in *addr, int addrlen)
{
	return 0;
}

int 
stud_tcp_send(int sockfd, const unsigned char *pData, unsigned short datalen, int flags)
{
	return 0;
}

int 
stud_tcp_recv(int sockfd, unsigned char *pData, unsigned short datalen, int flags)
{
	return 0;
}

int 
stud_tcp_close(int sockfd)
{
	return 0;
}

