/*=============================================================================
# Filename: Match.cpp
# Author: Bookug Lobert 
# Mail: 1181955272@qq.com
# Last Modified: 2016-12-15 01:38
# Description: how to use UVA(unified virtual addressing)
https://docs.nvidia.com/cuda/cuda-runtime-api/group__CUDART__UNIFIED.html
https://blog.csdn.net/langb2014/article/details/51348616
=============================================================================*/

#include "Match.cuh"
#include <cuda_runtime.h>


#define MAXSTREAM 20
//TODO:
//adjust the maximum
#define MAXLAUNCHEDTHREADS 9999
#define MAXTHREADSPERBLOCK 512
#define MAXLEFTNODE 15
using namespace std;

cudaStream_t stream[MAXSTREAM];

int egdeExistJudge(int* id, int* label, int length, int target)
{
	if(length <= 20){
		for(int i = 0; i < length; i ++){
			if(id[i] == target)
				return label[i];
		}
	}else{
		int s = 0, e = length - 1;
	    int mid = (s + e)/2;
	    while (s <= e)
	    {
	            if(id[mid] == target)
	            {
	                    return label[mid];
	            }
	            else if(id[mid] < target)
	            {
	                    s = mid + 1;
	            }
	            else {
	                    e = mid - 1;
	            }
	            mid = (s + e)/2;
	    }
	}
	return -1;
}
__device__ int d_egdeExistJudge(int* id, int* label, int length, int target)
{
	if(length <= 20){
		for(int i = 0; i < length; i ++){
			if(id[i] == target)
				return label[i];
		}
	}else{
		int s = 0, e = length - 1;
	    int mid = (s + e)/2;
	    while (s <= e)
	    {
	            if(id[mid] == target)
	            {
	                    return label[mid];
	            }
	            else if(id[mid] < target)
	            {
	                    s = mid + 1;
	            }
	            else {
	                    e = mid - 1;
	            }
	            mid = (s + e)/2;
	    }
	}
	return -1;
}


