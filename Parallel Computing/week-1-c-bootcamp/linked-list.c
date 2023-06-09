//linked-list.c
//author: John Rieffel
#include <stdio.h>
#include <stdlib.h>
// ------ a node has              \
// | ---|--->a pointer-to-node field 
// ------   a data field             
// | 17 | and it has the type-name: Node   
//------
typedef struct node {
    struct node *next;
    int data;           
    } Node;


Node * insert(int N, Node *listptr)
{
    //allocate space for new Node
   struct node *tmpptr = (struct node *) malloc(sizeof(Node));
   //set fields
   tmpptr->data = N; 
   tmpptr->next = NULL;

   if (listptr == NULL || N < listptr->data) //list is empty or N is smallest elem
   {
      tmpptr->next = listptr; //tmpptr points to the rest of the list
      listptr = tmpptr; //the list starts at tmpptr
   }
   else 
   {
      struct node *curptr = listptr; //iterator so we keep head of list
      while (curptr->next != NULL && curptr->next->data <= N)
      {
          curptr = curptr->next; //move curptr along the list
      }//we've hit the end (node points to null) or we have found the proper insert position
      tmpptr->next = curptr->next; //our new node points to the next node
      curptr->next = tmpptr; //our current node points to our new node
   }
   return listptr; //return the head of the list
}

Node * insertRecursive(int N, Node *listptr)
  {
 	if(listptr == NULL || N < listptr->data)
 	{
 		struct node *tmpptr = (struct node *) malloc(sizeof(Node));
 		tmpptr->data = N;
 		tmpptr->next = NULL;
 	}else{
 		listptr->next = insertRecursive(N, listptr->next);
 		
 	}
 	return listptr;
  }

void PrintList(Node *listptr){
    if (listptr == NULL){
    	printf("NULL\n");
    }else{
    	printf("%d -> ",listptr->data);
    	PrintList(listptr->next);
    }
 return;
}

int main()
{

    struct node *list = NULL;
    list = insert(10,list);
    list = insert(5,list);
    list = insert(7,list);
    list = insert(33,list);
    list = insert(-10,list);
    list = insert(12,list);
    list = insert(-3993,list);
    list = insert(7,list);
    list = insert(5,list);
    list = insert(100238,list);
    list = insert(1,list);
    PrintList(list);
    
}
