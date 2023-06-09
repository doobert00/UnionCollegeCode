#ifndef _SHARED_BUFFER_H_
#define _SHARED_BUFFER_H_

#include <types.h>
#include <synch.h>
#include <linked_list.h>

typedef struct Shared_Buffer Shared_Buffer;

struct Shared_Buffer {
    struct Linked_List *buff_list;
    struct lock *buff_lock;
    struct cv *prod_cv;
    struct cv *con_cv;
    int counter;
    int MAX_BUFFER_LENGTH;
};

/*
* Creates a buffer of size buff_len.
*/
Shared_Buffer * shared_buffer_create(int buff_len);

/*
* Adds a single character to the buffer.
*/
void produce(Shared_Buffer *sb,void *data);

/*
* Removes a single character from the buffer.
*/
void * consume(Shared_Buffer *sb);

/*
* Destroys the buffer.
*/
void shared_buffer_destroy(Shared_Buffer *sb);

#endif

