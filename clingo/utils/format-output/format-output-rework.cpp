/* 
  *File: format-output.cc
  *Last Updated on 8/19/09
  *By Tae-Won Kim

  *Turn output from the answer set solvers 
   to a more readable format.

  *Reworked by Ondrej Vasicek 2023.08.31, 2025.06.11
    - uses std::vector for "infinite" sized arrays (number of predicates, etc.)
    - added an option to skip the dump of all grounded predicates "P ..."
    - reworked printing to avoid issues with timepoints which have no true predicates
      (the issues might have been caused by my modifications in the first place...)

*/

#include <iostream>
#include <string>
#include <sstream>
#include <vector>

using namespace std;

#define NUM_PREDICATES 600
#define NUMBER 200
#define ALLOC_CHUNK 100

void insertNode(string atom);
int stringToInteger(string number);
string split(string &str, string delimiter);
void displayList();
int existFluent(string f);
void freshPredicates();

struct ListNode
{
  string atm;
  string sign;
  int timepoint;
  ListNode *next;
  ListNode *previous;
};

ListNode *head=NULL;

vector<string> predicates(NUM_PREDICATES);
int numOfPre=0;
int maxTimepoint=0;
int timeDomainMax=0;
int argOutputBrevityLevel=0;
vector<string> minus2(NUMBER);
int minusIndex2=0;
int count3=0;



int main(int argc, char *argv[])
{
  if (argc > 1)
    argOutputBrevityLevel=atoi(argv[argc-1]);
    // 0 -- no output reduction
    // 1 -- no dump of all grounded predicates at the end
    // 2 -- 1 + only show changes in holdsAt

  string line(""),token("");
  int as=0; // Number of Answer Sets

  while(cin)
  {
    head=NULL; 
    maxTimepoint=0;
    timeDomainMax=0;
    getline(cin,line);
    
    if(line.find("Answer:",0)==0)
    {
      getline(cin,line);
      token=split(line," ");
      
      while(token.compare("")!=0) 
      {
        if(token.compare("Answer")==0 || // For cmodels
                token.compare("set:")==0 ||
                token.compare("Stable")==0 || // For smodels
                token.compare("Model:")==0);
        else                            
          // Make a linked list that contains the answer set.
          insertNode(token); 
      
        token=split(line," ");
      }
      
      cout << endl << "==========\n" << "Answer: " << ++as << endl;
      displayList();
      
      cout << "P" << endl;
      if(argOutputBrevityLevel == 0){
        for(int v=0; v<numOfPre; v++)
          cout << predicates[v] << endl;  // Print out predicates explicitly defined
                                          // on the domain description.
      } else {
        cout << " ... predicate grounding skipped ..." << endl << endl;
      }
      freshPredicates();  
    }
    else if(line.find("Models",0)==0 ||
            line.find("Calls",0)==0 ||
            line.find("Time",0)==0 ||
            line.find("CPU Time",0)==0)
      cout << line << endl;

  } 

  if(!as)
    cout << "\nNo model" << endl << endl << endl;

  return 0;
}

// Add an atom to the linked list that will contain an answer set.
void insertNode(string atom)
{
  ListNode *newNode, *nodePtr, *previousNode;
  int tp; // timepoint
  newNode = new ListNode;
  newNode->atm="";
  newNode->sign="";
  newNode->next=NULL;
  newNode->previous=NULL;

  int indexOfHoldsAt=atom.find("holdsAt",0);
  int indexOfHappens=atom.find("happens",0);
  int indexOfHappens3=atom.find("happens3",0);
  
  int indexOfTime=atom.find("time",0);

  if(indexOfHoldsAt!=0 && indexOfHappens!=0 && indexOfHappens3!=0) // For the case of the predicates that are explicitly defined on the domain description.
  {
    if(indexOfTime == 0) {
      tp=stringToInteger(atom.substr(5,atom.length()-5-1));
      if(tp>timeDomainMax)
        timeDomainMax=tp;
    }

    if(numOfPre >= predicates.size())
      predicates.resize(numOfPre + ALLOC_CHUNK);
    predicates[numOfPre++]=atom;
  }
  else
  {
    int key1=atom.find_last_of(",", atom.length()-1);
    int key2=atom.length()-key1-2;
    string temp=atom.substr(key1+1, key2);

    if(indexOfHoldsAt==0)
      atom=atom.substr(8,key1-8);

    newNode->atm=atom;
    tp=stringToInteger(temp);
    
    if(tp>maxTimepoint)
      maxTimepoint=tp;

    newNode->timepoint=tp;

    if(!head || tp <= head->timepoint)
    {
      if(head)
        head->previous=newNode;

      newNode->next = head;
      head = newNode;
    }
    else
    {
      nodePtr = head;
      
      while(nodePtr != NULL && nodePtr->timepoint < tp)
      {
        previousNode = nodePtr;
        nodePtr = nodePtr->next;
      }

      previousNode->next = newNode;
      newNode->previous = previousNode;
      newNode->next = nodePtr;

      if(nodePtr)
        nodePtr->previous = newNode;
    }
  }
}


// Convert string to integer.
int stringToInteger(string number)
{
  int i;
  stringstream out;
  out.str(number);
  out >> i;
  return i;
}


// Return a string address that contains the address of the substrings 
// that are delimited by a specified string (delimiter).
string split(string &str, string delimiter)
{
  string token("");

  int index=str.find_first_of(delimiter, 0);
  if(index>=0)
  {
    if(index==0)
      return split(str.erase(0,1), delimiter);

    token=str.substr(0,index);
    str.erase(0,index+1);
    return token;
  }
  else
  {token=str; str=""; return token;} // The last element
}