Match::Match(Graph* _query, Graph* _data)
{
	printf("enter match here\n");
	this->query = _query;
	this->data = _data;
	this->qsize = _query->vSize();
	this->dsize = _data->vSize();

	this->qcore = new int[qsize];
	this->qin = new int[qsize];
	this->qout = new int[qsize];

	this->dcore = new int[dsize];
	this->din = new int[dsize];
	this->dout = new int[dsize];
	
	this->streamNum = 0;
	
	this->matchOrder = new int[qsize];

	int degrees[qsize];
	memset(degrees,0,qsize*sizeof(int));
	for(int i = 0; i < qsize; i ++)
	{
		degrees[i] = _query->vertices[i].in.size() + _query->vertices[i].out.size();
	}
	//sort node according to the degree
	for(int i = 0; i < qsize; i++)
	{
		int maxDegree = degrees[0];
		int maxPos = 0;
		for(int j = 0; j < qsize; j ++)
		{
			if(degrees[j] > maxDegree)
			{
				maxDegree = degrees[j];
				maxPos = j;
			}
		}
		matchOrder[i] = maxPos;
		degrees[maxPos] = -1;
	}
	//find the min cover node set;
	int covered[qsize] ;
	memset(covered,0,qsize*sizeof(int));
	int coveredNum = 0;
	for(int i = 0; i < qsize; i ++)
	{
		int qid = matchOrder[i];
		if(covered[qid] == 0)
			coveredNum ++;
		covered[qid] = 1;
		for(int j = 0; j < _query->vertices[qid].in.size(); j ++)
		{
			int id = _query->vertices[qid].in[j].vid;
			if(covered[id] == 0)
				coveredNum ++;
			covered[id] = 1;
		}
		for(int j = 0; j < _query->vertices[qid].out.size(); j ++)
		{
			int id = _query->vertices[qid].out[j].vid;
			if(covered[id] == 0)
				coveredNum ++;
			covered[id] = 1;
		}
		if(coveredNum == qsize)
		{
			minCoverPos = i;
			break;
		}
	}
	
	printf("the following is the min cover of query graph");
	for(int i = 0; i <= minCoverPos; i ++)
	{
		printf("%d ",matchOrder[i]);
	}
	printf("\n");
	printf("query graph processed\n\n\n");
	//move csr to GPU
	this->qTotalInNum = _query->totalInNum;
	this->qTotalOutNum = _query->totalOutNum;

	this->dTotalInNum = _data->totalInNum;
	this->dTotalOutNum = _data->totalOutNum;
		
	//cuda init
	int t_0,t_1;
        t_0 = Util::get_cur_time();
	int* warmup = NULL;
	cudaMalloc(&warmup, sizeof(int));
	cudaFree(warmup);
	cout<<"GPU warmup finished"<<endl;
	size_t size = 0x7fffffff;
	/*size *= 3;   //heap corruption for 3 and 4*/
	size *= 5;
	/*size *= 2;*/
	//NOTICE: the memory alloced by cudaMalloc is different from the GPU heap(for new/malloc in kernel functions)
	cudaDeviceSetLimit(cudaLimitMallocHeapSize, size);
	cudaDeviceGetLimit(&size, cudaLimitMallocHeapSize);
	cout<<"check heap limit: "<<size<<endl;	
	t_1 = Util::get_cur_time();
    printf("cuda init done,it uses %d ms\n",t_1 - t_0);

	
	cudaMalloc(&qlabels, sizeof(int)*qsize);
	cudaMalloc(&qInRowOffset, sizeof(int)*(qsize+1));
	cudaMalloc(&qOutRowOffset, sizeof(int)*(1+qsize));
	cudaMalloc(&qInValues,sizeof(int)*qTotalInNum);
	cudaMalloc(&qInColOffset,sizeof(int)*qTotalInNum);
	cudaMalloc(&qOutValues,sizeof(int)*qTotalOutNum);
	cudaMalloc(&qOutColOffset,sizeof(int)*qTotalOutNum);
	
	cudaMalloc(&dlabels, sizeof(int)*dsize);
	cudaMalloc(&dInRowOffset, sizeof(int)*(dsize+1));
	cudaMalloc(&dOutRowOffset, sizeof(int)*(1+dsize));
	cudaMalloc(&dInValues,sizeof(int)*dTotalInNum);
	cudaMalloc(&dInColOffset,sizeof(int)*dTotalInNum);
	cudaMalloc(&dOutValues,sizeof(int)*dTotalOutNum);
	cudaMalloc(&dOutColOffset,sizeof(int)*dTotalOutNum);
	
	printf("malloc in build match all done\n");
//	printf("the qsize is %d,and the query labels is \n",qsize);
//	for(int i = 0; i < qsize; i++)
//		printf("the qlabel %d is %d\n",i,_query->labels[i]);	
	cudaMemcpy((void *)qlabels, (void *)_query->labels, sizeof(int)*qsize, cudaMemcpyHostToDevice);

	printf("first cpy done\n");
	cudaMemcpy((void *)qInRowOffset, (void *)_query->inRowOffset, sizeof(int)*(qsize+1), cudaMemcpyHostToDevice);
	cudaMemcpy((void *)qOutRowOffset, (void *)_query->outRowOffset, sizeof(int)*(qsize+1), cudaMemcpyHostToDevice);
	cudaMemcpy((void *)qInColOffset, (void *)_query->inColOffset, sizeof(int)*qTotalInNum, cudaMemcpyHostToDevice);
	cudaMemcpy((void *)qOutColOffset, (void *)_query->outColOffset, sizeof(int)*qTotalOutNum, cudaMemcpyHostToDevice);
	cudaMemcpy((void *)qInValues, (void *)_query->inValues, sizeof(int)*qTotalInNum, cudaMemcpyHostToDevice);
	cudaMemcpy((void *)qOutValues, (void *)_query->outValues, sizeof(int)*qTotalOutNum, cudaMemcpyHostToDevice);

	cudaMemcpy((void *)dlabels, (void *)_data->labels, sizeof(int)*dsize, cudaMemcpyHostToDevice);
	cudaMemcpy((void *)dInRowOffset, (void *)_data->inRowOffset, sizeof(int)*(dsize+1), cudaMemcpyHostToDevice);
	cudaMemcpy((void *)dOutRowOffset, (void *)_data->outRowOffset, sizeof(int)*(dsize+1), cudaMemcpyHostToDevice);
	cudaMemcpy((void *)dInColOffset, (void *)_data->inColOffset, sizeof(int)*dTotalInNum, cudaMemcpyHostToDevice);
	cudaMemcpy((void *)dOutColOffset, (void *)_data->outColOffset, sizeof(int)*dTotalOutNum, cudaMemcpyHostToDevice);
	cudaMemcpy((void *)dInValues, (void *)_data->inValues, sizeof(int)*dTotalInNum, cudaMemcpyHostToDevice);
	cudaMemcpy((void *)dOutValues, (void *)_data->outValues, sizeof(int)*dTotalOutNum, cudaMemcpyHostToDevice);
	//TODO:
	//cudaDeviceSynchronize();
	printf("move csr to GPU done\n");
}

Match::~Match()
{
	delete[] this->qcore;
	delete[] this->qin;
	delete[] this->qout;

	delete[] this->dcore;
	delete[] this->din;
	delete[] this->dout;

	delete[] this->matchOrder;

	cudaFree(qlabels);
	cudaFree(qInRowOffset);
	cudaFree(qInColOffset);
	cudaFree(qInValues);
	cudaFree(qOutValues);
	cudaFree(qOutColOffset);
	cudaFree(qOutRowOffset);

	cudaFree(dlabels);
	cudaFree(dInValues);
	cudaFree(dInColOffset);
	cudaFree(dInRowOffset);
	cudaFree(dOutValues);
	cudaFree(dOutColOffset);
	cudaFree(dOutRowOffset);		
}

