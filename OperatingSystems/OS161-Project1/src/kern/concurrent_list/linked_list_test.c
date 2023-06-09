#include <linked_list.h>
#include <lib.h>
#include <thread.h>
#include <spl.h>
#include <test.h>
#include <synch.h>

static struct semaphore * bathroom_door = NULL;

static void linked_list_test_postpend(void *list, unsigned long which)
{
  int * a;
  for(int i = 0; i < 5; i++){
    a = kmalloc(sizeof(int));
    *a = 'a' + i;
    linked_list_postpend(list,a);
    linked_list_printlist(list,which);
  }
  V(bathroom_door);
}

static void linked_list_test_remove_head(void *list,unsigned long which)
{
  int * a;
  int num_entries = 5;
  for(int i = 0; i < num_entries; i++){
    a = kmalloc(sizeof(int));
    *a = 'a' + i;
    linked_list_prepend(list, a);
  }
  for(int i = 0; i < num_entries-1; i++){
    a = kmalloc(sizeof(int));
    *a = 0;
    linked_list_remove_head(list,a);
    linked_list_printlist(list,which);
  }
  //Removing the last entry, and a nonexistant entry.
  //Cannot print empty list, test passes if no error is thrown.
  linked_list_remove_head(list,a);
  linked_list_printlist(list,which);
  linked_list_remove_head(list,a);
  linked_list_printlist(list,which);

  V(bathroom_door);
}

static void linked_list_test_insert(void *list,unsigned long which)
{
  int * a = kmalloc(sizeof(int));
  int * b = kmalloc(sizeof(int));
  int * c = kmalloc(sizeof(int));
  int * d = kmalloc(sizeof(int));
  int * e = kmalloc(sizeof(int));
  *a = 'a';
  *b = 'b';
  *c = 'c';
  *d = 'd';
  *e = 'e';
  // Final order should be b,a,e,c
  // We don't d because it has the same key as a.
  linked_list_insert(list, 2, a);
  linked_list_printlist(list,which);
  linked_list_insert(list, 1, b);
  linked_list_printlist(list,which);
  linked_list_insert(list, 4, c);
  linked_list_printlist(list,which);
  linked_list_insert(list, 2, d);
  linked_list_printlist(list,which);
  linked_list_insert(list, 3, e);
  linked_list_printlist(list,which);

  V(bathroom_door);
}

static void linked_list_test_adder(void *list, unsigned long which)
{
  int i;
  int *c;

  for (i = 0; i < 10; i++) {
    c = kmalloc(sizeof(int));
    *c = 'A' + i;
    linked_list_prepend(list, c);
    linked_list_printlist(list, which);
  }

  V(bathroom_door);
}

static void interleave_test_1(void *list, unsigned long which){
  int * a;
  for(int i = 0; i < 5; i++){
    a = kmalloc(sizeof(int));
    *a = 'a'+i;
    linked_list_prepend(list,a);
  }
  linked_list_printlist(list,which);

  a = kmalloc(sizeof(int));
  *a = 0;
  for(int i = 0; i < 5; i++){
    linked_list_remove_head(list,a);
    linked_list_printlist(list,which);
  }  

  V(bathroom_door);
}

static void interleave_test_2(void *list, unsigned long which){
  //Legnth of list => indexing of characters each thread adds
  int alphabet_length = 4;
  //Thread 0 adds first alphabet_length chars, thread 1 adds...
  int fork_constant = alphabet_length*(int)which;

  int * a;
  for(int i = 0; i < alphabet_length; i++){
    a = kmalloc(sizeof(int));
    *a = 'a'+i+fork_constant;
    linked_list_prepend(list,a);
    linked_list_printlist(list,which);
  }

  V(bathroom_door);
}

static void interleave_test_3a(void * list, unsigned long which){
  (void)which;
  int * a = kmalloc(sizeof(int));
  *a = 'a';
  linked_list_prepend(list,a);
  V(bathroom_door);
}
static void interleave_test_3b(void * list, unsigned long which){
  linked_list_printlist(list,which);
  V(bathroom_door);
}


int linked_list_test_run(int nargs, char **args)
{
  bathroom_door = sem_create("TestSem",0);

  Linked_List * list0 = linked_list_create();
  Linked_List * list1 = linked_list_create();
  Linked_List * list2 = linked_list_create();
  Linked_List * list3 = linked_list_create();
  Linked_List * list4 = linked_list_create();

  int testnum = 0;
  if(nargs == 2){
    testnum = atoi(args[1]);
    if(0 <= testnum && testnum <= 4){
      LINKED_LIST_TEST_NUM = testnum;
    }else{
      LINKED_LIST_TEST_NUM = 0;
      testnum = 0;
    }
  }  
  kprintf("testnum: %d\n", testnum);

  switch(testnum){
    case 1:
      thread_fork("Interleaving1",
            NULL,
            interleave_test_1,
            list0,
            1);
      thread_fork("Interleaving1",
            NULL,
            interleave_test_1,
            list1,
            2);
      P(bathroom_door);
      P(bathroom_door);
      break;
    case 2:
      thread_fork("Interleaving2",
            NULL,
            interleave_test_2,
            list0,
            0);
      thread_fork("Interleaving2",
            NULL,
            interleave_test_2,
            list0,
            1);
      P(bathroom_door);
      P(bathroom_door);
      break;
    case 3:
      thread_fork("Interleaving3a",
            NULL,
            interleave_test_3a,
            list0,
            3);
      thread_fork("Interleaving3b",
            NULL,
            interleave_test_3b,
            list0,
            3);
      P(bathroom_door);
      P(bathroom_door);
      break;
    case 4:
      kprintf("Couldn't find a fourth distinct problem.");
      break;
    default:
      thread_fork("adder 1",
            NULL,
            linked_list_test_adder,
            list0,
            1);
      thread_fork("adder 2",
            NULL,
            linked_list_test_adder,
            list1,
            2);
      thread_fork("insert 1",
            NULL,
            linked_list_test_insert,
            list2,
            3);
      thread_fork("remove head 1",
            NULL,
            linked_list_test_remove_head,
            list3,
            4);
      thread_fork("postpend",
            NULL,
            linked_list_test_postpend,
            list4,
            5);
      P(bathroom_door);
      P(bathroom_door);
      P(bathroom_door);
      P(bathroom_door);
      P(bathroom_door);
  }

  
  
  // XXX - Bug - We're returning from this function without waiting
  // for these two threads to finish.  The execution of these
  // threads may interleave with the kernel's main menu thread and
  // cause interleaving of console output.  We going to accept this
  // problem for the moment until we learn how to fix in Project 2.
  // An enterprising student might investigate why this is not a
  // problem with other tests suites the kernel uses.
  return 0;
}
