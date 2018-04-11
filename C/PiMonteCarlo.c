/**
 * Thomson Kneeland
 * OS 345
 *
 * PiMonteCarlo.c
 * Program that calculates the value of pi by using a MonteCarlo estimation of random
 * darts striking within a circular target.  User can change number of threads easily based
 * thread availability
 */

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* create global variables*/
#define NUMBER_OF_THREADS 2 
#define NUMBER_OF_DARTS 50000000

int circle_count=0; /* variable for total number of hits within circle */

pthread_mutex_t mutex; /* global mutex */

/* random function*/
double random_double(){
	return random()/((double)RAND_MAX+1);
}

void *worker(void *param){
	int number_of_darts;
	number_of_darts=*((int*)param); //get parameter for number of iterations
	printf("number of darts in thread: %d\n",number_of_darts);
	double x,y; // random numbers
	int hit_count=0; // variable to monitor number of target hits in thread
	int i; // iterator variable
	/*iterative randomization creates x and values btw -1 and 1 */
	for(i=0;i<number_of_darts;i++){ /* number_of_darts  */
		x=random_double()*2.0-1.0; /* random x value */
		y=random_double()*2.0-1.0; /* random y value */
		if (sqrt(x*x+y*y)<=1.0){/* if radius less than 1.0, dart within circle */
			hit_count++;
		}
	}
	/* add mutex lock */
	pthread_mutex_lock(&mutex);	
	circle_count+=hit_count;
	printf("total hits for this thread: %d\n",hit_count);
	printf("\n");
	/*add mutex lock close */
	pthread_mutex_unlock(&mutex);
	pthread_exit(0);
}

int main(int argc, char *argv[]){
	pthread_mutex_init(&mutex,NULL); // initialize mutex
	pthread_t tid[NUMBER_OF_THREADS]; //the thread identifier
	pthread_attr_t attr; //set of attributes for the thread
	pthread_attr_init(&attr);
	int darts_per_thread=NUMBER_OF_DARTS/NUMBER_OF_THREADS; // number of darts per thread
	int i,j; // iterators
	double pi; // final result
	
	printf("\n");
	for (i=0;i<NUMBER_OF_THREADS;i++){//create threads and run worker function
		pthread_create(&tid[i],&attr,worker,&darts_per_thread); 
	}
	for (j=0;j<NUMBER_OF_THREADS;j++){ //join threads after worker function
		pthread_join(tid[j],NULL);
	}
	/* deallocate */
	pthread_mutex_destroy(&mutex);
	/*free(threads); /* only if we need array*/

	/* calculate pi from data */
	pi=4.0*circle_count/NUMBER_OF_DARTS;
	// console output
	printf("Throwing %d darts, %d hit within the circle\n",NUMBER_OF_DARTS,circle_count);
	printf("The resulting Monte Carlo estimation of pi is: %.6f\n",pi);

	return 0;
}

