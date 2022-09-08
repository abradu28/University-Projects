#include "lockers.h"
#include <string.h>
#include <stdlib.h>
//functie pentru mutex pentru a-i da lock
void acquire(mymutex *mutex)
{
    if(mutex->available==0)
    mutex->available=1;
    else
 

    while(mutex->available==1);


  
}
//dam release la mutex astfel incat sa intre alt proces
void release(mymutex *mutex)
{
    mutex->available = 0;
}
//initializam mutexul cu 0 astfel incat sa putem asa il blocam
void initialize(mymutex *mutex)
{
    mutex->available = 0;
}


//functia wait scade valoarea cu o unitate si poate fi execututata 
// cu siguranta in  medii de lucru  paralele
int wait(mysemaphore *s)
{
    acquire(&s->mut);
    while (atomic_load(&s->val) <= 0)
        ;
    atomic_fetch_sub(&s->val, 1);
    release(&s->mut);
    return 0;
}

//initializare semaforul cu 1 astfel incat sa fie blocat astfel incat sa se poate executa critical sectionul

int signal(mysemaphore *s)
{
    return atomic_fetch_add(&s->val, 1);
}

//initializare semafor
void initialize_sem(mysemaphore *s, int val)
{
    atomic_init(&s->val, val);
}

//in implementarea rwlock am folosit doua semafoare si un contor care retine numarul de readers blocati
void initialize_RWlock(myRW_lock *rw_lock)
{

    initialize_sem(&rw_lock->x, 1);
    initialize_sem(&rw_lock->y, 1);
    rw_lock->readers_count = 0;
}

//incepe citirea

void reader_lock(myRW_lock *rw_lock)
{
    wait(&rw_lock->x);
    rw_lock->readers_count++;

    if (rw_lock->readers_count == 1)
        wait(&rw_lock->y);

    signal(&rw_lock->x);
}

//se teermina citirea

void reader_unlock(myRW_lock *rw_lock)
{
    wait(&rw_lock->x);
    
    rw_lock->readers_count--;
    if (rw_lock->readers_count == 0)
        signal(&rw_lock->y);
    signal(&rw_lock->x);
}

//incepem scrierea
void writer_lock(myRW_lock *rw_lock)
{
    wait(&rw_lock->y);
}

//terminam scrierea
void writer_unlock(myRW_lock *rw_lock)
{
    signal(&rw_lock->y);
}