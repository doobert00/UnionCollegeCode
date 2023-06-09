#include <linked_list.h>
#include <lib.h>
#include <thread.h>

int LINKED_LIST_TEST_NUM = 0;

Linked_List *linked_list_create(void)
{
  //No race conditions here!
  Linked_List * ptr = kmalloc(sizeof(Linked_List));
  ptr -> length = 0;
  ptr -> first = NULL;
  ptr -> last = NULL;
  if(LINKED_LIST_TEST_NUM==4){
    thread_yield();
  }
  ptr -> list_lock = lock_create("list_lock");
  return ptr;
}

Linked_List_Node *linked_list_create_node(int key, void *data)
{
  KASSERT(data != NULL);
  if(LINKED_LIST_TEST_NUM==3){
    thread_yield();
  }
  //No race conditions here!
  Linked_List_Node *newnode = kmalloc(sizeof(Linked_List_Node));
  newnode -> prev = NULL;
  newnode -> next = NULL;
  newnode -> key = key;
  newnode -> data = data;
  return newnode;
}

void linked_list_prepend(Linked_List *list, void *data)
{
  KASSERT(list != NULL);
  KASSERT(data != NULL);

  lock_acquire(list->list_lock);

  if(LINKED_LIST_TEST_NUM==2){
    thread_yield();
  }
  Linked_List_Node * newnode;
  Linked_List_Node * f = list -> first;

  if (list -> first == NULL) {
    newnode = linked_list_create_node(0, data);
    list -> first = newnode;
    list -> last = newnode;
  } else {
    newnode = linked_list_create_node(f -> key - 1, data);

    newnode -> next = list -> first;
    f -> prev = newnode;
    list -> first = newnode;
  }

  list -> length ++;
  lock_release(list->list_lock);
}

void linked_list_printlist(Linked_List *list, int which)
{
  KASSERT(list != NULL);

  lock_acquire(list->list_lock);

  Linked_List_Node *runner = list -> first;

  kprintf("%d: ", which);

  while (runner != NULL) {
    kprintf("%d[%c] ", runner -> key, *((int *)runner -> data));
    runner = runner -> next;
  }
  kprintf("\n");
  if(LINKED_LIST_TEST_NUM == 1){
    thread_yield();
  }

  lock_release(list->list_lock);
}

void linked_list_insert(Linked_List *list, int key, void *data)
{
    KASSERT(list != NULL);
    KASSERT(data != NULL);

    lock_acquire(list->list_lock);

    Linked_List_Node * newnode;
    Linked_List_Node * runner = list -> first;
    if (runner==NULL){
      newnode = linked_list_create_node(key, data);
      list -> first = newnode;
      list -> last = newnode;
      list -> length += 1;
    }else if(key < runner -> key){
      newnode = linked_list_create_node(key, data);
      newnode -> next = runner;
      runner -> prev = newnode;
      list -> first = newnode;
      list -> length += 1;
    }
    else{
        while(runner->next != NULL && key > runner->next->key){
          runner = runner -> next;
        }
        if(runner->next == NULL){
          newnode = linked_list_create_node(key, data);
          newnode -> prev = runner;
          runner -> next = newnode;
          list -> last = newnode;
          list -> length += 1;
        }else if(runner->next->key != key){
            newnode = linked_list_create_node(key, data);
            newnode->next = runner->next;
            newnode->prev = runner;
            runner->next = newnode;
            newnode->next->prev = newnode;
            list -> length += 1;
        }
    }

    lock_release(list->list_lock);
}

void* linked_list_remove_head(Linked_List * list, int * key)
{
    KASSERT(list != NULL);
    KASSERT(key != NULL);

    lock_acquire(list->list_lock);

    void * data;
    if(list -> length == 0){
      data = NULL;
    }else if(list -> length == 1){
      *key = list->first->key;
      data = list->first->data;
      list->first = NULL;
      list->last = NULL;
      list->length = 0;
    }else{
      *key = list->first->key;
      data = list->first->data;
      list->first = list->first->next;
      kfree(list->first->prev);
      list->first->prev = NULL;
      list->length -= 1;
    }

    lock_release(list->list_lock);
    return data;
}

void linked_list_destroy(Linked_List * list)
{
  KASSERT(list != NULL);

  lock_acquire(list->list_lock);
  Linked_List_Node * runner = list->first;
  while(runner != NULL)
  {
    runner = list->first->next;
    kfree(list->first);
    list->first = runner;
  }
  lock_release(list->list_lock);
  lock_destroy(list->list_lock);
  kfree(list);
}

void linked_list_postpend(Linked_List *list, void *data)
{
  KASSERT(list!=NULL);
  KASSERT(data!=NULL);
  
  lock_acquire(list->list_lock);

  Linked_List_Node * runner = list->first;

  if(runner == NULL)
  {
    list->first = linked_list_create_node(0,data);   
    list->last = list->first;
  }else{
    while(runner->next != NULL)
    {
      runner = runner->next;
    }
    Linked_List_Node * newnode = linked_list_create_node(runner->key+1,data);
    runner->next = newnode;
    list->last = newnode;
  }
  list->length++;
  lock_release(list->list_lock);
}
