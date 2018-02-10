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
	cout<<"inasd asd"<<endl;
	L[0]=LY1;
	L[1]=LY2;
	S[0]=stpair[0].size();
	S[1]=stpair[1].size();
	int count=0;
	ncount=L[0]*S[0]+L[1]*S[1];
	for(int i=0;i<nodenum*ncount;i++)
		d[i]=100000,p[i]=-1;
	int woffid=0;
	for(int h=0;h<stpair.size();h++)
		{
		for(int k=0;k<L[h];k++)
			{
			for(int j=0;j<stpair[h].size();j++)
				{
				 d[count*nodenum+stpair[h][j].first]=0;
				 count++;
				}
			}
		}
	cout<<"here it is "<<endl;
	for(int i=1;i<NF.size();i++)
		NF[i]=L[i-1]*S[i-1];
	nodeoff[0]=0;
	nodeoff[1]=S[0]*L[0]*nodenum;
	leveloff[0]=0;
	leveloff[1]=L[0]*edges.size();
	size[0]=edges.size()*L[0]*S[0];
	size[1]=edges.size()*L[1]*S[1];
	cout<<"asd"<<endl;
	cout<<"ncount is "<<count <<endl;
	cudaMemcpy(dev_d,d,ncount*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_p,p,ncount*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cout<<"out!!!!"<<endl;
}
void Bellmanor::init(pair<vector<edge>,vector<vector<int>>>ext,vector<pair<int,int>>stpair,vector<vector<int>>&relate,ginfo ginf)
{
	cout<<"init bellmanor"<<endl;
	nodenum=ginf.pnodesize;
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
	vector<vector<int>>rus(nodenum,vector<int>());
	vector<vector<int>>ruw(nodenum,vector<int>());
	for(int i=0;i<edges.size();i++)
		{
			int s=edges[i].s;
			int t=edges[i].t;
			rus[t].push_back(s);
			ruw[t].push_back(i);
			neibn[s].push_back(t);
			neie[s].push_back(i);
		}
	mm=0;
	for(int i=0;i<rus.size();i++)
		if(rus[i].size()>mm)mm=rus[i].size();
	rudu=new int[nodenum*mm*LY];
	rudw=new int[nodenum*mm*LY];
	for(int k=0;k<LY;k++)
		{
		int off=k*nodenum*mm;
		for(int i=0;i<nodenum;i++)
		{
			for(int j=0;j<mm;j++)
				if(j<rus[i].size())
					rudu[off+i*mm+j]=rus[i][j];
				else
					rudu[off+i*mm+j]=INT_MAX;
			for(int j=0;j<mm;j++)
				if(j<rus[i].size())
					rudw[off+i*mm+j]=esigns[k][ruw[i][j]];
				else
					rudw[off+i*mm+j]=-1;
		}
		}
	/*for(int i=0;i<nodenum;i++)
		{for(int j=0;j<mm;j++)
			{
			if(rudu[i*mm+j]<INT_MAX)
				cout<<rudu[i*mm+j]<<" ";
			}
		cout<<endl;
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
	cudaMalloc((void**)&dev_w,LY*edges.size()*sizeof(int));
	cudaMalloc((void**)&dev_m1,sizeof(int));
	cudaMalloc((void**)&dev_m2,sizeof(int));
	cudaMalloc((void**)&dev_rudu,mm*LY*nodenum*sizeof(int));
	cudaMalloc((void**)&dev_rudw,mm*LY*nodenum*sizeof(int));
	
	if(dev_d==NULL) {
		printf("couldn't allocate %d int's.\n");
	}
	cudaMemcpy(dev_te,te,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_st,st,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_w,w,LY*edges.size()*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_rudu,rudu,mm*LY*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_rudw,rudw,mm*LY*nodenum*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_m1,m1,sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_m2,m2,sizeof(int),cudaMemcpyHostToDevice);
	//cout<<nodenum<<endl;
};
Bellmanor::Bellmanor():L(2,0),S(2,0),NF(2,0),nodeoff(2,0),leveloff(2,0),size(2,0)
{
};
__global__ void bellmanhigh(int *st,int *te,int *d,int *has,int *w,int E,int N,int size,int *m,int round,int Leveloff,int numoff,int ye,int ly)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;	
	int eid=(i%(E*ly));
	int eeid=eid+Leveloff;
	int s=st[eeid],t=te[eeid],weight=w[eeid];
	if(weight<0)return;
	int off=(i/(E*ly))*N+(eid/E)*N*ye+numoff;
	//if(has[s+off]<round-1)return;
	if(d[s+off]+weight<d[t+off])  
		{
			d[t+off]=weight+d[s+off];
			//has[t+off]=round;
			*m=1;
		}
}
__global__ void bellmandu(int *rudu,int*rudw,int *d,int*p,int N,int size,int sizeoff,int leveloff,int ye,int ly,int mm)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>=size)return;
	int lyy=i/(ye*N)+leveloff;
	int yee=(i%(ye*N))/N;
	int off=lyy*N*ye+yee*N;
	int roff=(i%N+lyy*N)*mm;
	i+=sizeoff;
	int dm=d[i];
	int mark=-1;
	for(int k=0;k<mm;k++)
		if(rudu[roff+k]<INT_MAX)
		{
			int node=rudu[roff+k]+off;
			if(rudw[roff+k]<0)continue;
			if(dm>d[node]+rudw[roff+k])
				{dm=d[node]+rudw[roff+k];
				mark=k;
				}
		}
	if(d[i]>dm)
		d[i]=dm,p[i]=k;
	//if(sizeoff>0)
		//d[i]=0;
}
__global__ void color(int *st,int *te,int *d,int *pre,int *has,int *w,int E,int N,int size,int round,int Leveloff,int numoff,int ye,int ly)
{
	int i = threadIdx.x + blockIdx.x*blockDim.x;
	if(i>size)return;	
	int eid=(i%(E*ly));
	int eeid=eid+Leveloff;
	int s=st[eeid],t=te[eeid],weight=w[eeid];
	if(weight<0)return;
	int off=(i/(E*ly))*N+(eid/E)*N*ye+numoff;
	//if(has[s+off]<round-1)return;
	if(d[s+off]+weight==d[t+off])
		pre[t+off]=s+off;
}
vector<vector<int>> Bellmanor::routalg(int s,int t,int bw)
{
	cout<<"inbellman"<<endl;
	int kk=1;
	time_t start,end;
	start=clock();
	*m1=1;
	*m2=1;
	int round=1;
	cout<<"fuck wx!"<<endl;
	int flag1=0,flag2=0;
	int cc=0;
	/*while(*m2==1||*m1==1)
	{
		*m2=0,*m1=0;
		cudaMemcpyAsync(dev_m2,m2,sizeof(int),cudaMemcpyHostToDevice,stream1);
		bellmanhigh<<<size[1]/1024+1,1024,0,stream1>>>(dev_st,dev_te,dev_d,dev_has,dev_w,edges.size(),nodenum,size[1],dev_m2,round,leveloff[1],nodeoff[1],S[1],L[1]);
		cudaMemcpyAsync(dev_m1,m1,sizeof(int),cudaMemcpyHostToDevice,stream0);
		bellmanhigh<<<size[0]/1024+1,1024,0,stream0>>>(dev_st,dev_te,dev_d,dev_has,dev_w,edges.size(),nodenum,size[0],dev_m2,round,leveloff[0],nodeoff[0],S[0],L[0]);
		color<<<size[1]/1024+1,1024,0,stream1>>>(dev_st,dev_te,dev_d,dev_p,dev_has,dev_w,edges.size(),nodenum,size[1],round,leveloff[1],nodeoff[1],S[1],L[1]);
		cudaMemcpyAsync(m2,dev_m2,sizeof(int),cudaMemcpyDeviceToHost,stream1);
		color<<<size[0]/1024+1,1024,0,stream0>>>(dev_st,dev_te,dev_d,dev_p,dev_has,dev_w,edges.size(),nodenum,size[0],round,leveloff[0],nodeoff[0],S[0],L[0]);
		cudaMemcpyAsync(m1,dev_m1,sizeof(int),cudaMemcpyDeviceToHost,stream0);
		cudaStreamSynchronize(stream1);
		cudaStreamSynchronize(stream0);
	}*/
	cout<<"here it is "<<endl;
	int size0=nodenum*L[0]*S[0];
	int size1=nodenum*L[1]*S[1];
	cudaStream_t stream0;
	cudaStreamCreate(&stream0);
	cudaStream_t stream1;
	cudaStreamCreate(&stream1);
	cout<<"l1:"<<L[1]<<endl;
	for(int i=0;i<WD+1;i++)
	{
		bellmandu<<<size0/1024+1,1024,0,stream0>>>(dev_rudu,dev_rudw,dev_d,nodenum,size0,0,0,S[0],L[0],mm);
		bellmandu<<<size1/1024+1,1024,0,stream1>>>(dev_rudu,dev_rudw,dev_d,nodenum,size1,size0,0,S[1],L[1],mm);
	}
	cudaStreamSynchronize(stream1);
	cudaStreamSynchronize(stream0);
	cudaMemcpy(d,dev_d,LY*YE*nodenum*sizeof(int),cudaMemcpyDeviceToHost);
	/*for(int j=0;j<200;j++)
		{for(int i=0;i<nodenum;i++)
			cout<<d[i+j*nodenum]<<" ";
		cout<<endl;
		}*/
	cout<<endl;
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