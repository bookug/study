#include "sysinclude.h"

extern void SendFRAMEPacket(unsigned char* pData, unsigned int len);

#define WINDOW_SIZE_STOP_WAIT 1
#define WINDOW_SIZE_BACK_N_FRAME 4
#define WINDOW_SIZE_CHOICE_FRAME_RESEND 4

typedef enum { data, ack, nak } frame_kind;

typedef struct frame_head
{
	frame_kind kind;
	unsigned int seq;
	unsigned int ack;
	unsigned char data[100];
};

typedef struct frame
{
	frame_head head;
	unsigned int size;
};

//store frame in buffer
class Buffer
{
public:
	frame* fp;
	unsigned length;
	Buffer()
	{
		fp = NULL;
		length = 0;
	}
	Buffer(char* _fp, int _len)
	{
		length = (unsigned)_len;
		fp = new frame;
		*fp = *(frame*)_fp;
	}
};

//implement a cycle queue struct for moving frames
#define MAX_QUEUE_LEN 10000
class Queue
{
private:
	unsigned head, tail, num;
	Buffer* q[MAX_QUEUE_LEN];
public:	
	Queue()
	{
		head = tail = num = 0;
	}
	unsigned count()	//count elements num, can judge if send window is full
	{
		return this->num;
	}
	bool isEmpty()
	{
		return num == 0;
	}
	bool isFull()
	{
		return num == MAX_QUEUE_LEN;
	}
	Buffer* top()
	{
		if(this->isEmpty())
			return NULL;
		else
			return this->q[head];
	}
	void pop()
	{
		if(this->isEmpty())
			return;
		head = (head + 1) % MAX_QUEUE_LEN;
		num--;
	}
	void push(Buffer* p)
	{
		if(this->isFull())
			return;
		this->q[tail] = p;
		tail = (tail + 1) % MAX_QUEUE_LEN;
		num++;
	}
	int find(unsigned seq, unsigned size)	//search the send window for frame seq
	{
		if(this->isEmpty())
			return -1;
		unsigned i = this->head, j = 0;
		while(1)
		{
			j++;
			if(this->q[i]->fp->head.seq == seq)
				return j-1;					//offset to head
			i = (i + 1) % MAX_QUEUE_LEN;
			if(i == this->tail || j == size)
				break;
		}
		return -1;
	}
	void send(unsigned offset, unsigned cnt)	//send from head+offset, cnt in total
	{
		unsigned i = (head + offset) % MAX_QUEUE_LEN;
		while(cnt > 0)
		{
			SendFRAMEPacket((unsigned char*)this->q[i]->fp, this->q[i]->length);
			i = (i + 1) % MAX_QUEUE_LEN;
			cnt--;
		}
	}
}queue;

/*
* 停等协议测试函数
*/
int stud_slide_window_stop_and_wait(char *pBuffer, int bufferSize, UINT8 messageType)
{
	unsigned tseq, tack;
	Buffer* p;
	switch(messageType)
	{
	case MSG_TYPE_SEND:
		p = new Buffer(pBuffer, bufferSize);
		queue.push(p);
		if(queue.count() <= WINDOW_SIZE_STOP_WAIT)
			SendFRAMEPacket((unsigned char*)pBuffer, (unsigned)bufferSize);
		break;
	case MSG_TYPE_RECEIVE:
		tack = ((frame*)pBuffer)->head.ack;
		if(tack == queue.top()->fp->head.seq)	//both are big-endian
		{
			queue.pop();
			if(!queue.isEmpty())
			{
				p = queue.top();
				SendFRAMEPacket((unsigned char*)p->fp, p->length);
			}
		}
		break;
	case MSG_TYPE_TIMEOUT:
		tseq = *(UINT32*)pBuffer;
		p = queue.top();
		if(tseq == ntohl(p->fp->head.seq))
			SendFRAMEPacket((unsigned char*)p->fp, p->length);
		break;
	default:
		return -1;
	}
	return 0;
}

