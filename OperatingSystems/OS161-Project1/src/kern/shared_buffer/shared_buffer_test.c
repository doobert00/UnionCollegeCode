#include <types.h>
#include <lib.h>
#include <test.h>
#include <thread.h>
#include <shared_buffer.h>

static struct semaphore * bathroom_door = NULL;

static void sb_test_create1(void * s, unsigned long which)
{   
    (void)s;
    Shared_Buffer * sb;
    bool state = true;
    for(int i = 1; i < 6; i++){
        sb = shared_buffer_create(i);
        if(sb->buff_list  ==NULL||
            sb->buff_lock ==NULL||
            sb->prod_cv   ==NULL||
            sb->con_cv    ==NULL||
            sb->counter   !=0||
            sb->MAX_BUFFER_LENGTH!=i){
            state = false;
        }
    } 
    if(state){
        kprintf("%lu: Success!\n",which);
    }else{
        kprintf("%lu: Failure:(\n",which);
    }
    V(bathroom_door);
}
static void sb_test_create2(void * s, unsigned long which)
{
    //This test is commented out because it interferes with our other tests.
    //We demonstrate that we cannot initialize a semaphore to a value <= 0.
    (void)s;
    (void)which;
    //kprintf("%lu: This test panics on success.\n",which);
    //Shared_Buffer * sb = shared_buffer_create(0);
    //Shared_Buffer * sb = shared_buffer_create(-1);
    V(bathroom_door);
}
static void sb_test_order(void * s, unsigned long which)
{
    (void)s;
    int len = 5;
    Shared_Buffer * sb = shared_buffer_create(len);
    char * a;
    for(int i = 0; i < len; i++){
        a = kmalloc(sizeof(char));
        *a = 'a'+i;
        produce(sb,a);
    }
    kprintf("%lu: We expect a,b,c,...\n",which);
    for(int i = 0; i < len; i++){
        kprintf("%lu: %c\n",which,*(char*)consume(sb));
    }
    V(bathroom_door);
}

static void consumers(void * sb, unsigned long which)
{   
    int len = (int)which;
    int * a;
    for(int i = 0; i < len; i++)
    {
        a = kmalloc(sizeof(int));
        *a = 'a'+i;
        produce(sb,a);
    }
    V(bathroom_door);
}
static void producers(void * sb, unsigned long which)
{
    int len = (int)which;
    for(int i = 0; i < len; i++)
    {
        consume(sb);
    }
    V(bathroom_door);
}

static void sb_test_buffer_full(void * s, unsigned long which)
{
    (void)s;
    (void)which;
    //Shared_Buffer * sb = shared_buffer_create(3);
    //thread_fork("produce1",NULL,produce,sb,1);
    //thread_fork("produce2",NULL,produce,sb,2);
    //thread_fork("produce3",NULL,produce,sb,3);
    //thread_fork("produce4",NULL,produce,sb,4);
    //consume(sb);
    V(bathroom_door);
}

int sbtest_run(int nargs, char **args){
    bathroom_door = sem_create("TestSem",0);

    thread_fork("Create1",
            NULL,
            sb_test_create1,
            NULL,
            1);
    thread_fork("Create2",
            NULL,
            sb_test_create2,
            NULL,
            2);
    thread_fork("Order",
            NULL,
            sb_test_order,
            NULL,
            3);
    thread_fork("Buffer Full",
            NULL,
            sb_test_buffer_full,
            NULL,
            4);
    int len = 5;
    Shared_Buffer * buff = shared_buffer_create(len);
    thread_fork("Producer",
            NULL,
            producers,
            buff,
            len);
    thread_fork("Consume",
            NULL,
            consumers,
            buff,
            len);
    if(buff->counter == 0){
        kprintf("5: Success!\n");
    }else{
        kprintf("5: Failure :(\n");
    }
    P(bathroom_door);
    P(bathroom_door);
    P(bathroom_door);
    P(bathroom_door);
    P(bathroom_door);
    (void)nargs;
    (void)args;
    return 0;
}