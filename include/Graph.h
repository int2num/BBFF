#ifndef CSPALLOC_GRAPH_H
#define CSPALLOC_GRAPH_H
#include<bits/stdc++.h>
#include"edge.h"
#include"pathalg.h"
#include<set>
#include<queue>
#define LAMBDA 0.5
#define ADDNUM 100
using namespace std;
enum SPWAY {NORMAL,ROUTE,ROTATE,ROTATE_DELETE,PUSH};
struct levelGraph {
    vector<int>startnodes;
    vector<int>startedges;
    int nodenum=-1;
    int edgenum=-1;
    vector<edge>edges;
    vector<vector<edge>>neartable;
    int levelsize;
};
struct fedge{
	int from,to,price,cap;
	fedge(int f,int t,int p,int c):from(f),to(t),price(p),cap(c){};
};
double randomExponential(double lambda)
{
    double pV = 0.0;
    while(true)
    {
        pV = (double)rand()/(double)RAND_MAX;
        if (pV != 1)
        {
            break;
        }
    }
    pV = (-1.0/lambda)*log(1-pV);
    return pV;
};
class Graph
{
    public:
        double remain;
        vector<edge>edges,extenedges;
        vector<vector<edge>>extable;
        unordered_map<int,levelGraph>levels ;
        int n,width,maxnode,maxedge;
        vector<int>etn2n,exe2e;
        vector<vector<int>>relate,neartable;
        vector<vector<int>>esignes;
        algbase&router1;
        algbase&router2;
        int current;
        priority_queue<event,vector<event>,cevent>timeque;
        vector<double>average;
        vector<int>blocks;
        int busy;
        int reles;
        void run()
        {
        	busy=0;
        	int count=0;
        	current=0;
        	int release=0;
        	while(!timeque.empty())
        	{
        		event ee=timeque.top();
        		count++;
        		current=ee.time;
        		//if(current>4)break;
        		if(ee.fuhao>0)
        			{
        				cout<<"adding................. "<<current<<endl;
        				routalg(0,0,0);
        				count++;
        			}
        		else
        			{
        				//cout<<"subing.................."<<current<<endl;
        				for(int i=0;i<ee.rout.size();i++)
        					{
        						int eid=ee.rout[i];
        						if(IFHOP<1)
        							esignes[ee.level][eid]*=-1;
        						if(IFHOP==1)
        						{
        							eid=(eid/WD)*WD;
        							//cout<<"eid is "<<eid<<endl;
        							for(int j=0;j<WD;j++)
        								esignes[ee.level][eid+j]*=-1;
            						release++;
        						}
        					}
        				router1.updatE(esignes);
        				router2.updatE(esignes);
        			}
        	timeque.pop();
        	}
        	cout<<"release: "<<release<<endl;
        	cout<<"beasy: "<<busy<<endl;
        	for(int i=0;i<average.size();i++)
        		cout<<average[i]<<" ";
        	cout<<endl;
        	for(int i=0;i<blocks.size();i++)
        		cout<<blocks[i]<<" ";
        	cout<<endl;
        }
        vector<vector<Sot>>Getspair(vector<vector<demand>>&ds)
		{
        	vector<vector<vector<pair<int,int>>>>sarray(PC,vector<vector<pair<int,int>>>(n,vector<pair<int,int>>()));
        	for(int k=0;k<PC;k++)
        	{
        		for(int i=0;i<ds[k].size();i++)
        		{
        			demand dd=ds[k][i];
        			if(dd.mark==1)continue;
        			sarray[k][dd.s].push_back(make_pair(dd.t,dd.id));
        		}
        	}
        	vector<vector<Sot>>stpair(PC,vector<Sot>());
        	for(int k=0;k<PC;k++)
        	{
        		for(int i=0;i<sarray[k].size();i++)
        		{
        			if(sarray[k][i].size()==0)continue;
        			Sot S(i);
        			for(int j=0;j<sarray[k][i].size();j++)
        				S.push(sarray[k][i][j].first,sarray[k][i][j].second);
        			stpair[k].push_back(S);
        		}	
        	}
        	return stpair;
		}
        vector<vector<demand>>Gendemand(vector<int>&tasknum)
		{
        	vector<vector<demand>>ds(PC,vector<demand>());
			int c1=0;
			for(int k=0;k<PC;k++)
			{
				set<pair<int,int>>se;
				c1=0;
				for(int i=0;i<tasknum[k];i++)
				{
				int s=rand()%n;
				int t=s;
				while(t==s)t=rand()%n;
				if(se.find(make_pair(s,t))==se.end())
					{
						se.insert(make_pair(s,t));
						ds[k].push_back(demand(s,t,c1++));
					}
				}
			}
			return ds;
		}
        vector<vector<demand>>greedy(vector<vector<demand>>&ds,vector<demand>&addin,vector<demand>&block)
		{
        	vector<vector<Sot>>stpair=Getspair(ds);
			router2.updatS(stpair);
			router2.updatE(esignes);
			vector<vector<Rout>> result=router2.routalg(0,0,0);
			for(int k=0;k<PC;k++)
				for(int i=0;i<result[k].size();i++)
				{
					int id=result[k][i].id;
					ds[k][id].backroute.push(result[k][i]);
				}
			vector<priority_queue<demand,vector<demand>,compd>>dsque(2,priority_queue<demand,vector<demand>,compd>());
			vector<vector<demand>>remain(PC,vector<demand>());
			for(int k=0;k<PC;k++)
				for(int i=0;i<ds[k].size();i++)
					dsque[k].push(ds[k][i]);
			for(int k=0;k<PC;k++)
				while(!dsque[k].empty())
				{
					demand nde=dsque[k].top();
					dsque[k].pop();
					int flag=0;
					
					while(!nde.backroute.empty())
					{
						int ly=nde.backroute.top().ly;
						int v=nde.backroute.top().di;
						vector<int>rout=nde.backroute.top().routes;
						int k=nde.backroute.top().ly;
						nde.backroute.pop();
						for(int i=0;i<rout.size();i++)
							if(esignes[k][rout[i]]<0)
								{
									flag=-1;
									continue;
								}
						for(int i=0;i<rout.size();i++)
							{
								int eid=rout[i];
								if(IFHOP<1)
									esignes[k][eid]*=-1;
								if(IFHOP==1)
								{
									eid=(eid/WD)*WD;
									for(int j=0;j<WD;j++)
										{
											esignes[k][eid+j]*=-1;
											busy++;
										}
								}
							}
						flag=rout.size();
						nde.rout=rout;
						nde.mark=ly;
						nde.value=v;
						addin.push_back(nde);
						break;
					}
					if(flag==0){
						//cout<<"blocking"<<endl;
						block.push_back(nde);
					}
					if(flag<0){
						//cout<<"remaining"<<endl;
						remain[k].push_back(nde);
					}
					//scout<<flag<<endl;
				}
			return remain;
		}
        void routalg(int s,int t,int bw)
		{
        	vector<int>tasknum;
        	int num=rand()%10+10;
        	tasknum.push_back(num*2);
        	tasknum.push_back(num*3);
        	vector<vector<demand>>ds=Gendemand(tasknum);
			vector<demand>block;
			vector<demand>addin;
			time_t start=clock();
			//serialadd(ds,addin,block);
			while(ds[0].size()>0||ds[1].size()>0)
				ds=greedy(ds,addin,block);
			cout<<"serial over !"<<endl;
			time_t end=clock();
			int count=0;
			for(int i=0;i<addin.size();i++)
				count+=addin[i].value;
			for(int i=0;i<addin.size();i++)
			{
				int serv=0;//randomExponential(LAMBDA);
				demand dd=addin[i];
				if(serv+current+1<ADDNUM)
					timeque.push(event(-1,serv+current+1,dd.rout,dd.mark));
			}
			cout<<"what f"<<endl;
			average.push_back((double)count/(double)addin.size());
			blocks.push_back(block.size());
			//cout<<"add in rout cost is "<<count<<endl;
			//cout<<"add in is "<<addin.size()<<endl;
			//cout<<"time is"<<end-start<<endl;
		}
        void serialadd(vector<vector<demand>>&ds,vector<demand>&addin,vector<demand>&block)
        {
			router1.updatE(esignes);
        	vector<int>L(3,0);
        	L[0]=0;L[1]=LY1;L[2]=LY2+LY1;
        	for(int y=1;y<PC+1;y++)
        		{
        			for(int i=0;i<ds[y-1].size();i++)
        			{
        				int s=ds[y-1][i].s;
        				int t=ds[y-1][i].t;
        				int flag=0;
        				for(int k=L[y-1];k<L[y];k++)
        				{
        					vector<int> rout=router1.tunel(s,t,k);
        					//cout<<rout.size()<<endl;
        					int w=0;
        					if(rout.size()>0){
        						ds[y-1][i].rout=rout;
        						for(int l=0;l<rout.size();l++)
        							{
                						int eid=ds[y-1][i].rout[l];
        								w+=esignes[k][eid];
                						if(IFHOP<1)
                							esignes[k][eid]*=-1;
                						if(IFHOP==1)
                						{
                							eid=(eid/WD)*WD;
                							for(int j=0;j<WD;j++)
                								esignes[k][eid+j]*=-1;
                							busy++;
                						}
        							}
        						router1.updatE(esignes);
        						ds[y-1][i].mark=k;
        						ds[y-1][i].value=w;
        						addin.push_back(ds[y-1][i]);
        						flag=1;
        						break;
        					}
        				}
        				if(flag==0)block.push_back(ds[y-1][i]);
        			}
        		}
        	
        }
        virtual ~Graph(){ 
        	srand(1);
        };
    protected:
        void addedge(int _s,int _t,int _w,double _bw=500){
            neartable[_s].push_back(edges.size());
            edges.push_back(edge(_s,_t,1));
            neartable[_t].push_back(edges.size());
            edges.push_back(edge(_t,_s,1));
        };
        virtual void GenGraph()=0;
        Graph(int _n,int _degree,algbase&alg1,algbase&alg2):n(_n),width(WD),remain(500),etn2n(n*(width+1),-1),maxnode(0),router1(alg1),router2(alg2),neartable(_n,vector<int>()){
        	for(int i=0;i<ADDNUM;i++)
        	{
        		int k=rand()%100;
        		if(k<30)
        			timeque.push(event(1,i));
        	}
        };
        pair<vector<edge>,vector<vector<int>>> extend()
        {
        	vector<vector<int>>rs(edges.size(),vector<int>());
        	relate=rs;
        	vector<int>es(edges.size()*(width+1),-1);
        	exe2e=es;
        	for(int i=0;i<neartable.size();i++)
				for(int k=0;k<width;k++)
					for(int j=0;j<neartable[i].size();j++)
						{
							if(edges[neartable[i][j]].w+k<=width)
							{
								edge e=edges[neartable[i][j]];
								int s=i+n*k;
								etn2n[s]=i;
								int t=e.t+n*(k+1);
								etn2n[t]=e.t;
								exe2e[extenedges.size()]=neartable[i][j];
								relate[neartable[i][j]].push_back(extenedges.size());
								extenedges.push_back(edge(s,t,e.w));
								if(s>maxnode||t>maxnode)
									maxnode=max(s,t);
							}
						}
        	vector<vector<int>>erelate(extenedges.size(),vector<int>());
        	for(int i=0;i<extenedges.size();i++)
        		erelate[i]=relate[exe2e[i]];
            maxedge=extenedges.size()-1;
            vector<edge> pedges;
            for(int i=0;i<edges.size();i++)
            {
                for(int k=0;k<width;k++)
                	{
                		int s=edges[i].s+n*k;
                		int t=edges[i].t+n*(k+1);
                		pedges.push_back(edge(s,t,1));
                	}
            }
            vector<vector<int>>near(maxnode,vector<int>());
            for(int i=0;i<edges.size();i++)
            {
            	int s=edges[i].s;
            	int t=edges[i].t;
            	near[s].push_back(edges[i].t);
            }
            vector<edge>redges;
            for(int i=0;i<near.size();i++)
            	for(int j=0;j<near[i].size();j++)
            		redges.push_back(edge(i,near[i][j],1));
            //cout<<"asasd"<<endl;
            vector<vector<int>>esigns(LY,vector<int>());
            for(int i=0;i<LY;i++)
            	for(int j=0;j<2*edges.size();j++)
            	{
            		
            		int ran=rand()%100;
            		if(ran<20)
            			esigns[i].push_back(-1);
            		else
            		esigns[i].push_back(rand()%10+1);
            	}
            esignes=esigns;
            int W=WD+1;
            vector<vector<int>>nesigns(LY,vector<int>());
            vector<edge>nedges;
            if(IFHOP>0)
            {
				for(int i=0;i<redges.size();i++)
				{
					int s=redges[i].s;
					int t=redges[i].t;
					for(int j=0;j<W-1;j++)
					{
						int ss=s*W+j;
						int tt=t*W+j+1;
						nedges.push_back(edge(ss,tt,1));
					}
				}
				for(int k=0;k<LY;k++)
					for(int i=0;i<redges.size();i++)
					{
						for(int j=0;j<W;j++)
						{
							nesigns[k].push_back(esigns[k][i]);
						}
					}
            }
            //asdasdasdasd.
            vector<pair<int,int>> stpair;
            stpair.push_back(make_pair(1,5));
            stpair.push_back(make_pair(3,4));
            int count=0;
            if(IFHOP>0)
            	{
            	router1.init(make_pair(nedges,nesigns),stpair,n*W);
            	router2.init(make_pair(nedges,nesigns),stpair,n*W);
            	}
           	else
            {
           		//cout<<"wgat f "<<n/W<<endl;
            	router1.init(make_pair(redges,esigns),stpair,n);
            	router2.init(make_pair(redges,esigns),stpair,n);
            }
            if(IFHOP>0)
            	esignes=nesigns;
            return make_pair(redges,esigns);
        };
};
class ERGraph:public Graph{
public:
    ERGraph(int _n,int _degree,algbase&alg1,algbase&alg2):Graph(_n,_degree,alg1,alg2){
    	cout<<"before gen graph"<<endl;
    	GenGraph();
    	cout<<"gen graph success"<<endl;
    	extend();
    };
private:
    virtual void GenGraph(){
        int count = 0;
        set<pair<int, int>>flag;
        double threhod = 6*n/((n-1));
        for (int i = 0; i <n; i++)
            for (int j =i+1; j<n;j++)
                if (i != j)
                {
                    double ran=(double)(rand()%n);
                    if (ran<threhod)
                    {
                        if (flag.find(make_pair(i, j))==flag.end())
                        {
                            addedge(i,j,rand()%3+1);
                            flag.insert(make_pair(i,j));
                            flag.insert(make_pair(j,i));
                        }
                    }
                }
    };
private:
    void checkflow(int src,int dst,enum SPWAY cache = NORMAL)
    {}
};
class BAGraph:public Graph{
public:
    BAGraph(int _n,int _degree,algbase&alg1,algbase&alg2):Graph(_n,_degree,alg1,alg2){GenGraph();extend();};
private:
    virtual void GenGraph(){
        int todu = 0;
        int count = 0;
        int k =3;
        vector<int>du(n,0);
        for (int i = 0; i < 5; i++)
        {
            addedge(i,i+1,rand()%3+1);
            du[i]++;
            du[i + 1]++;
            todu += 2;
        }
        for (int i = 5; i < n; i++)
        {
            int addin = 0;
            while (addin < k)
            {
                for (int j = 0; j < n; j++)
                {
                    if (i!=j&&rand() % todu < du[j])
                    {
                        addedge(i,j,rand()%3+1);
                        du[i]++;
                        du[j]++;
                        todu += 2;
                        addin++;
                    }
                    if (addin >= k)
                        break;
                }
            }
        }
    };
};
#endif
