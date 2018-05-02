#include <stdlib.h>
#include <time.h>
#include <cuda.h>

/*
This code was developed and tested on cuda1

Device 0:
name: GeForce GTX TITAN Black
Compute capability 3.5
total global memory(KB): 6228288
shared mem per block: 49152
regs per block: 65536
warp size: 32
max threads per block: 1024
max thread dim z:1024 y:1024 x:64
max grid size z:2147483647 y:65535 x:65535
clock rate(KHz):
total constant memory (bytes): 65536
multiprocessor count 15
integrated: 0
async engine count: 1
memory bus width: 384
memory clock rate (KHz): 3500000
L2 cache size (bytes): 1572864
max threads per SM: 2048

*/


unsigned int getmax(unsigned int *, unsigned int);

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
	unsigned int block;
	unsigned int thread;
	
	block = 30;
	thread = 1024;
    
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

	

    srand(time(NULL)); // setting a seed for the random number generator
    // Fill-up the array with random numbers from 0 to size-1 
    for( i = 0; i < size; i++)
       numbers[i] = rand()  % size;    
	   
	for(int i = 0; i < size; i++) {
		printf("%d ", numbers[i]);
    }
    printf("\n"); 
	 
	cudaMalloc(cudaNumbers, (size * sizeof(unsigned int)));
	cudaMemcpy(cudaNumbers, numbers, (size * sizeof(unsigned int)), cudaMemcpyHostToDevice);
	
	cudaMalloc((unsigned int)cudaSize, sizeof(unsigned int));
	cudaMemcpy(cudaSize, size, (sizeof(unsigned int)), cudaMemcpyHostToDevice);
	
	
	unsigned int n = block*thread;
	cudaMalloc((unsigned int)cudaN, sizeof(unsigned int));
		
	
	getmaxcu<<<block, thread>>>(cudaNumbers, cudaSize, cudaN));
	//cudaSize/thread;
   
    
	getmaxcu<<<1, block>>>(cudaNumbers, block, block);
	printf("%s\n", cudaMemcpy(numbers, devArray, sizeof(unsigned int), cudaMemcpyDeviceToHost));

	printf(" The maximum number in the array is: %u\n", numbers[0]);

    free(numbers);
	cudaFree(cudaNumbers);
	cudaFree(cudaSize);
	cudaFree(cudaN);
    exit(0);
}


/*
   input: pointer to an array of long int
          number of elements in the array
   output: the maximum number of the array
*/
__global__ unsigned void getmaxcu(unsigned int num[], unsigned int size, int n){
	/*if(id<size%n)
		starting = (threadId.x+blockId.x*blockDim.x)(size/n+1);
	else
		starting = (size%n)(size/n+1)+((threadId.x+blockId.x*blockDim.x)-size%n)(size/n);*/
		
	
	unsigned int tid = threadId.x;
	unsigned int gloid = blockId.x*blockDim.x+threadId.x;	
	unsigned int tSize = size/n;
	__shared__ int sdata[blockDim.x]; // shared data
	
	if(tid<size%n)
		tSize++;
	__syncthreads();	
	
	//each thread iterates over its section of the large array
	sdata[tid]=num[gloid];
	for(unsigned int i = 0; i < tSize; i++)
		if(num[gloid] > sdata[tid])
			sdata[tid]=num[gloid];
			
	__syncthreads();
	
	//get a block max by performing a tree-structured 
	//reduction akin to that depicted in slide 17 of 
	//the lecture 8 pp
	
	for(unsigned int stride = 1; stride<blockDim.x; stride*=2){
		if(tid%(2*stride)==0){
			if(sdata[tid]<sdata[tid+s])
				sdata[tid]=sdata[tid+s];
		}
		__syncthreads();
	}
	
	if(tid==0){
		num[blockId.x]=sData[0];
	}

	//return(num[0]);

}