//Two States of core queues: matching [0,size) not-matching -1
//Four States of in/out queues: matching depth   in_queue depth  out_queue depth other -1
//NOTICE:a vertex maybe appear in in_queue and out_queue at the same time
void 
Match::match(IO& io)
{
	if(qsize > dsize)
	{
		return;
	}

	//initialize the structures
	memset(qcore, -1, sizeof(int) * qsize);
	memset(qin, -1, sizeof(int) * qsize);
	memset(qout, -1, sizeof(int) * qsize);
	memset(dcore, -1, sizeof(int) * dsize);
	memset(din, -1, sizeof(int) * dsize);
	memset(dout, -1, sizeof(int) * dsize);

	d_Match * d_m;
	cudaMalloc(&d_m,sizeof(d_Match));
	cudaMemcpy((void *)d_m, (void *)this,sizeof(Match),cudaMemcpyHostToDevice);

	for(int i = 0; i < MAXSTREAM; i ++)
	{
		cudaStreamCreate(&stream[i]);
	}
	//call dfs with macthing num(depth)
	printf("start dfs here\n");
	dfs(0, io, minCoverPos,d_m);
	cudaDeviceSynchronize();
	printf("end bfs here\n");
	for(int i = 0; i < MAXSTREAM; i ++)
	{
		cudaStreamDestroy(stream[i]);
	}
	cudaDeviceReset();
}

//NOTICE:here can be different equal functions, maybe simlarity
bool 
Match::equal(LABEL lb1, LABEL lb2)
{
	return lb1 == lb2;
}

bool 
Match::checkCore(vector<Neighbor>& qlist, vector<Neighbor>& dlist)
{
	//data  another array record the mapping label? record the query is better? 2 directions
	int qnum = 0, dnum = 0; 
	int i, j, size1, size2;
	LABEL* temp = new LABEL[qsize];
	//NOTICE+WARN:sizeof(temp) is only 8 bytes
	//memset(temp, -1, sizeof(temp));
	memset(temp, -1, sizeof(LABEL) * qsize);

	size1 = qlist.size();
	for(i = 0; i < size1; ++i)
	{
		j = qlist[i].vid;
		if(qcore[j] >= 0)
		{
			qnum++;
			temp[j] = qlist[i].elb;
		}
	}

	size2 = dlist.size();
	for(i = 0; i < size2; ++i)
	{
		j = dlist[i].vid;
		if(dcore[j] >= 0 && temp[dcore[j]] != -1)
		{
			//check the edge label
			if(dlist[i].elb != temp[dcore[j]])
			{
				delete[] temp;
				return false;
			}
			dnum++;
		}
	}

	delete[] temp;
	if(qnum != dnum)
	{
		return false;
	}
	else
	{
		return true;
	}
}

bool 
Match::checkOther(vector<Neighbor>& qlist, vector<Neighbor>& dlist)
{
	int qin_num = 0, qout_num = 0, qres_num = 0; 
	int din_num = 0, dout_num = 0, dres_num = 0;
	int i, j, size1, size2;

	size1 = qlist.size();
	for(i = 0; i < size1; ++i)
	{
		j = qlist[i].vid;
		if(qin[j] >= 0 && qcore[j] < 0)
		{
			qin_num++;
		}
		if(qout[j] >= 0 && qcore[j] < 0)
		{
			qout_num++;
		}
		if(qin[j] < 0 && qout[j] < 0)
		{
			qres_num++;
		}
	}

	//BETTER?:check if satisfy the pruning limit each time
	size2 = dlist.size();
	for(i = 0; i < size2; ++i)
	{
		j = dlist[i].vid;
		if(din[j] >= 0 && dcore[j] < 0)
		{
			din_num++;
		}
		if(dout[j] >= 0 && dcore[j] < 0)
		{
			dout_num++;
		}
		if(din[j] < 0 && dout[j] < 0)
		{
			dres_num++;
		}
	}

	if(din_num < qin_num || dout_num < qout_num)
	{
		return false;
	}
	else
	{
		return true;
	}
}

bool 
Match::prune()
{
#ifdef DEBUG
	if(qnid < 0 || qnid >= qsize || dnid < 0 || dnid >= dsize)
	{
		cerr<<"ERROR in prune"<<endl;
		return true;
	}
	cerr<<"qnid: "<<qnid<<"\tdnid: "<<dnid<<endl;
	for(int i = 0; i < qsize; ++i)
	{
		cerr<<qcore[i]<<" ";
	}
	cerr<<endl;
	for(int i = 0; i < dsize; ++i)
	{
		cerr<<dcore[i]<<" ";
	}
	cerr<<endl;
#endif

	vector<Neighbor>& qpred = this->query->vertices[qnid].in;
	vector<Neighbor>& qsucc = this->query->vertices[qnid].out;
	vector<Neighbor>& dpred = this->data->vertices[dnid].in;
	vector<Neighbor>& dsucc = this->data->vertices[dnid].out;

	//vertex label: semantic pruning
	if(!equal(this->query->vertices[qnid].label, this->data->vertices[dnid].label))
	{
#ifdef DEBUG
	cerr<<"prune: the vertex label not macthed"<<endl;
#endif
		return true;
	}

	//NOTICE:If not consider labels, core restrictions can be done by computing the num of qnid and dnid matching 
	//with corresponding already-matching sets, just compare the num if equal is ok
	//NOTICE:If considering labels, just build a new array for query which keeps the labels for comparison
	//This array is temporal and small
	if(!checkCore(qpred, dpred))
	{
#ifdef DEBUG
	cerr<<"prune: the pred core not macthed"<<endl;
#endif
		return true;
	}
	if(!checkCore(qsucc, dsucc))
	{
#ifdef DEBUG
	cerr<<"prune: the succ core not macthed"<<endl;
#endif
		return true;
	}

	//compute and compare 6 nums both for pred list
	if(!checkOther(qpred, dpred))
	{
#ifdef DEBUG
	cerr<<"prune: the pred other not macthed"<<endl;
#endif
		return true;
	}
	//compute and compare 6 nums both for succ list
	if(!checkOther(qsucc, dsucc))
	{
#ifdef DEBUG
	cerr<<"prune: the succ other not macthed"<<endl;
#endif
		return true;
	}	
	
	return false;
}