/*
* 回退n帧测试函数
*/
int stud_slide_window_back_n_frame(char *pBuffer, int bufferSize, UINT8 messageType)
{
	unsigned tseq, tack;
	Buffer* p;
	int ret;
	switch(messageType)
	{
	case MSG_TYPE_SEND:
		p = new Buffer(pBuffer, bufferSize);
		queue.push(p);
		if(queue.count() <= WINDOW_SIZE_BACK_N_FRAME)
			SendFRAMEPacket((unsigned char*)pBuffer, (unsigned)bufferSize);
		break;
	case MSG_TYPE_RECEIVE:	//QUERY: not on order, then? same question in next func
		tack = ((frame*)pBuffer)->head.ack;
		if(tack == queue.top()->fp->head.seq)	//both are big-endian
		{
			queue.pop();
			if(queue.count() >= WINDOW_SIZE_BACK_N_FRAME)
			{
				queue.send(WINDOW_SIZE_BACK_N_FRAME - 1, 1);
			}
		}
		/*
		ret = queue.find(tack, WINDOW_SIZE_BACK_N_FRAME);		//both are big-endian
		if(ret >= 0)					//successfully found
		{
			unsigned t = queue.count(), i;
			unsigned num = ret + 1;
			for(i = 0; i < num; ++i)
				queue.pop();
			if(t > WINDOW_SIZE_BACK_N_FRAME)
			{
				t -= WINDOW_SIZE_BACK_N_FRAME;
				if(num < t)
					t = num;
				queue.send(WINDOW_SIZE_BACK_N_FRAME-num, t);
			}
		}
		*/
		break;
	case MSG_TYPE_TIMEOUT:
		tseq = htonl(*(UINT32*)pBuffer);
		ret = queue.find(tseq, WINDOW_SIZE_BACK_N_FRAME);
		if(ret >= 0)
		{
			unsigned t = queue.count();
			if(t > WINDOW_SIZE_BACK_N_FRAME)
				t = WINDOW_SIZE_BACK_N_FRAME;
			queue.send(ret, t-ret);
		}
		break;
	default:
		return -1;
	}
	return 0;
}

/*
* 选择性重传测试函数
*/
int stud_slide_window_choice_frame_resend(char *pBuffer, int bufferSize, UINT8 messageType)
{
	unsigned tseq, tack;
      unsigned tkind;	//frame_kind
	Buffer* p;
	int ret;
	switch(messageType)
	{
	case MSG_TYPE_SEND:
		p = new Buffer(pBuffer, bufferSize);
		queue.push(p);
		if(queue.count() <= WINDOW_SIZE_CHOICE_FRAME_RESEND)
			SendFRAMEPacket((unsigned char*)pBuffer, (unsigned)bufferSize);
		break;
	case MSG_TYPE_RECEIVE:			
		tkind = ntohl(((frame*)pBuffer)->head.kind);	
		if(tkind == ack)
		{
			tack = ((frame*)pBuffer)->head.ack;
			if(tack == queue.top()->fp->head.seq)	//both are big-endian
			{
				queue.pop();
				if(queue.count() >= WINDOW_SIZE_CHOICE_FRAME_RESEND)
				{
					queue.send(WINDOW_SIZE_CHOICE_FRAME_RESEND - 1, 1);
				}
			}
			/*
			queue.find(tack, WINDOW_SIZE_CHOICE_FRAME_RESEND);
			if(ret >= 0)
			{
				unsigned t = queue.count(), i;
				unsigned num = ret + 1;
				for(i = 0; i < num; ++i)
					queue.pop();
				if(t > WINDOW_SIZE_BACK_N_FRAME)
				{
					t -= WINDOW_SIZE_BACK_N_FRAME;
					if(num < t)
						t = num;
					queue.send(WINDOW_SIZE_BACK_N_FRAME-num, t);
				}
			}
			*/
		}
		else if(tkind == nak)
		{
			tseq = ((frame*)pBuffer)->head.seq;
			ret = queue.find(tseq, WINDOW_SIZE_CHOICE_FRAME_RESEND);
			queue.send(ret, 1);
		}
		break;
	default:
		return -1;
	}
	return 0;
}
