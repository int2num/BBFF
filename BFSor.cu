#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include"pathalg.h"
static const int WORK_SIZE =258;
void BFSor::copydata(int s,vector<edge>&edges,int nodenum){
};
void BFSor::dellocate(){
};
void BFSor::allocate(int maxn,int maxedge){
}
void BFSor::topsort()
{
};
void BFSor::init(pair<vector<edge>,vector<vector<int>>>ext,vector<pair<int,int>>stpair,vector<vector<int>>&relate,ginfo ginf)
{
	nodenum=ginf.pnodesize;
	edges=ext.first;
	vector<vector<int>>esigns;
	esigns=ext.second;
	stp=stpair;
	mark=new int;
	*mark=0;
	W=WD+1;
	st=new int[2*edges.size()*LY];
	te=new int[2*edges.size()*LY];
	d=new int[nodenum*LY*YE];
	esignes=new int[edges.size()*LY];
	vector<vector<int>>nein(nodenum*LY,vector<int>());
	neibn=nein;
	vector<vector<int>>neie(nodenum,vector<int>());
	for(int i=0;i<edges.size();i++)
		{
			int s=edges[i].s;
			int t=edges[i].t;
			neibn[s].push_back(t);
			neibn[t].push_back(s);
			neie[s].push_back(i);
			neie[t].push_back(i);
		}
	int count=0;
	for(int k=0;k<LY;k++)
		for(int i=0;i<nodenum;i++)
			for(int j=0;j<neibn[i].size();j++)
			{
				st[count]=i;
				if(esigns[k][neie[i][j]]==-1)
					te[count]=i;
				else
					te[count]=neibn[i][j];
				count++;
			}
	for(int i=0;i<nodenum*LY*YE;i++)
		d[i]=WD+1;
	for(int k=0;k<LY;k++)
	{
		int boff=k*YE*nodenum;
		for(int i=0;i<YE;i++)
		{
			int soff=i*nodenum;
			for(int j=0;j<stpair.size();j++)
				d[boff+soff+stpair[i].first]=0;
		}
	}
	cudaMalloc((void**)&dev_st,2*LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_te,2*LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_d,YE*LY*nodenum*sizeof(int));
	if(dev_d==NULL) {
		printf("couldn't allocate %d int's.\n");
	}
	cudaMemcpy(dev_te,te,2*LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_st,st,2*LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_d,d,YE*LY*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cout<<nodenum<<endl;
};
BFSor::BFSor()
{
	
};
__global__ void BFSfast(int *st,int *te,int *d,int round,int E,int N,int size)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;
	int eid=(i%(E*LY));
	int s=st[eid],t=te[eid];
	int off=(i/(E*LY))*N+(eid/E)*N*YE;
	if(d[s+off]==round-1&&d[t+off]>round)
		d[t+off]=round;
}
vector<vector<int>> BFSor::routalg(int s,int t,int bw)
{
	cout<<"blasting "<<endl;
	int kk=1;
	time_t start,end;
	start=clock();
	int size=2*edges.size()*LY*YE;
	for(int i=1;i<=WD;i++)
		BFSfast<<<size/512+1,512>>>(dev_st,dev_te,dev_d,i,2*edges.size(),nodenum,size);
	cudaMemcpy(d,dev_d,nodenum*LY*YE*sizeof(int),cudaMemcpyDeviceToHost);
	cudaStreamSynchronize(0);
	end=clock();
	cout<<"GPU time is : "<<end-start<<endl;
	cout<<"over!"<<endl;
	vector<vector<int>>result(LY,vector<int>());
	for(int k=0;k<LY;k++)
	{
		int woff=k*YE*nodenum;
		for(int i=0;i<YE;i++)
		{
			result[k].push_back(d[woff+i*nodenum+stp[i].second]);
		}
	}
	cudaFree(dev_te);
	cudaFree(dev_st);
	cudaFree(dev_d);
	cout<<"before return"<<endl;
	return result;
};