void 
Match::modify(int depth, vector<Neighbor>& list, int* queue)
{
	int size = list.size(), i, j;
	for(i = 0; i < size; ++i)
	{
		j = list[i].vid;
		if(queue[j] < 0)
		{
			queue[j] = depth;
		}
	}
}

void 
Match::update(int depth)
{
	qcore[qnid] = dnid;
	dcore[dnid] = qnid;
	if(qin[qnid] < 0)
		qin[qnid] = depth;
	if(qout[qnid] < 0)
		qout[qnid] = depth;
	if(din[dnid] < 0)
		din[dnid] = depth;
	if(dout[dnid] < 0)
		dout[dnid] = depth;
	
	//add the new in vertices according to qnid
	this->modify(depth, this->query->vertices[qnid].in, qin);
	//add the new out vertices according to qnid
	this->modify(depth, this->query->vertices[qnid].out, qout);
	//add the new in vertices according to dnid
	this->modify(depth, this->data->vertices[dnid].in, din);
	//add the new out vertices according to dnid
	this->modify(depth, this->data->vertices[dnid].out, dout);
}

void 
Match::restore(int depth)
{
	//if(qnid < 0 || qnid >= qsize || dnid < 0 || dnid >= dsize)
	//{
		//cerr<<"ERROR in restore"<<endl;
		//return;
	//}
	qcore[qnid] = -1;
	dcore[dnid] = -1;
	//update the query queues
	for(int i = 0; i < qsize; ++i)
	{
		if(qin[i] == depth)
		{
			qin[i] = -1;
		}
		if(qout[i] == depth)
		{
			qout[i] = -1;
		}
	}
	//update the data queues
	for(int i = 0; i < dsize; ++i)
	{
		if(din[i] == depth)
		{
			din[i] = -1;
		}
		if(dout[i] == depth)
		{
			dout[i] = -1;
		}
	}
}


__global__ void lastJoin1(int * qcore,
                                                int qsize,
                                                int leftNode,
                                                d_Match * dMatch,
                                                int totalThreadNum){
	return ;
}



