#ifndef BFS_ALG
#define BFS_ALG
#include<vector>
#include<queue>
#include<set>
using namespace std;
int BFS(int s,int t,vector<int>&dist,vector<int>&pre,vector<vector<int>>&neie,vector<vector<int>>&nein,set<int>sets,int size);
int dijkstra(int s,int t,vector<int>&dist,vector<int>&pre,vector<vector<int>>&neie,vector<vector<int>>&nein,int,int,set<int>sets,int size);
#endif