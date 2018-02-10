#include"BFS.h"
int BFS(int s,int t,vector<int>&dist,vector<int>&pre,vector<vector<int>>&neie,vector<vector<int>>&nein,set<int>sets,int size)
{
	int vflag=1;
	int tnode=-1;
	int tv=-1;
	priority_queue<pair<int, int>,vector<pair<int,int>>,std::less<std::pair<int, int>>>que;
	que.push(make_pair(s,0));
	dist[s]=0;
	while(!que.empty()&&vflag)
	{
		int node=que.top().first;
		int v=que.top().second;
		que.pop();
		for(int i=0;i<nein[node].size();i++)
		{
			if(neie[node][i]>0)
			{	
				int to=nein[node][i];
				if(dist[to]>dist[node]+1)
				{
					pre[to]=node;
					dist[to]=dist[node]+1;
					que.push(make_pair(to,dist[to]));
				}
				else
					continue;
				if(sets.find(to)!=sets.end()){size--;if(size==0)break;}
			}
		}
	}
	/*cout<<dist[tnode]<<endl;
	int prn=tnode;
	int len=0;
	if(tnode>=0)
	{
		int prn=tnode;
		while(prn!=s)
		{
			//cout<<prn<<" ";
			prn=pre[prn];
		}
		//cout<<prn<<" ";
	}
	//cout<<endl;
	result[k].push_back(tv);*/
	return dist[tnode];
}