__global__ void lastJoin(int * qcore, 
						int qsize, 
						int leftNode, 
						d_Match * dMatch,
						int totalThreadNum)
{
//	if(qcore[0] == 4608){
//		if(threadIdx.x == 0)
//			printf("---------this is block %d of target kernel\n",blockIdx.x);
//		printf("target kernek launched!!!q[1] = %d,q[2] = %d\n",qcore[1],qcore[2]);
//	}

	int * cansRowOffset = qcore + qsize;
	int * cansColOffset = cansRowOffset + leftNode + 1;

	int idx = blockIdx.x*MAXTHREADSPERBLOCK + threadIdx.x;
	if(idx >= totalThreadNum)
			return ;
	//TODO: put this array in shared memory or not?
	int *localCans = new int [leftNode];
	int mul = 1;
	for(int i = leftNode-1; i >= 0; i --)
	{
		localCans[i] = cansColOffset[cansRowOffset[i] + (idx/mul)%(cansRowOffset[i+1] - cansRowOffset[i])];
		mul *= (cansRowOffset[i+1] - cansRowOffset[i]);
	}
	__shared__ int leftQidPos[MAXLEFTNODE];
	if(idx%MAXTHREADSPERBLOCK == 0)
	{
		int temp = 0;
		for(int i = 0; i < qsize; i++)
		{
			if(qcore[i] != -1)
				continue;
			leftQidPos[temp] = i;
			temp ++;
		}
	}
	__syncthreads();
//	if(idx == 0){
//		printf("the leftNode is %d\n",leftNode);
		
//	}
       // printf("the idx is %d,the %d pos is %d, the %d pos is %d, the %d pos is %d\n",idx,leftQidPos[0],
	//localCans[0],leftQidPos[1],localCans[1],leftQidPos[2],localCans[2]);

	//use labels to prune
	bool debug = false;
		
	for(int i = 0; i < leftNode; i++)
	{
		if(dMatch->dlabels[localCans[i]] != dMatch->qlabels[leftQidPos[i]])
		{
			delete [] localCans;
			if(debug)
				printf("prune in 1\n");
	//		printf("the idx %d returns\n",idx);
			return;
		}
	}
	for(int i = 0; i < leftNode; i ++)
		for(int j = 0; j < qsize; j++)
		{
			if(qcore[j] == -1)
				continue;
			if(qcore[j] == localCans[i])
			{
				delete [] localCans;
  			if(debug)
          	           printf("prune in 2\n");

//                      printf("the idx %d returns\n",idx);
                	return ;
			}
		}
	for(int i = 0; i < leftNode; i ++)
		for(int j = i+1; j < leftNode; j++)
		{
			if(localCans[i] == localCans[j])
			{
				delete [] localCans;
				if(debug)
           		         printf("prune in 3\n");

//                    printf("the idx %d returns\n",idx);
               			 return ;
			}
		}
				
//	printf("use edge to prune\n");				
//use in edge to prune
	for(int i = 0; i < leftNode; i++)
	{
		//j represent the adj id of i
		for(int j = 0; j < dMatch->qInRowOffset[leftQidPos[i]+1] - dMatch->qInRowOffset[leftQidPos[i]]; j ++)
		{
			int adjQid = dMatch->qInColOffset[dMatch->qInRowOffset[leftQidPos[i]] + j];
			if(qcore[adjQid] == -1)
			{	
				 if(adjQid > leftQidPos[i])
				 	continue;
				 int rightPos = 0;
				 for(int l = 0; l < leftNode; l++)
				 	if(leftQidPos[l] == adjQid)
				 	{
				 		rightPos = l;
				 		break;
				 	}
				 if(d_egdeExistJudge(dMatch->dInColOffset + dMatch->dInRowOffset[localCans[i]], 
								dMatch->dInValues + dMatch->dInRowOffset[localCans[i]], 
								dMatch->dInRowOffset[localCans[i]+1] - dMatch->dInRowOffset[localCans[i]], 
								localCans[rightPos]) 
								!= dMatch->qInValues[dMatch->qInRowOffset[leftQidPos[i]] + j])
				 {
					 if(debug)
                                 		printf("prune in 4\n");

				 	delete [] localCans;
					return ;
				 }

			}
			else if(d_egdeExistJudge(dMatch->dInColOffset + dMatch->dInRowOffset[localCans[i]], 
								dMatch->dInValues + dMatch->dInRowOffset[localCans[i]], 
								dMatch->dInRowOffset[localCans[i]+1] - dMatch->dInRowOffset[localCans[i]], 
								qcore[adjQid]) 
								!= dMatch->qInValues[dMatch->qInRowOffset[leftQidPos[i]] + j])
			{
				
	/*			if(debug)
				{
          		                printf("prune in 4\n");
					printf("the leftNode qid is %d,the adj qid is %d\n",leftQidPos[i],dMatch->qInColOffset[dMatch->qInRowOffset[leftQidPos[i]] + j]);
					printf("the leftNode did is %d,the adj did is %d\n",localCans[i],qcore[adjQid]);
					printf("here is the adj list of leftNode did:\n");
					for(int l = 0; l < dMatch->dInRowOffset[localCans[i]+1] - dMatch->dInRowOffset[localCans[i]]; l ++)
					{
						printf("id is %d, label is %d\n",dMatch->dInColOffset[dMatch->qInRowOffset[localCans[i]]+l],dMatch->dInValues[dMatch->qInRowOffset[localCans[i]]+l]);
					}	
				}*/
				 if(debug)
                                 printf("prune in 5\n");

					delete [] localCans;
	//			printf("the idx %d returns\n",idx);
				return ;
			}
		}
	}
	for(int i = 0; i < leftNode; i++)
	{
		//j represent the adj id of i
		for(int j = 0; j < dMatch->qOutRowOffset[leftQidPos[i]+1] - dMatch->qOutRowOffset[leftQidPos[i]]; j ++)
		{

			int adjQid = dMatch->qOutColOffset[dMatch->qOutRowOffset[leftQidPos[i]] + j];
			if(debug)
				printf("i is %d, j is %d,leftQidPos[i] is %d,localcans[i] is %d, the qcore[%d] is %d\n",i,j,leftQidPos[i],localCans[i],adjQid,qcore[adjQid]);
			if(qcore[adjQid] == -1)
			{	
				 if(adjQid > leftQidPos[i])
				 	continue;
				 int rightPos = 0;
				 for(int l = 0; l < leftNode; l++)
				 	if(leftQidPos[l] == adjQid)
				 	{
				 		rightPos = l;
				 		break;
				 	}
				 if(d_egdeExistJudge(dMatch->dOutColOffset + dMatch->dOutRowOffset[localCans[i]], 
								dMatch->dOutValues + dMatch->dOutRowOffset[localCans[i]], 
								dMatch->dOutRowOffset[localCans[i]+1] - dMatch->dOutRowOffset[localCans[i]], 
								localCans[rightPos]) 
								!= dMatch->qOutValues[dMatch->qOutRowOffset[leftQidPos[i]] + j])
				 {
					 if(debug)
		                                 printf("prune in 6\n");

				 	delete [] localCans;
					return ;
				 }

			}
			else if(d_egdeExistJudge(dMatch->dOutColOffset + dMatch->dOutRowOffset[localCans[i]], 
									dMatch->dOutValues + dMatch->dOutRowOffset[localCans[i]], 
									dMatch->dOutRowOffset[localCans[i]+1] - dMatch->dOutRowOffset[localCans[i]], 
									qcore[adjQid]) 
									!= dMatch->qOutValues[dMatch->qOutRowOffset[leftQidPos[i]] + j])
			{
				delete [] localCans;
				if(debug){
                                	printf("prune in 7,label 1 is %d,label 2 is %d\n",d_egdeExistJudge(dMatch->dOutColOffset + dMatch->dOutRowOffset[localCans[i]],
                                                                        dMatch->dOutValues + dMatch->dOutRowOffset[localCans[i]],
                                                                        dMatch->dOutRowOffset[localCans[i]+1] - dMatch->dOutRowOffset[localCans[i]],
                                                                        qcore[adjQid]), dMatch->qOutValues[dMatch->qOutRowOffset[leftQidPos[i]] + j]);
					for(int l = 0; l < dMatch->dOutRowOffset[localCans[i]+1] - dMatch->dOutRowOffset[localCans[i]]; l ++)
					{
						printf("%d\n",dMatch->dOutColOffset[dMatch->dOutRowOffset[localCans[i]] + l]);
					}
					
				}
	//			printf("the idx %d returns\n",idx);
				return ;
			}
		}
	}
	if(debug)
		printf("ready to output for target\n");

//	for(int i = 0; i < leftNode; i ++)
//	{
//		qcore[leftQidPos[i]] = localCans[i];
//	}

	//TODO : join all the varities before output
	int t = 0;
//	printf("the idx is %d\n",idx);
	//TODO: better it

	char *outPutString = new char[qsize*15];
	int outPos = 0;
	for(int i = 0; i < qsize; i ++)
	{
		outPutString[outPos++] = '(';
	
		int div = 1;
		int tempNum = i;
		while(tempNum >= 10)
		{
			tempNum /= 10;
			div *= 10;
		}
		tempNum = i;
		while(div > 0)
		{
			outPutString[outPos++] = '0' + tempNum/div;
			tempNum = tempNum%div;
			div = div/10;
		}

	//	sprintf(outPutString + outPos,"%d",i);
	//	outPos = strlen(outPutString);
		outPutString[outPos++] = ',';
		outPutString[outPos++] = ' ';
		int addNum = 0;
		if(qcore[i] == -1)
		{
			addNum = localCans[t++];
	//		sprintf(outPutString + outPos,"%d",localCans[t++]);
	//		outPos += strlen(outPutString);
		}
		else
		{
			addNum = qcore[i];
	//		sprintf(outPutString + outPos,"%d",qcore[i]);
	//		outPos += strlen(outPutString);
		}

		div = 1;
		tempNum = addNum;
		while(tempNum >= 10)
		{
			tempNum /= 10;
			div *= 10;
		}
		tempNum = addNum;
		while(div > 0)
		{
			outPutString[outPos++] = '0' + tempNum/div;
			tempNum = tempNum%div;
			div = div/10;
		}

		outPutString[outPos++] = ')';
		outPutString[outPos++] = ' ';
	//	sprintf(outPutString + outPos,"%s",") ");
        //outPos += 2;
	}
	outPutString[outPos] = '\0';
//	strcpy(outPutString,'\n');
	printf("%s\n",outPutString);
//	printf("%s from block %d,idx %d\n",outPutString,blockIdx.x,threadIdx.x);
	delete [] outPutString;

//	delete [] outPutString;
	return ;
}


