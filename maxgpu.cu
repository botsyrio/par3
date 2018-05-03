#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <cuda.h>

#define maxThreads 512
/*
This code was developed and tested on cuda3

*/


__global__ void getmaxcu(unsigned int num[], unsigned int size){		
	
	unsigned int tid = threadIdx.x;
	unsigned int gloid = blockIdx.x*blockDim.x+threadIdx.x;	
	
	__shared__ int sdata[maxThreads]; // shared data
	
	sdata[tid]=num[gloid];
	if(gloid>=size){
		sdata[threadIdx.x]=0;
	}
	
	/*if(n<size){
		int tSize = size/n;
		if(tid<(size%n)
			tSize++;
		for(int i; i<tSize; i++)
			if(sdata[tid]<num[glo
	}
	*/
	__syncthreads();
	
	//get a block max by performing a tree-structured 
	//reduction akin to that depicted in slide 18 of 
	//the lecture 8 pp
	
	for (int stride = blockDim.x / 2; stride > 0; stride = stride / 2) {
        if (tid < stride) {
            if (sdata[tid] < sdata[tid + stride]) {
                sdata[tid] = sdata[tid + stride];
            }
        }
        __syncthreads();
	}
	
	if(tid==0){//store the block maxes in global memory
		num[blockIdx.x]=sdata[0];
	}
}

int main(int argc, char *argv[])
{
	cudaDeviceProp prop;
	cudaError_t propErr = cudaGetDeviceProperties(&prop, 0);
	
	
	if (propErr != cudaSuccess) {
		printf("unable to get device properties\n");
	}
	
	
    unsigned int size = 0;  // The size of the array
    unsigned int i;  // loop index
    unsigned int * numbers; //pointer to the array
	unsigned int* cudaNumbers;
	unsigned int thread;
	unsigned int block;
    
    if(argc !=2)
    {
       printf("usage: maxseq num\n");
       printf("num = size of the array\n");
       exit(1);
    }
   
    size = atol(argv[1]);
    numbers = (unsigned int *)malloc(size * sizeof(unsigned int));
    if( !numbers )
    {
       printf("Unable to allocate mem for an array of size %u\n", size);
       exit(1);
    }

	if (size%maxThreads != 0) {
        size = (size/maxThreads+1)*maxThreads;
    } 

    srand(time(NULL)); // setting a seed for the random number generator
    // Fill-up the array with random numbers from 0 to size-1 
    for( i = 0; i < size; i++)
       numbers[i] = rand()  % size;    
	   
	//for(int i = 0; i < size; i++) {
	//	printf("%d ", numbers[i]);
    //}
    //printf("\n"); 
	
	cudaMalloc((void**)&cudaNumbers, (size * sizeof(unsigned int)));
	cudaMemcpy(cudaNumbers, numbers, (size * sizeof(unsigned int)), cudaMemcpyHostToDevice);
	
	unsigned int cudaSize=size;
	thread = maxThreads;
	block = size/thread;
	
	//getmaxcu<<<block, thread>>>(cudaNumbers, cudaSize);
	while(block>1){
		getmaxcu<<<block, thread>>>(cudaNumbers, cudaSize);
		cudaSize=cudaSize/thread;
		thread = block;
		block = cudaSize/thread;
	}
	getmaxcu<<<1, block>>>(cudaNumbers, block);
	
	cudaMemcpy(numbers, cudaNumbers, sizeof(unsigned int), cudaMemcpyDeviceToHost);//only copies back the max, which should be in the first element of the array
	printf(" The maximum number in the array is: %u\n", numbers[0]);

    free(numbers);
	cudaFree(cudaNumbers);
    exit(0);
}


/*
   input: pointer to an array of long int
          number of elements in the array
   output: the maximum number of the array
*/