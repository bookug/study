#include "sysinclude.h"

extern void tcp_DiscardPkt(char* pBuffer, int type);
extern void tcp_sendReport(int type);
extern void tcp_sendIpPkt(unsigned char* pData, UINT16 len, unsigned int srcAddr, unsigned int dstAddr, UINT8 ttl);
extern int waitIpPacket(char *pBuffer, int timeout);
extern unsigned int getIpv4Address();
extern unsigned int getServerIpv4Address();

#define INPUT 0
#define OUTPUT 1

#define NOT_READY 0
#define READY 1

#define DATA_NOT_ACKED 0
#define DATA_ACKED 1

#define NOT_USED 0
#define USED 1

#define MAX_TCP_CONNECTIONS 5

#define INPUT_SEG 0
#define OUTPUT_SEG 1

typedef int STATE;

enum TCP_STATES
{
	CLOSED,
	SYN_SENT,
	ESTABLISHED,
	FIN_WAIT1,
	FIN_WAIT2,
	TIME_WAIT,
};

int gLocalPort = 2007;
int gRemotePort = 2006;
int gSeqNum = 1234;
int gAckNum = 0;

struct MyTcpSeg
{
	unsigned short src_port;
	unsigned short dst_port;
	unsigned int seq_num;
	unsigned int ack_num;
	unsigned char hdr_len;
	unsigned char flags;
	unsigned short window_size;// ????????
	unsigned short checksum;//??
	unsigned short urg_ptr;
	unsigned char data[2048];//???
	unsigned short len;//????
};

struct MyTCB
{
	STATE current_state;
	unsigned int local_ip;
	unsigned short local_port;
	unsigned int remote_ip;
	unsigned short remote_port;
	unsigned int seq;
	unsigned int ack;
	unsigned char flags;
	int iotype;
	int is_used;
	int data_ack;
	unsigned char data[2048];
	unsigned short data_len;
};

struct MyTCB gTCB[MAX_TCP_CONNECTIONS];//TCB??
int initialized = NOT_READY;//?????????

int convert_tcp_hdr_ntoh(struct MyTcpSeg* pTcpSeg)//??????????????
{
	if( pTcpSeg NULL )
	{
		return -1;
	}

	pTcpSeg->src_port = ntohs(pTcpSeg->src_port);
	pTcpSeg->dst_port = ntohs(pTcpSeg->dst_port);
	pTcpSeg->seq_num = ntohl(pTcpSeg->seq_num);
	pTcpSeg->ack_num = ntohl(pTcpSeg->ack_num);
	pTcpSeg->window_size = ntohs(pTcpSeg->window_size);
	pTcpSeg->checksum = ntohs(pTcpSeg->checksum);
	pTcpSeg->urg_ptr = ntohs(pTcpSeg->urg_ptr);

	return 0;
}

int convert_tcp_hdr_hton(struct MyTcpSeg* pTcpSeg)//??????????????
{
	if( pTcpSeg NULL )
	{
		return -1;
	}

	pTcpSeg->src_port = htons(pTcpSeg->src_port);
	pTcpSeg->dst_port = htons(pTcpSeg->dst_port);
	pTcpSeg->seq_num = htonl(pTcpSeg->seq_num);
	pTcpSeg->ack_num = htonl(pTcpSeg->ack_num);
	pTcpSeg->window_size = htons(pTcpSeg->window_size);
	pTcpSeg->checksum = htons(pTcpSeg->checksum);
	pTcpSeg->urg_ptr = htons(pTcpSeg->urg_ptr);

	return 0;
}