void
Match::dfs(int num, IO& io, int queryIdRange, d_Match * dMatch)
{
	//TODO:
	//modify the output 
	if(num == this->qsize)
	{
#ifdef DEBUG
		cerr<<"find a mapping here"<<endl;
#endif
		io.output(this->qcore, this->qsize);
		return;
	}
//	printf("the num is %d\n",num);
	//NOTICE:to avoid duplicates, only consider the smallest qid in candidates
	//int depth = num;

	//prepare the candidates from all cases
	int i, j;
	this->qnid = -1;
	vector<int> cans;

	//consider the out queue
	for(i = 0; i <= queryIdRange; ++i)
	{
		if(qout[matchOrder[i]] < 0 || qcore[matchOrder[i]] >= 0)
		{
			continue;
		}
		this->qnid = matchOrder[i];
		for(int j = 0; j < qsize; j ++)
		{
			if(qcore[j] == -1)
				continue;
			if(egdeExistJudge(query->outColOffset + query->outRowOffset[j], 
							  query->outValues + query->outRowOffset[j], 
							  query->outRowOffset[j+1] - query->outRowOffset[j],
							  matchOrder[i]) != -1)
			{
				int tempData = qcore[j];
				for(int k = 0; k < data->outRowOffset[tempData+1]-data->outRowOffset[tempData]; k++)
				{
					int adjData = data->outColOffset[data->outRowOffset[tempData]+k];
					if(dout[adjData] < 0 || dcore[adjData] >= 0)
					{
						continue;
					}
					cans.push_back(adjData);
				}
				break;
			}
		}/*
		int allCansCount = 0;
		for(int j = 0; j < dsize; ++j)
                {
                        if(dout[j] < 0 || dcore[j] >= 0)
                        {
                                continue;
                        }
                        allCansCount ++;
                }
		printf("allCans is %d,cans infact is %d,%d less\n",allCansCount,cans.size(),allCansCount - cans.size());*/
		break;
		/*
		for(j = 0; j < dsize; ++j)
		{
			if(dout[j] < 0 || dcore[j] >= 0)
			{
				continue;
			}
			cans.push_back(j);
		}*/
	}
	//consider the in queue
	if(qnid == -1)
	{
		for(i = 0; i <= queryIdRange; ++i)
		{
			if(qin[matchOrder[i]] < 0 || qcore[matchOrder[i]] >= 0)
			{
				continue;
			}
			this->qnid = matchOrder[i];
			for(int j = 0; j < qsize; j ++)
			{
				if(qcore[j] == -1)
					continue;
				if(egdeExistJudge(query->inColOffset + query->inRowOffset[j], 
								  query->inValues + query->inRowOffset[j], 
								  query->inRowOffset[j+1] - query->inRowOffset[j],
								  matchOrder[i]) != -1)
				{
					int tempData = qcore[j];
					for(int k = 0; k < data->inRowOffset[tempData+1]-data->inRowOffset[tempData]; k++)
					{
						int adjData = data->inColOffset[data->inRowOffset[tempData]+k];
						if(din[adjData] < 0 || dcore[adjData] >= 0)
						{
							continue;
						}
						cans.push_back(adjData);
					}
					break;
				}
			}/*
			int allCansCount = 0;
	                for(int j = 0; j < dsize; ++j)
        	        {
                	        if(din[j] < 0 || dcore[j] >= 0)
                	        {
                        	        continue;
                        	}
                        	allCansCount ++;
                	}
                	printf("allCans is %d,cans infact is %d,%d less\n",allCansCount,cans.size(),allCansCount - cans.size());
			*/
			break;
		}
	}

	if(cans.size() == 0 && qnid != -1)
		return ;

	//consider the other queue
	if(qnid == -1)
	{
		//TODO:
		// add restrictions to the range of qid
		for(i = 0; i <= queryIdRange; ++i)
		{
			if(qin[matchOrder[i]] >= 0 || qout[matchOrder[i]] >= 0)
			{
				continue;
			}
			this->qnid = matchOrder[i];
			for(j = 0; j < dsize; ++j)
			{
				if(din[j] >= 0 || dout[j] >= 0)
				{
					continue;
				}
				cans.push_back(j);
			}
			break;
		}
	}

	int size = cans.size(), qnid2, dnid2;
	for(i = 0; i < size; ++i)
	{
		this->dnid = cans[i];
	//	 printf("the num is %d, the qnid is %d, the dnid is %d\n",num,this->qnid,this->dnid);
		if(prune())
		{
#ifdef DEBUG
			cerr<<"prune dnid: "<<dnid<<endl;
#endif
			continue;
		}
		else
		{
#ifdef DEBUG
			cerr<<"not prune dnid: "<<dnid<<endl;
#endif
		}
		update(num);
		//BETTER?:place qnid and dnid in function parameters?
		qnid2 = this->qnid; dnid2 = this->dnid;
		//TODO: add constraintions on when to launch kernels
		if(num >= this->minCoverPos)
		{
			int leftQueryNode = qsize - num - 1;
			int *cansStartPoint[leftQueryNode];
			int cansLenth[leftQueryNode];
			memset(cansLenth,0,sizeof(int)*leftQueryNode);
			//a reverseTable from qid to pos in cans
			int reverseTable[qsize];
			memset(reverseTable,-1,sizeof(int)*qsize);
			int fillNum = 0;
			for(int i = 0; i < qsize; i ++)
			{
				if(qcore[i] == -1)
				{
					reverseTable[i] = fillNum ++;
				}
			}
			//find the cans of all node left
			for(int k = 0; k <= minCoverPos; k ++)
			{
				//j represent the qid whose cans is to be find out
				for(int j = 0; j < qsize; j ++)
				{
					if(qcore[j] != -1 || cansLenth[reverseTable[j]] != 0)
						continue;
					if(egdeExistJudge(query->inColOffset + query->inRowOffset[matchOrder[k]],
									  query->inValues + query->inRowOffset[matchOrder[k]],
									  query->inRowOffset[matchOrder[k]+1] - query->inRowOffset[matchOrder[k]],
									  j) != -1)
					{
						cansStartPoint[reverseTable[j]] = data->inColOffset + data->inRowOffset[qcore[matchOrder[k]]];
						cansLenth[reverseTable[j]] = data->inRowOffset[qcore[matchOrder[k]]+1] - data->inRowOffset[qcore[matchOrder[k]]];
					}else if(egdeExistJudge(query->outColOffset + query->outRowOffset[matchOrder[k]],
									  query->outValues + query->outRowOffset[matchOrder[k]],
									  query->outRowOffset[matchOrder[k]+1] - query->outRowOffset[matchOrder[k]],
									  j) != -1)
					{
						cansStartPoint[reverseTable[j]] = data->outColOffset + data->outRowOffset[qcore[matchOrder[k]]];
						cansLenth[reverseTable[j]] = data->outRowOffset[qcore[matchOrder[k]]+1] - data->outRowOffset[qcore[matchOrder[k]]];
					}
				}
			}
			bool debug = false;
		/*	if(qcore[0] == 4608){
				debug = true;
				for(int l = 0; l < leftQueryNode; l ++)
				{
					printf("the len of cans[%d] is %d\n",l,cansLenth[l]);
					for(int p = 0; p < cansLenth[l]; p ++)
						printf("%d\n",cansStartPoint[l][p]);
				}
			}*/
			//calculate the total nums of threads to be launched
			int totalThreadNum = 1;
			int totalCansNum = 0;
			for(int k = 0; k < leftQueryNode; k ++)
			{
				totalThreadNum *= cansLenth[k];
				totalCansNum += cansLenth[k];
			}
			if(totalThreadNum == 0)
			{
				this->qnid = qnid2; this->dnid = dnid2;
				restore(num);	
				continue;
			}
		//	if(debug)
		//		printf("the totalThreadNum of target kernel is %d\n",totalThreadNum);

			//NOTICE:UVA technology
			if(totalThreadNum < MAXLAUNCHEDTHREADS)
			{
				streamNum = (streamNum+1)%MAXSTREAM;
				//copy the needed data to device
				int * h_toDevive;
				//TODO: put this in stream???
				unsigned int flags = cudaHostAllocMapped;
				cudaHostAlloc((void **)&h_toDevive,sizeof(int)*(qsize+totalCansNum+leftQueryNode+1),flags);

			//	cudaMallocHost((void **)&h_toDevive,sizeof(int)*(qsize+totalCansNum+leftQueryNode+1));
				memcpy(h_toDevive,qcore,qsize*sizeof(int));
				int * tempPtr = h_toDevive + qsize;
				tempPtr[0] = 0;
				for(int k = 1; k <= leftQueryNode; k ++)
				{
					tempPtr[k] = tempPtr[k-1] + cansLenth[k-1];
				}
				int * tempPtr2 = tempPtr + (leftQueryNode + 1);
				for(int k = 0; k < leftQueryNode; k ++)
				{
					memcpy(tempPtr2 + tempPtr[k],cansStartPoint[k],cansLenth[k]*sizeof(int));
				}

				int * d_toDevice;
				//NOTICE: the critical point of UVA technology
				cudaHostGetDevicePointer((void **)&d_toDevice, (void *)h_toDevive, 0);
			//	cudaMalloc(&d_toDevice, sizeof(int)*(qsize+totalCansNum+leftQueryNode+1));

			//	cudaMemcpyAsync(d_toDevice,h_toDevive,sizeof(int)*(qsize+totalCansNum+leftQueryNode+1),cudaMemcpyHostToDevice,stream[streamNum%MAXSTREAM]);
				
		//		printf("prepare work for launch the kernel is done\n");
		//		printf("the totalLaunched threads is %d\n",totalThreadNum);
				//TODO: launch kernel
				//TODO: only launch one block???
				if(debug)
					printf("the kernel is to be launched, the total lauchedThread is %d,streamNum is %d\n",totalThreadNum,streamNum);
				if(totalThreadNum <= MAXTHREADSPERBLOCK){
					//if(totalThreadNum != 0)
						lastJoin<<<1,totalThreadNum,0,stream[streamNum%MAXSTREAM]>>>(d_toDevice,qsize,leftQueryNode,dMatch,totalThreadNum);
				}else{
					
			//		printf("muti-blocks are launched,and the grid size is %d\n",(totalThreadNum + MAXTHREADSPERBLOCK-1)/MAXTHREADSPERBLOCK);	
					lastJoin<<<(totalThreadNum+MAXTHREADSPERBLOCK-1)/MAXTHREADSPERBLOCK,MAXTHREADSPERBLOCK,0,stream[streamNum%MAXSTREAM]>>>(d_toDevice,qsize,leftQueryNode,dMatch,totalThreadNum);
					if(debug){
						cudaError_t error = cudaGetLastError();
						printf("CUDA error: %s\n", cudaGetErrorString(error));
					}
				}//TODO: use stream to free the memory ????
			//	printf("the total cans is %d\n",cansRowOffset[leftQueryNode]);
		//		if(streamNum == MAXSTREAM -1)
			//	cudaDeviceSynchronize();
	//				cudaFreeHost(h_toDevive);
		//		cudaFree(d_toDevice);
			}else{
				//TODO:
				//use cpu to handle the node left
				printf("too large totalcans: %d to launch the kernel,so continue on CPU\n",totalThreadNum);

				dfs(num+1, io, qsize-1, dMatch);
			}

		}else{
			dfs(num+1, io, queryIdRange, dMatch);
		}
		this->qnid = qnid2; this->dnid = dnid2;
		restore(num);
	}
}

