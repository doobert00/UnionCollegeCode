#include <shared_buffer.h>
#include <linked_list.h>
#include <lib.h>
#include <thread.h>
#include <synch.h>

Shared_Buffer * shared_buffer_create(int buff_len)
{
    KASSERT(buff_len > 0);

    Shared_Buffer * ptr = kmalloc(sizeof(Shared_Buffer));
    ptr->buff_list = linked_list_create();
    ptr->buff_lock = lock_create("buff_lock");
    ptr->prod_cv = cv_create("buff_prod_cv");
    ptr->con_cv = cv_create("buff_con_cv");
    ptr->counter = 0;
    ptr->MAX_BUFFER_LENGTH = buff_len;

    return ptr;
}

void produce(Shared_Buffer *sb, void *data)
{
    KASSERT(sb!=NULL);
    KASSERT(data!=NULL);

    lock_acquire(sb->buff_lock);
    while(sb->counter == sb->MAX_BUFFER_LENGTH)
    {
        cv_wait(sb->prod_cv,sb->buff_lock);
    }
    linked_list_postpend(sb->buff_list,data);
    sb->counter++;
    cv_signal(sb->con_cv,sb->buff_lock);
    lock_release(sb->buff_lock);
}

void * consume(Shared_Buffer *sb)
{
    KASSERT(sb!=NULL);
    
    lock_acquire(sb->buff_lock);
    while(sb->counter == 0)
    {
        cv_wait(sb->con_cv,sb->buff_lock);
    }
    int * a = kmalloc(sizeof(int));
    void * out = linked_list_remove_head(sb->buff_list,a);
    sb->counter--;
    cv_signal(sb->prod_cv,sb->buff_lock);
    lock_release(sb->buff_lock);
    return out;
}

void shared_buffer_destroy(Shared_Buffer *sb)
{
    KASSERT(sb!=NULL);
    KASSERT(lock_do_i_hold(sb->buff_lock));
    lock_destroy(sb->buff_lock);
    linked_list_destroy(sb->buff_list);
    kfree(sb);
}
