#include <iostream>
#include"Graph.h"
#include"pathalg.h"
#include<sys/time.h>
int main()
{
	ofstream outfile;
	outfile.open("data.txt", ios::app);
	//Bellmanor d1=Bellmanor();
    //PBellmanor d2=PBellmanor();
	BFSor d1=BFSor();
	PBFSor d2=PBFSor();
    ERGraph graph(5,1,d2,d1);
    graph.routalg(0,0,0);
}
