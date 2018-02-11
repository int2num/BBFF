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
void BFSor::updatE(vector<int>esigns)
{
};
void BFSor::updatS(vector<vector<Sot>>&stpair)
{
	L[0]=0;
	L[1]=LY1;
	L[2]=LY2;
	S[0]=stpair[0].size();
	S[1]=stpair[1].size();
	stps=stpair;
	int count=0;
	ncount=L[1]*S[0]+L[2]*S[1];
	for(int i=0;i<nodenum*ncount;i++)
		d[i]=INF,p[i]=-1;
	int nut=(IFHOP>0)?(WD+1):1;
	for(int h=0;h<stpair.size();h++)
		{
		for(int k=0;k<L[h+1];k++)
			{
			for(int j=0;j<stpair[h].size();j++)
				{
				 d[count*nodenum+stpair[h][j].s*nut]=0;
				 count++;
				}
			}
		}
	Size[0]=edges.size()*L[1]*S[0];
	Size[1]=edges.size()*L[2]*S[1];
	cudaMemcpy(dev_d,d,ncount*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_p,p,ncount*nodenum*sizeof(int),cudaMemcpyHostToDevice);
}
void BFSor::init(pair<vector<edge>,vector<vector<int>>>ext,vector<pair<int,int>>stpair,vector<vector<int>>&relate,ginfo ginf)
{
	cout<<"in BFS init"<<endl;
	nodenum=ginf.pnodesize;
	edges=ext.first;
	vector<vector<int>>esigns;
	esigns=ext.second;
	stp=stpair;
	mark=new int;
	*mark=0;
	W=WD+1;
	st=new int[edges.size()*LY];
	te=new int[edges.size()*LY];
	stid=new int[edges.size()*LY]
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
			neie[s].push_back(i);
		}
	/*for(int i=0;i<LY;i++)
		{	
			int off=LY*edges.size();
			for(int j=0;j<edges.size();j++)
				esignes[off+i]=esigns[i][j];
		}*/
	int count=0;
	for(int k=0;k<LY;k++)
		for(int i=0;i<nodenum;i++)
			for(int j=0;j<neibn[i].size();j++)
			{
				st[count]=i;
				if(esigns[k][neie[i][j]]<0)
					te[count]=i;
				else
					te[count]=neibn[i][j];
				stid[count]=neie[i][j];
				count++;
			}
	
	for(int i=0;i<nodenum*LY*YE;i++)
		d[i]=WD+1,p[i]=-1;
	cudaMalloc((void**)&dev_st,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_te,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_stid,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_esignes,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_d,YE*LY*nodenum*sizeof(int));
	cudaMalloc((void**)&dev_p,YE*LY*nodenum*sizeof(int));
	cudaMemcpy(dev_te,te,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_st,st,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_stid,stid,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_esignes,esignes,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
};
BFSor::BFSor():L(PC+1,0),S(PC,0),NF(PC,0),Size(2,0)
{
};
__global__ void BFSfast(int *st,int *te,int *d,int *stid,int E,int N,int size,int round,int Leveloff,int numoff,int ye,int ly)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;	
	int eid=(i%(E*ly));
	int eeid=eid+Leveloff;
	int s=st[eeid],t=te[eeid];
	if(s==t)return;
	int off=(i/(E*ly))*N+(eid/E)*N*ye+numoff;
	if(d[s+off]==round-1&&d[t+off]>round)
		{	d[t+off]=round;
			p[t+off]=stid[eeid];
		}
}
vector<vector<Rout>> BFSor::routalg(int s,int t,int bw)
{
	cout<<"blasting "<<endl;
	int kk=1;
	time_t start,end;
	start=clock();
	int size=edges.size()*LY*YE;
	cudaStream_t stream0;
	cudaStreamCreate(&stream0);
	cudaStream_t stream1;
	cudaStreamCreate(&stream1);
	int leoff=edges.size()*L[1];
	int nuoff=L[1]*S[0]*nodenum;
	for(int i=1;i<=WD;i++)
		{
			BFSfast<<<Size[0]/512+1,512,0,stream0>>>(dev_st,dev_te,dev_d,dev_stid,edges.size(),nodenum,Size[0],i,0,0,S[0],L[1]);
			BFSfast<<<Size[1]/512+1,512,0,stream1>>>(dev_st,dev_te,dev_d,dev_stid,edges.size(),nodenum,Size[1],i,leoff,nuoff,S[1],L[2]);
		}
	cudaStreamSynchronize(stream1);
	cudaStreamSynchronize(stream0);
	cudaMemcpy(d,dev_d,LY*YE*nodenum*sizeof(int),cudaMemcpyDeviceToHost);
	cudaMemcpy(p,dev_p,LY*YE*nodenum*sizeof(int),cudaMemcpyDeviceToHost);
	vector<vector<Rout>>result(2,vector<Rout>());
	for(int y=1;y<PC+1;y++)
		for(int k=L[y-1];k<L[y];k++)
		{
			int tnode=-1;
			for(int l=0;l<stpairs[y-1].size();l++)
			{	
				int s=stpairs[y-1][l].s*(WD+1);
				vector<int>ters=stpairs[y-1][l].ters;
				for(int i=0;i<ters.size();i++)
				{
					Rout S()
					result 
				}
				
			}
		}
	
	
	
	
	
	
	
	
	end=clock();
	cout<<"GPU time is : "<<end-start<<endl;
	cout<<"over!"<<endl;
	cudaFree(dev_te);
	cudaFree(dev_st);
	cudaFree(dev_d);
	cout<<"before return"<<endl;
	return result;
};
/*__global__ void BFSfast(int *st,int *te,int *d,int round,int E,int N,int size)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;
	int eid=(i%(E*LY));
	int s=st[eid],t=te[eid];
	int off=(i/(E*LY))*N+(eid/E)*N*YE;
	if(d[s+off]==round-1&&d[t+off]>round)
		d[t+off]=round;
}*/