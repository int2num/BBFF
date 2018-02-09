#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include"pathalg.h"
static const int WORK_SIZE =258;
void Bellmanor::copydata(int s,vector<edge>&edges,int nodenum){
};
void Bellmanor::dellocate(){
};
void Bellmanor::allocate(int maxn,int maxedge){
}
void Bellmanor::topsort()
{
	cout<<" in top sort "<<endl;
	queue<int>zero;
	vector<int>order(nodenum*LY,-1);
	for(int i=0;i<nodenum*LY;i++)
		zero.push(i);
	int biao=0;
	while(!zero.empty())
	{
		int node=zero.front();
		zero.pop();
		order[node]=biao++;
		for(int i=0;i<neibn[node].size();i++)
		{
			if((--ancestor[neibn[node][i]])==0)
				zero.push(neibn[node][i]);
		}
	}
	vector<pair<int,int>>tmp;
	for(int i=0;i<order.size();i++)
		tmp.push_back(make_pair(i,order[i]));
	for(int i=0;i<order.size();i++)
		ordernode.push_back(tmp[i].first);
};
void Bellmanor::updatE(vector<int>esigns)
{
	
}
void Bellmanor::updatS(vector<vector<pair<int,int>>>&stpair)
{
	L[0]=LY1;
	L[1]=LY2;
	S[0]=stpair[0].size();
	S[1]=stpair[1].size();
	int count=0;
	ncount=L[0]*S[0]+L[1]*S[1];
	for(int i=0;i<nodenum*ncount;i++)
		d[i]=INT_MAX/2,p[i]=-1;
	for(int h=0;h<stpair.size();h++)
		for(int k=0;k<L[h];k++)
			{
				int boff=k*S[h]*nodenum;
				for(int i=0;i<S[h];i++)
				{
					int soff=i*nodenum;
					for(int j=0;j<stpair[h].size();j++)
						{
						 d[boff+soff+stpair[h][i].first]=0;
						 has[boff+soff+stpair[h][i].first]=0;
						 count++;
						}
				}
			}
	for(int i=1;i<NF.size();i++)
		NF[i]=L[i-1]*S[i-1];
	cudaMemcpy(dev_d,d,ncount*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_p,p,ncount*nodenum*sizeof(int),cudaMemcpyHostToDevice);
}
void Bellmanor::init(pair<vector<edge>,vector<vector<int>>>ext,vector<pair<int,int>>stpair,vector<vector<int>>&relate,ginfo ginf):L(2,0),S(2,0),NF(2,0)
{
	/*nodenum=ginf.pnodesize;
	edges=ext.first;
	vector<vector<int>>esigns;
	esigns=ext.second;
	stp=stpair;
	W=WD+1;
	st=new int[edges.size()*LY];
	te=new int[edges.size()*LY];
	d=new int[nodenum*LY*YE];
	has=new int[nodenum*LY*YE];
	p=new int[nodenum*LY*YE];
	w=new int[edges.size()*LY];
	m1=new int;
	m2=new int;
	*m1=0,*m2=0;
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
	int cc=0;
	for(int k=0;k<LY;k++)
		for(int i=0;i<edges.size();i++)
			w[cc++]=esigns[k][i];
	cudaMalloc((void**)&dev_st,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_te,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_d,YE*LY*nodenum*sizeof(int));
	cudaMalloc((void**)&dev_p,YE*LY*nodenum*sizeof(int));
	cudaMalloc((void**)&dev_has,YE*LY*nodenum*sizeof(int));
	cudaMalloc((void**)&dev_w,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_m1,sizeof(int));
	cudaMalloc((void**)&dev_m2,sizeof(int));
	if(dev_d==NULL) {
		printf("couldn't allocate %d int's.\n");
	}
	cudaMemcpy(dev_te,te,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_st,st,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_w,w,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_has,has,YE*LY*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_m1,m1,sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_m2,m2,sizeof(int),cudaMemcpyHostToDevice);
	cout<<nodenum<<endl;*/
};
Bellmanor::Bellmanor()
{
};
__global__ void bellmanhigh(int *st,int *te,int *d,int *has,int *w,int E,int N,int size,int *m,int round,int Leveloff,int numoff,int YE,int LY)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;	
	int eid=(i%(E*LY));
	int eeid=eid+Leveloff;
	int s=st[eeid],t=te[eeid],weight=w[eeid];
	if(weight<0)return;
	int off=(i/(E*LY))*N+(eid/E)*N*YE+numoff;
	//if(has[s+off]<round-1)return;
	if(d[s+off]+weight<d[t+off])
		{
			d[t+off]=weight+d[s+off];
			has[t+off]=round;
			*m=1;
		}
}
__global__ void color(int *st,int *te,int *d,int *pre,int *has,int *w,int E,int N,int size,int round,int Leveloff,int numoff,int YE,int LY)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;	
	int eid=(i%(E*LY));
	int eeid=eid+Leveloff;
	int s=st[eeid],t=te[eeid],weight=w[eeid];
	if(weight<0)return;
	int off=(i/(E*LY))*N+(eid/E)*N*YE+numoff;
	//if(has[s+off]<round-1)return;
	if(d[s+off]+weight==d[t+off])
		pre[t+off]=s+off;
}
vector<vector<int>> Bellmanor::routalg(int s,int t,int bw)
{
	int kk=1;
	time_t start,end;
	start=clock();
	int size1=edges.size()*L[0]*S[0];
	cout<<"size is: "<<size<<endl;
	*m=1;
	int round=1;
	cout<<"asdaasadadadasd"<<endl;
	while(*m==1)
	{
		*m=0;
		cudaMemcpy(dev_m1,m1,sizeof(int),cudaMemcpyHostToDevice);
		bellmanhigh<<<size/1024+1,1024>>>(dev_st,dev_te,dev_d,dev_has,dev_w,edges.size(),nodenum,size1,dev_m1,round,0,0,S[0],0);
	 	color<<<size/1024+1,1024>>>(dev_st,dev_te,dev_d,dev_p,dev_has,dev_w,edges.size(),nodenum,size2,0,0,S[0],0);
		round++;
		cudaMemcpy(m1,dev_m2,sizeof(int),cudaMemcpyDeviceToHost);
	}
	cudaMemcpy(d,dev_d,LY*YE*nodenum*sizeof(int),cudaMemcpyDeviceToHost);
	cudaStreamSynchronize(0);
	end=clock();
	cout<<"GPU time is : "<<end-start<<endl;
	cout<<"over!"<<endl;
	vector<vector<int>>result(LY,vector<int>());
	cudaFree(dev_te);
	cudaFree(dev_st);
	cudaFree(dev_d);
	cudaFree(dev_w);
	cout<<"before return"<<endl;
	return result;
};