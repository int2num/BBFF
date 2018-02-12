#ifndef CSPALLOC_GRAPH_H
#define CSPALLOC_GRAPH_H
#include<bits/stdc++.h>
#include"edge.h"
#include"pathalg.h"
#include<set>
#include<queue>
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
        pair<int,int>prepush(int s,int t,int n,ofstream& out)
        {
        	return make_pair(0,0);
        }
        
        void routalg(int s,int t,int bw)
		{
        	vector<demand>ds1,ds2;
        	set<pair<int,int>>s1,s2;
        	vector<vector<pair<int,int>>>sarray1(5,vector<pair<int,int>>());
        	vector<vector<pair<int,int>>>sarray2(5,vector<pair<int,int>>());
        	cout<<"what f"<<endl;
        	int c1=0,c2=0;
        	for(int i=0;i<5;i++)
        		{
        		int s=rand()%5;
        		int t=s;
        		while(t==s)t=rand()%5;
        		if(s1.find(make_pair(s,t))==s1.end())
        			{
        				s1.insert(make_pair(s,t));
        				ds1.push_back(demand(s,t,c1++));
        				sarray1[s].push_back(make_pair(t,c1-1));
        			}
        		}
        	for(int i=0;i<5;i++)
        		{
        		int s=rand()%5;
        		int t=s;
        		while(t==s)t=rand()%5;
        		if(s2.find(make_pair(s,t))==s2.end())
        			{
        				s2.insert(make_pair(s,t));
        				ds2.push_back(demand(s,t,c2++));
        				sarray2[s].push_back(make_pair(t,c2-1));
        			}
        		}
        	vector<vector<Sot>>stpair(PC,vector<Sot>());
        	for(int i=0;i<sarray1.size();i++)
        		{
        		if(sarray1[i].size()==0)continue;
        		Sot S(i);
        		for(int j=0;j<sarray1[i].size();j++)
        			S.push(sarray1[i][j].first,sarray1[i][j].second);
        		stpair[0].push_back(S);	
        		}	
        	for(int i=0;i<sarray2.size();i++)
        		{
        		if(sarray2[i].size()==0)continue;
        		Sot S(i);
        		for(int j=0;j<sarray2[i].size();j++)
        			S.push(sarray2[i][j].first,sarray2[i][j].second);
        		stpair[1].push_back(S);	
        		}
        	router2.updatS(stpair);
        	vector<vector<Rout>> result=router2.routalg(0,0,0);
        	/*cout<<"returned!!!!"<<endl;
        	for(int i=0;i<result[0].size();i++)
        	{
        		int id=result[0][i].id;
        		ds1[id].backroute.push(result[0][i]);
        	}
        	for(int i=0;i<result[1].size();i++)
			{
				int id=result[1][i].id;
				ds2[id].backroute.push(result[1][i]);
			}
        	priority_queue<demand,vector<demand>,compd>dsque1,dsque2;
        	for(int i=0;i<ds1.size();i++)
        		dsque1.push(ds1[i]);
        	
        	cout<<"size of ds2 is"<<ds2.size()<<endl;
        	for(int i=0;i<ds2.size();i++)
        		dsque2.push(ds2[i]);
        	cout<<"dsque2: "<<dsque2.empty()<<endl;

        	while(!dsque1.empty())
        	{
        		demand nde=dsque1.top();
        		dsque1.pop();
        		int flag=0;
        		//cout<<nde.s<<" "<<nde.t<<":"<<endl;
        		while(!nde.backroute.empty())
        		{
        			vector<int>rout=nde.backroute.top().routes;
        			int k=nde.backroute.top().ly;
        			nde.backroute.pop();
        			flag++;
        			for(int i=0;i<rout.size();i++)
        				if(esignes[k][i]<0)
        					continue;
        			for(int i=0;i<rout.size();i++)
        				esignes[k][i]*=-1;
        			flag=rout.size();
        			break;
        		}
        		//if(flag==0)cout<<"ops!!!!"<<endl;
        		cout<<flag<<endl;
        	}
        	
        	cout<<"level of 2"<<endl;
        	cout<<"dsque2: "<<dsque2.empty()<<endl;
        	while(!dsque2.empty())
			{
				demand nde=dsque2.top();
				dsque2.pop();
				int flag=0;
				//cout<<nde.s<<" "<<nde.t<<":"<<endl;
				while(!nde.backroute.empty())
				{
					vector<int>rout=nde.backroute.top().routes;
					int k=nde.backroute.top().ly;
					nde.backroute.pop();
					flag++;
					for(int i=0;i<rout.size();i++)
						if(esignes[k][i]<0)
							continue;
					for(int i=0;i<rout.size();i++)
						esignes[k][i]*=-1;
					flag=rout.size();
					break;
				}
				if(flag==0)cout<<"ops!!!!"<<endl;
				cout<<flag<<endl;
			}*/
		}
        virtual ~Graph(){ srand(1);};
    protected:
        void addedge(int _s,int _t,int _w,double _bw=500){
            neartable[_s].push_back(edges.size());
            edges.push_back(edge(_s,_t,1));
            neartable[_t].push_back(edges.size());
            edges.push_back(edge(_t,_s,1));
        };
        virtual void GenGraph()=0;
        Graph(int _n,int _degree,algbase&alg1,algbase&alg2):n(_n),width(WD),remain(500),etn2n(n*(width+1),-1),maxnode(0),router1(alg1),router2(alg2),neartable(_n,vector<int>()){
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
            cout<<"asasd"<<endl;
            vector<vector<int>>esigns(LY,vector<int>());
            for(int i=0;i<LY;i++)
            	for(int j=0;j<2*edges.size();j++)
            	{
            		
            		int ran=rand()%100;
            		if(ran<50)
            			esigns[i].push_back(-1);
            		else
            			esigns[i].push_back(rand()%10+1);
            	}
            esignes=esigns;
            //assdsasd.
            int W=WD+1;
            vector<vector<int>>nesigns(LY,vector<int>());
            vector<edge>nedges;
            n=n*W;
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
            //asdasdasdasd.
            vector<pair<int,int>> stpair;
            stpair.push_back(make_pair(1,5));
            stpair.push_back(make_pair(3,4));
            int count=0;
            if(IFHOP>0)
            	{
            	router1.init(make_pair(nedges,nesigns),stpair,n);
            	router2.init(make_pair(nedges,nesigns),stpair,n);
            	}
           	else
            {
           		cout<<"wgat f "<<n/W<<endl;
            	router1.init(make_pair(redges,esigns),stpair,n/W);
            	router2.init(make_pair(redges,esigns),stpair,n/W);
            }
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
