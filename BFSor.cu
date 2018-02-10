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
		d[i]=INF;
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
				count++;
			}
	for(int i=0;i<nodenum*LY*YE;i++)
		d[i]=WD+1;
	cudaMalloc((void**)&dev_st,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_te,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_d,YE*LY*nodenum*sizeof(int));
	cudaMemcpy(dev_te,te,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_st,st,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	//cudaMemcpy(dev_d,d,YE*LY*nodenum*sizeof(int),cudaMemcpyHostToDevice);
};
BFSor::BFSor():L(PC+1,0),S(PC,0),NF(PC,0),Size(2,0)
{
};
__global__ void BFSfast(int *st,int *te,int *d,int E,int N,int size,int round,int Leveloff,int numoff,int ye,int ly)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;	
	int eid=(i%(E*ly));
	int eeid=eid+Leveloff;
	int s=st[eeid],t=te[eeid];
	if(s==t)return;
	int off=(i/(E*ly))*N+(eid/E)*N*ye+numoff;
	if(d[s+off]==round-1&&d[t+off]>round)
		d[t+off]=round;
}
vector<vector<vector<int>>> BFSor::routalg(int s,int t,int bw)
{
	cout<<"blasting "<<endl;
	int kk=1;
	time_t start,end;
	start=clock();
	int size=edges.size()*LY*YE;
	/*for(int i=0;i<8;i++)
		{
			for(int j=0;j<nodenum;j++)
				cout<<d[i*nodenum+j]<<" ";
			cout<<endl;
		}*/
	cout<<"size"<<Size[0]<<endl;
	int leoff=edges.size()*L[1];
	int nuoff=L[1]*S[0]*nodenum;
	for(int i=1;i<=WD;i++)
		{
			BFSfast<<<Size[0]/512+1,512>>>(dev_st,dev_te,dev_d,edges.size(),nodenum,Size[0],i,0,0,S[0],L[1]);
			BFSfast<<<Size[1]/512+1,512>>>(dev_st,dev_te,dev_d,edges.size(),nodenum,Size[1],i,leoff,nuoff,S[1],L[2]);
		}
	cudaMemcpy(d,dev_d,LY*YE*nodenum*sizeof(int),cudaMemcpyDeviceToHost);
	vector<vector<vector<int>>>result(2,vector<vector<int>>());
	vector<vector<int>>darray1,darray2;
	/*for(int j=0;j<L[0];j++)
	{
		vector<int>res;
		for(int k=0;k<stps[0].size();k++)
			res.push_back(d[j*stps[0].size()*nodenum+k*nodenum]);
		darray1.push_back(res);
	}
	
	for(int j=0;j<L[1];j++)
	{
		vector<int>res;
		for(int k=0;k<stps[1].size();k++)
			res.push_back(d[L[0]*stps[0].size()*nodenum+j*stps[1].size()*nodenum+k*nodenum]);
		darray2.push_back(res);
	}
	result.push_back(darray1);
	result.push_back(darray2);*/
	/*for(int i=0;i<8;i++)
		{
			for(int j=0;j<nodenum;j++)
				cout<<d[i*nodenum+j]<<" ";
			cout<<endl;
		}*/
	cudaMemcpy(d,dev_d,nodenum*LY*YE*sizeof(int),cudaMemcpyDeviceToHost);
	cudaStreamSynchronize(0);
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