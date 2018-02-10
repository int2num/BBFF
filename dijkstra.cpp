#include"BFS.h"
#include"Heap.h"
#include"limits.h"
int dijkstra(int s,int t,vector<int>&d,vector<int>&peg,vector<vector<int>>&neie,vector<vector<int>>&nein,int nodenum,int WD,set<int>sets,int size){
	int tnode=-1;
	vector<int>flag(nodenum,0);
	for (int i = 0;i<nodenum;i++)
	if (i == s)
		d[i]=0;
	else
		d[i]=INT_MAX/2;
	for (int i=0; i<nodenum; i++)
	{
		flag[i]=0;
		peg[i]=-1;
	}
	int cur = s;
	Heap heap(nodenum);
	for (int i = 0;i<nodenum;i++)
		heap.push(i,d[i]);
	do{
		int cur = heap.pop();
		flag[cur] = 1;
		int accual=cur/(WD+1);
		if (sets.find(accual)!=sets.end())
			{	
				size--;
				set<int>::iterator iter=sets.begin();
				for(iter;iter!=sets.end();iter++)
					if(*iter==accual)
						sets.erase(iter);
				if(size==0)
					break;
			}
		int size = nein[cur].size();
		for (int i = 0;i<size; i++){
				int to=nein[cur][i];
				if (flag[to] ==0&&d[to]>(d[cur]+neie[cur][i])&&neie[cur][i]>0){
					d[to] = d[cur]+neie[cur][i];
					heap.update(to, d[to]);
					peg[to]=cur;
				}
		}
	} while (!heap.empty());
	return d[t];
}
