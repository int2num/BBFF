#include <iostream>
#include"Graph.h"
#include"pathalg.h"
#include<sys/time.h>
int main(int args,char*arg[])
{
	ofstream outfile;
	outfile.open("data.txt", ios::app);
	cout<<"*******************************************************************************"<<endl;
	cout<<NODE<<" "<<LY<<" "<<DSIZE*40<<" "<<SERT<<endl;
	Bellmanor d1=Bellmanor();
    PBellmanor d2=PBellmanor();
	//BFSor d1=BFSor();
	//PBFSor d2=PBFSor();
    ERGraph graph(NODE,1,d2,d1);
    double sert=SERT;
    double lambda=1/sert;
    //void run(float ratio,float lambda,float MAXNUM,int _method,int _paral)
  	//graph.run(0.2,lambda,OBNUM,0,1);
    switch (arg[1][0])
    	  {
    	  	  case 'F':
    	  	  {
    	  		  	  cout<<"parall relaize:"<<endl;
    	  		  	  graph.run(0.2,lambda,OBNUM,0,1);
    	  			  break;
    	  	  }
    	  	  case 'P':
    	  	  {
    	  		     cout<<"serial relaize:"<<endl;
    	  		     graph.run(0.2,lambda,OBNUM,0,0);
    	  			 break;
    	  	  }
    	  	  case 'S':
    	  		  {
    	  			  cout<<"worst relaize:"<<endl;
    	  			  graph.run(0.2,lambda,OBNUM,1,0);
    	  			  break;
    	  		  }
    	  	  
    	  }
	cout<<"*******************************************************************************"<<endl;
}