// Show the answer set whose format of the output is more readable to users.
void displayList()
{
  string target("");
  vector<string> current(NUMBER);
  vector<string> next(NUMBER);
  vector<string> minus(NUMBER);
  vector<string> plus(NUMBER);
  vector<string> happens(NUMBER); // Include happens or happens3
  int currentIndex=0, nextIndex=0, 
    minusIndex=0, plusIndex=0, happensIndex=0;
  bool found=false;
  ListNode *nodePtr = head;
  ListNode *nodePtr2;
  int t=nodePtr->timepoint; // The minimum timepoint in the answer set.
  int start=1;

  cout << endl;

  for(int tp=0; tp<=maxTimepoint; tp++)
  {
    while(tp<t)                   // Print out timepoints (from 0)
      {cout << tp << endl; tp++;} // until there exists an atom whose truth            
                                  // value is true at the next timepoint.

    while(nodePtr && nodePtr->timepoint==t)
    {
      if(currentIndex >= current.size())
        current.resize(currentIndex + ALLOC_CHUNK);
      current[currentIndex++]=nodePtr->atm;
      nodePtr=nodePtr->next; 
    }
    
    if(start) // Print out all the atoms whose truth value is true
              // at the minimum timepoint.
    {
      cout << t << endl;
      for(int c=0; c<currentIndex; c++)
	      cout << current[c] << endl;
      start=0;
      tp++;
      t++;
    }

    if(tp<=maxTimepoint)
    {
      nodePtr2=nodePtr;

      if(tp==nodePtr->timepoint)
      {
        t=nodePtr->timepoint;
        while(nodePtr && nodePtr->timepoint==t)
        {
          if(nextIndex >= next.size())
          next.resize(nextIndex + ALLOC_CHUNK);
          next[nextIndex++]=nodePtr->atm;
          nodePtr=nodePtr->next; 
        }
      }

      // Add minus to atoms to be false at the next timepoint.
      for(int i=0; i<currentIndex; i++)
      {
        target=current[i];
        if(target.find("happens",0)==0)
          continue;

        if(tp==t)
        {
          for(int j=0; j<nextIndex; j++)
          {
            if(target.compare(next[j])==0)
              {found=true; break;}
          }
        }

        if(!found)
        {
          target="-"+target;
          if(minusIndex >= minus.size())
            minus.resize(minusIndex + ALLOC_CHUNK);
          minus[minusIndex++]=target;
        }

        found=false;
      }

      
      if(tp==t)
      {
        // Add plus to atoms to be true at the next timepoint.
        for(int m=0; m<nextIndex; m++)
        {
          target=next[m];
          if(target.find("happens",0)==0)
            continue;

          for(int n=0; n<currentIndex; n++)
          {
            if(target.compare(current[n])==0)
              {found=true; break;}
          }

          if(!found)
          {
            target="+"+target;
            if(plusIndex >= plus.size())
              plus.resize(plusIndex + ALLOC_CHUNK);
            plus[plusIndex++]=target;
          } 

          found=false;
        }
      }

      cout << endl << tp << endl;   // #1. Print out Timepoint.
      
      for(int a=0; a<minusIndex; a++)
      {
        cout << minus[a] << endl;  // #2. Print out fluents that are made false. 
        minus[a]="";               
      }

      for(int b=0; b<plusIndex; b++)   
      {
        cout << plus[b] << endl;   // #3. Print out fluents that are made true.
        
        if(tp==maxTimepoint-1)
        {
          string target=plus[b].substr(1);
          if(!existFluent(target))
          {
            if(minusIndex2 >= minus2.size())
              minus2.resize(minusIndex2 + ALLOC_CHUNK);
            minus2[minusIndex2++]=target;	
          }
        }
      }
   
      for(int d=0; d<nextIndex; d++)
      {
        for(int e=0; e<plusIndex; e++)
          if(next[d].compare(plus[e].substr(1))==0)
            {found=true; break;}

        if(!found)
          if(next[d].find("happens",0)==0)
          {
            if(happensIndex >= happens.size())
              happens.resize(happensIndex + ALLOC_CHUNK);
            happens[happensIndex++]=next[d];
          }
          else
          {  
            if(argOutputBrevityLevel < 2)
              cout << next[d] << endl; // #4.Print out fluents whose truth value has not
                                      // changed with respect to the previous timepoint.
            if(tp==maxTimepoint-1)
              if(!existFluent(next[d]))
              {
                if(minusIndex2 >= minus2.size())
                  minus2.resize(minusIndex2 + ALLOC_CHUNK);
                minus2[minusIndex2++]=next[d];
              }
          }
        next[d]="";
        found=false;
      }

      for(int z=0; z<happensIndex; z++)
      {
        cout << happens[z] << endl;  // #5. Print out events that occur at the current
        happens[z]="";               //     timepoint.
      }
    }

    for(int s=0; s<currentIndex; s++)
      current[s]="";
    
    for(int w=0; w<plusIndex; w++)
      plus[w]="";

    minusIndex=0; plusIndex=0;
    currentIndex=0; nextIndex=0; happensIndex=0;
    nodePtr=nodePtr2;
  }

  if(maxTimepoint!=timeDomainMax)
  {
    cout << endl << maxTimepoint+1 << endl;
    for(int k=0; k<minusIndex2; k++)
    {
      cout << "-" << minus2[k] << endl;
      minus2[k]="";
    }
    minusIndex2=0;
    for(int tp=maxTimepoint+2; tp<=timeDomainMax; tp++)
    {
      cout << tp << endl;
    }
  }
}

int existFluent(string f)
{
  for(int i=0; i<minusIndex2; i++)
    if(minus2[i].compare(f)==0)
      return 1;

  return 0;
}

void freshPredicates()
{
  for(int p=0; p<numOfPre; p++)
    predicates[p]="";
  numOfPre=0;
}

// End of File