unsigned short tcp_calc_checksum(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg) //??TCP?checksum
{
	int i = 0;
	int len = 0;
	unsigned int sum = 0;
	unsigned short* p = (unsigned short*)pTcpSeg;

	if( pTcb NULL || pTcpSeg NULL )
	{
		return 0;
	}

	for( i=0; ilen) > 20 )
	{
		if( len % 2 1 )
		{
			pTcpSeg->data[len - 20] = 0;
			len++;
		}

		for( i=10; ilocal_ip>>16)
			+ (unsigned short)(pTcb->local_ip&0xffff)
				+ (unsigned short)(pTcb->remote_ip>>16)
				+ (unsigned short)(pTcb->remote_ip&0xffff);
		sum = sum + 6 + pTcpSeg->len;
		sum = ( sum & 0xFFFF ) + ( sum >> 16 );
		sum = ( sum & 0xFFFF ) + ( sum >> 16 );

		return (unsigned short)(~sum);
	}

	int get_socket(unsigned short local_port, unsigned short remote_port)
	{
		int i = 1;
		int sockfd = -1;

		for( i=1; isrc_port = pTcb->local_port;
				pTcpSeg->dst_port = pTcb->remote_port;
				pTcpSeg->seq_num = pTcb->seq;
				pTcpSeg->ack_num = pTcb->ack;
				pTcpSeg->hdr_len = (unsigned char)(0x50);
				pTcpSeg->flags = pTcb->flags;
				pTcpSeg->window_size = 1024;
				pTcpSeg->urg_ptr = 0;

				if( datalen > 0 && pData != NULL )
				{
				memcpy(pTcpSeg->data, pData, datalen);
				}

				pTcpSeg->len = 20 + datalen;

				return 0;
				}

				int tcp_kick(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
				{
					pTcpSeg->checksum = tcp_calc_checksum(pTcb, pTcpSeg);

					convert_tcp_hdr_hton(pTcpSeg);

					tcp_sendIpPkt((unsigned char*)pTcpSeg, pTcpSeg->len, pTcb->local_ip, pTcb->remote_ip, 255);

					memcpy(&(pTcb->last_seg), pTcpSeg, pTcpSeg->len);

					if( (pTcb->flags & 0x0f) 0x00 ) ///////////////////////////////////////////////////发送了一个data报文 同时seq+=n
					{
						//data
						pTcb->seq += pTcpSeg->len - 20;
					}
					else if( (pTcb->flags & 0x0f) 0x02 )
					{
						//syn
						pTcb->seq++;
					}
					else if( (pTcb->flags & 0x0f) 0x01 )
					{
						//fin
						pTcb->seq++;
					}
					else if( (pTcb->flags & 0x3f) 0x10 )
					{
						//ack
					}

					return 0;
				}

		int tcp_closed(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
		{
			if( pTcb NULL || pTcpSeg NULL )
			{
				return -1;
			}

			if( pTcb->iotype != OUTPUT )
			{
				//to do: discard packet

				return -1;
			}

			pTcb->current_state = SYN_SENT;
			pTcb->seq = pTcpSeg->seq_num ;

			tcp_kick( pTcb, pTcpSeg );

			return 0;
		}

		int tcp_syn_sent(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
		{
			struct MyTcpSeg my_seg;

			if( pTcb NULL || pTcpSeg NULL )
			{
				return -1;
			}

			if( pTcb->iotype != INPUT )
			{
				return -1;
			}

			if( (pTcpSeg->flags & 0x3f) != 0x12 )
			{
				//to do: discard packet

				return -1;
			}

			pTcb->ack = pTcpSeg->seq_num + 1;
			pTcb->flags = 0x10;

			tcp_construct_segment( &my_seg, pTcb, 0, NULL );
			tcp_kick( pTcb, &my_seg );

			pTcb->current_state = ESTABLISHED;

			return 0;
		}

		int tcp_established(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
		{
			struct MyTcpSeg my_seg;

			if( pTcb NULL || pTcpSeg NULL )
			{
				return -1;
			}

			if( pTcb->iotype INPUT )
			{
				if( pTcpSeg->seq_num != pTcb->ack )
				{
					tcp_DiscardPkt((char*)pTcpSeg, STUD_TCP_TEST_SEQNO_ERROR);
					//to do: discard packet

					return -1;
				}

				if( (pTcpSeg->flags & 0x3f) 0x10 )
				{
					//get packet and ack it
					memcpy(pTcb->data, pTcpSeg->data, pTcpSeg->len - 20);
					pTcb->data_len = pTcpSeg->len - 20;

					if( pTcb->data_len 0 )
					{
						//pTcb->ack = pTcpSeg->seq_num + 1;
						//pTcb->ack++;
					}
					else
					{
						pTcb->ack += pTcb->data_len;
						pTcb->flags = 0x10;
						tcp\_construct\_segment(&my_seg, pTcb, 0, NULL);
						tcp_kick(pTcb, &my_seg);
					}
				}
			}
			else
			{
				if( (pTcpSeg->flags & 0x0F) 0x01 )
				{
					pTcb->current_state = FIN_WAIT1;
				}

				tcp_kick( pTcb, pTcpSeg );
			}

			return 0;
		}

		int tcp_finwait_1(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
		{
			if( pTcb NULL || pTcpSeg NULL )
			{
				return -1;
			}

			if( pTcb->iotype != INPUT )
			{
				return -1;
			}

			if( pTcpSeg->seq_num != pTcb->ack )
			{
				tcp_DiscardPkt((char*)pTcpSeg, STUD_TCP_TEST_SEQNO_ERROR);

				return -1;
			}

			if( (pTcpSeg->flags & 0x3f) 0x10 && pTcpSeg->ack_num pTcb->seq )
			{
				pTcb->current_state = FIN_WAIT2;
				//pTcb->ack++;
			}

			return 0;
		}

		int tcp_finwait_2(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
		{
			struct MyTcpSeg my_seg;

			if( pTcb NULL || pTcpSeg NULL )
			{
				return -1;
			}

			if( pTcb->iotype != INPUT )
			{
				return -1;
			}

			if( pTcpSeg->seq_num != pTcb->ack )
			{
				tcp_DiscardPkt((char*)pTcpSeg, STUD_TCP_TEST_SEQNO_ERROR);

				return -1;
			}

			if( (pTcpSeg->flags & 0x0f) 0x01 )
			{
				pTcb->ack++;
				pTcb->flags = 0x10;

				tcp_construct_segment( &my_seg, pTcb, 0, NULL );
				tcp_kick( pTcb, &my_seg );
				pTcb->current_state = CLOSED;
			}
			else
			{
				//to do
			}

			return 0;
		}

		int tcp_time_wait(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
		{
			pTcb->current_state = CLOSED;
			//to do

			return 0;
		}

		int tcp_check(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
		{
			int i = 0;
			int len = 0;
			unsigned int sum = 0;
			unsigned short* p = (unsigned short*)pTcpSeg;
			unsigned short *pIp;
			unsigned int myip1 = pTcb->local_ip;
			unsigned int myip2 = pTcb->remote_ip;

			if( pTcb NULL || pTcpSeg NULL )
			{
				return -1;
			}

			for( i=0; ilen) > 20 )
			{
				if( len % 2 1 )
				{
					pTcpSeg->data[len - 20] = 0;
					len++;
				}

				for( i=10; i>16)
					+ (unsigned short)(myip1&0xffff)
						+ (unsigned short)(myip2>>16)
						+ (unsigned short)(myip2&0xffff);
				sum = sum + 6 + pTcpSeg->len;

				sum = ( sum & 0xFFFF ) + ( sum >> 16 );
				sum = ( sum & 0xFFFF ) + ( sum >> 16 );

				if( (unsigned short)(~sum) != 0 )
				{
					// TODO:
					printf("check sum error!n");

					return -1;
					//return 0;
				}
				else
				{
					return 0;
				}
			}

			int tcp_switch(struct MyTCB* pTcb, struct MyTcpSeg* pTcpSeg)
			{
				int ret = 0;

				printf("STATE: %dn", pTcb->current_state);

				switch(pTcb->current_state)
				{
					case CLOSED:
						ret = tcp_closed(pTcb, pTcpSeg);
						break;
					case SYN_SENT:
						ret = tcp_syn_sent(pTcb, pTcpSeg);
						break;
					case ESTABLISHED:
						ret = tcp_established(pTcb, pTcpSeg);
						break;
					case FIN_WAIT1:
						ret = tcp_finwait_1(pTcb, pTcpSeg);
						break;
					case FIN_WAIT2:
						ret = tcp_finwait_2(pTcb, pTcpSeg);
						break;
					case TIME_WAIT:
						ret = tcp_time_wait(pTcb, pTcpSeg);
						break;
					default:
						ret = -1;
						break;
				}

				return ret;
			}

			int stud_tcp_input(char* pBuffer, unsigned short len, unsigned int srcAddr, unsigned int dstAddr)
			{
				//construct MyTcpSeg from buffer
				struct MyTcpSeg tcp_seg;
				int sockfd = -1;

				//printf("Here len = %dn", len);

				if( len < 20 )
				{
					return -1;
				}

				if(initialized NOT_READY)
				{
					tcp_init(1);
					gTCB[1].remote_ip = getServerIpv4Address();
					gTCB[1].remote_port = gRemotePort;
					initialized = READY;
				}

				memcpy(&tcp_seg, pBuffer, len);

				tcp_seg.len = len;

				//convert bytes' order
				convert\_tcp\_hdr\_ntoh(&tcp_seg);

				sockfd = get_socket(tcp_seg.dst_port, tcp_seg.src_port);

				if( sockfd -1 || gTCB[sockfd].local_ip != ntohl(dstAddr) || gTCB[sockfd].remote_ip != ntohl(srcAddr) )
				{
					printf("sock error in stud_tcp_input()n");
					return -1;
				}

				//gTCB.local_ip = ntohl(dstAddr);
				//gTCB.remote_ip = ntohl(srcAddr);

				//check TCP checksum
				if( tcp_check(&gTCB[sockfd], &tcp_seg) != 0 )
				{
					return -1;
				}

				gTCB[sockfd].iotype = INPUT;
				memcpy(gTCB[sockfd].data,tcp_seg.data,len - 20);
				gTCB[sockfd].data_len = len - 20;

				tcp_switch(&gTCB[sockfd], &tcp_seg);

				return 0;
			}

			void stud_tcp_output(char* pData, unsigned short len, unsigned char flag, unsigned short srcPort, unsigned short dstPort, unsigned int srcAddr, unsigned int dstAddr)
			{
				struct MyTcpSeg my_seg;
				int sockfd = -1;

				if(initialized NOT_READY)
				{
					tcp_init(1);
					gTCB[1].remote_ip = getServerIpv4Address();
					gTCB[1].remote_port = gRemotePort;
					initialized = READY;
				}

				sockfd = get_socket(srcPort, dstPort);

				if( sockfd == -1 || gTCB[sockfd].local_ip != srcAddr || gTCB[sockfd].remote_ip != dstAddr )
				{
					return;
				}

				gTCB[sockfd].flags = flag;
				//gTCB.local_port = srcPort;
				//gTCB.local_ip = ntohl(srcAddr);
				//gTCB.remote_port = dstPort;
				//gTCB.remote_ip = ntohl(dstAddr);

				tcp_construct_segment(&my_seg, &gTCB[sockfd], len, (unsigned char *)pData);

				gTCB[sockfd].iotype = OUTPUT;

				tcp_switch(&gTCB[sockfd], &my_seg);
			}

			int stud_tcp_socket(int domain, int type, int protocol)
			{
				int i = 1;
				int sockfd = -1;

				if( domain != AF_INET || type != SOCK_STREAM || protocol != IPPROTO_TCP )
				{
					return -1;
				}

				for( i=1; isin_addr.s_addr);
				gTCB[sockfd].remote_port = ntohs(addr->sin_port);

				stud_tcp_output( NULL, 0, 0x02, gTCB[sockfd].local_port, gTCB[sockfd].remote_port, gTCB[sockfd].local_ip, gTCB[sockfd].remote_ip );

				len = waitIpPacket(buffer, 10);

				if( len < 20 )
				{
					return -1;
				}

				if (stud_tcp_input(buffer, len, htonl(gTCB[sockfd].remote_ip), htonl(gTCB[sockfd].local_ip)) != 0){
					return 1;
				}
				else
				{
					return 0;
				}
			}

			int stud_tcp_send(int sockfd, const unsigned char* pData, unsigned short datalen, int flags)
			{
				char buffer[2048];
				int len;

				if( gTCB[sockfd].current_state != ESTABLISHED )
				{
					return -1;
				}

				stud_tcp_output((char *)pData, datalen, flags, gTCB[sockfd].local_port, gTCB[sockfd].remote_port, gTCB[sockfd].local_ip, gTCB[sockfd].remote_ip);

				len = waitIpPacket(buffer, 10);

				if( len < 20 )
				{
					return -1;
				}

				stud_tcp_input(buffer, len, htonl(gTCB[sockfd].remote_ip), htonl(gTCB[sockfd].local_ip));

				return 0;
			}

			int stud_tcp_recv(int sockfd, unsigned char* pData, unsigned short datalen, int flags)
			{
				char buffer[2048];
				int len;

				if( (len = waitIpPacket(buffer, 10)) < 20 )
				{
					return -1;
				}

				stud_tcp_input(buffer, len, htonl(gTCB[sockfd].remote_ip),htonl(gTCB[sockfd].local_ip));

				memcpy(pData, gTCB[sockfd].data, gTCB[sockfd].data_len);

				return gTCB[sockfd].data_len;
			}

			int stud_tcp_close(int sockfd)
			{
				char buffer[2048];
				int len;

				stud_tcp_output(NULL, 0, 0x11, gTCB[sockfd].local_port, gTCB[sockfd].remote_port, gTCB[sockfd].local_ip, gTCB[sockfd].remote_ip);

				//recv ACK
				if( (len = waitIpPacket(buffer, 10)) < 20 )
				{
					return -1;
				}

				stud_tcp_input(buffer, len, htonl(gTCB[sockfd].remote_ip), htonl(gTCB[sockfd].local_ip));

				//recv FIN
				if( (len = waitIpPacket(buffer, 10)) < 20 )
				{
					return -1;
				}

				stud_tcp_input(buffer, len, htonl(gTCB[sockfd].remote_ip), htonl(gTCB[sockfd].local_ip));

				gTCB[sockfd].is_used = NOT_USED;

				return 0;
			}
