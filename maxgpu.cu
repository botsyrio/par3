#include <stdlib.h>
#include <time.h>
#include <cuda.h>



unsigned int getmax(unsigned int *, unsigned int);

int main(int argc, char *argv[])
{
cudaDeviceProp prop;
cudaError_t error = cudaGetDeviceProperties(&prop, 0);
	printf("char name[256]; = %s\n size_t totalGlobalMem; = %d\n size_t sharedMemPerBlock; = %d\n int regsPerBlock; = %d\n int warpSize; = %d\n size_t memPitch; = %d\n int maxThreadsPerBlock; = %d\n int maxThreadsDim[3]; = %d\n int maxGridSize[3]; = %d\n int clockRate; = %d\n size_t totalConstMem; = %d\n   int major; = %d\n int minor; = %d\n size_t textureAlignment; = %d\n size_t texturePitchAlignment; = %d\n int deviceOverlap; = %d\n int multiProcessorCount; = %d\n int kernelExecTimeoutEnabled; = %d\n int integrated; = %d\n int canMapHostMemory; = %d\n int computeMode; = %d\n", prop->name,prop->totalGlobalMem, prop->sharedMemPerBlock, prop->regsPerBlock, prop->warpSize,            prop->memPitch, prop->maxThreadsPerBlock,  prop->maxThreadsDim[3], prop->maxGridSize[3],             prop->clockRate, prop->totalConstMem,prop->major,   prop->minor, prop->textureAlignment,   prop->texturePitchAlignment, prop->deviceOverlap, prop->multiProcessorCount,        prop->kernelExecTimeoutEnabled, prop->integrated, prop->canMapHostMemory, prop-> computeMode,            );
    unsigned int size = 0;  // The size of the array
    unsigned int i;  // loop index
    unsigned int * numbers; //pointer to the array
	unsigned int block;
	unsigned int thread;
    
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
	   
   getCuda
   // printf(" The maximum number in the array is: %u\n", 
     //      getmax<<<block, thread>>>(cudaNumbers, cudaSize, cudaN));

    free(numbers);
    exit(0);
}


/*
   input: pointer to an array of long int
          number of elements in the array
   output: the maximum number of the array
*/
_global_ unsigned int getmax(unsigned int num[], unsigned int size, int n)
{
	if(id<size%n)
		starting = (threadId.x+blockId.x*blockDim.x)(size/n+1);
	else
		starting = (size%n)(size/n+1)+((threadId.x+blockId.x*blockDim.x)-size%n)(size/n);
	blockId.x*blockDim.x+threadId.x;
  unsigned int i;
  unsigned int max = num[0];

  for(i = 1; i < size; i++)
	if(num[i] > max)
	   max = num[i];

  return( max );

}