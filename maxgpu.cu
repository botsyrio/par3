#include <stdlib.h>
#include <time.h>
#include <cuda.h>

cudaDeviceProp prop;
cudaError_t error = cudaGetDeviceProperties(&prop, 0);


unsigned int getmax(unsigned int *, unsigned int);

int main(int argc, char *argv[])
{
	printf("char name[256]; = %s\n
              size_t totalGlobalMem; = %d\n
              size_t sharedMemPerBlock; = %d\n
              int regsPerBlock; = %d\n
              int warpSize; = %d\n
              size_t memPitch; = %d\n
              int maxThreadsPerBlock; = %d\n
              int maxThreadsDim[3]; = %d\n
              int maxGridSize[3]; = %d\n
              int clockRate; = %d\n
              size_t totalConstMem; = %d\n
              int major; = %d\n
              int minor; = %d\n
              size_t textureAlignment; = %d\n
              size_t texturePitchAlignment; = %d\n
              int deviceOverlap; = %d\n
              int multiProcessorCount; = %d\n
              int kernelExecTimeoutEnabled; = %d\n
              int integrated; = %d\n
              int canMapHostMemory; = %d\n
              int computeMode; = %d\n
              int maxTexture1D; = %d\n
              int maxTexture1DMipmap; = %d\n
              int maxTexture1DLinear; = %d\n
              int maxTexture2D[2]; = %d\n
              int maxTexture2DMipmap[2]; = %d\n
              int maxTexture2DLinear[3]; = %d\n
              int maxTexture2DGather[2]; = %d\n
              int maxTexture3D[3]; = %d\n
              int maxTexture3DAlt[3]; = %d\n
              int maxTextureCubemap; = %d\n
              int maxTexture1DLayered[2]; = %d\n
              int maxTexture2DLayered[3]; = %d\n
              int maxTextureCubemapLayered[2]; = %d\n
              int maxSurface1D; = %d\n
              int maxSurface2D[2]; = %d\n
              int maxSurface3D[3]; = %d\n
              int maxSurface1DLayered[2]; = %d\n
              int maxSurface2DLayered[3]; = %d\n
              int maxSurfaceCubemap; = %d\n
              int maxSurfaceCubemapLayered[2] = %d\n;
              size_t surfaceAlignment; = %d\n
              int concurrentKernels; = %d\n
              int ECCEnabled; = %d\n
              int pciBusID; = %d\n
              int pciDeviceID; = %d\n
              int pciDomainID; = %d\n
              int tccDriver; = %d\n
              int asyncEngineCount; = %d\n
              int unifiedAddressing; = %d\n
              int memoryClockRate; = %d\n
              int memoryBusWidth; = %d\n
              int l2CacheSize; = %d\n
              int maxThreadsPerMultiProcessor; = %d\n
              int streamPrioritiesSupported; = %d\n
              int globalL1CacheSupported; = %d\n
              int localL1CacheSupported; = %d\n
              size_t sharedMemPerMultiprocessor; = %d\n
              int regsPerMultiprocessor; = %d\n
              int managedMemSupported; = %d\n
              int isMultiGpuBoard; = %d\n
              int multiGpuBoardGroupID; = %d\n
              int singleToDoublePrecisionPerfRatio; = %d\n
              int pageableMemoryAccess; = %d\n
              int concurrentManagedAccess; = %d\n
              int computePreemptionSupported; = %d\n
              int canUseHostPointerForRegisteredMem; = %d\n
              int cooperativeLaunch; = %d\n
              int cooperativeMultiDeviceLaunch;", prop->name,
              prop->totalGlobalMem,
              prop->sharedMemPerBlock,
            prop->regsPerBlock,
              prop->warpSize,
              prop->memPitch,
              prop->maxThreadsPerBlock,
              prop->maxThreadsDim[3],
              prop->maxGridSize[3],
              prop->clockRate,
              prop->totalConstMem,
              prop->major,
              prop->minor,
              prop->textureAlignment,
             prop->texturePitchAlignment,
              prop->deviceOverlap,
              prop->multiProcessorCount,
              prop->kernelExecTimeoutEnabled,
            prop->integrated,
              prop->canMapHostMemory,
              prop-> computeMode,
              prop-> maxTexture1D,
              prop-> maxTexture1DMipmap,
              prop-> maxTexture1DLinear,
              prop-> maxTexture2D[2],
              prop-> maxTexture2DMipmap[2],
              prop-> maxTexture2DLinear[3],
              prop-> maxTexture2DGather[2],
              prop-> maxTexture3D[3],
              prop-> maxTexture3DAlt[3],
              prop-> maxTextureCubemap,
              prop-> maxTexture1DLayered[2],
              prop-> maxTexture2DLayered[3],
              prop-> maxTextureCubemapLayered[2],
              prop-> maxSurface1D,
              prop-> maxSurface2D[2],
              prop-> maxSurface3D[3],
              prop-> maxSurface1DLayered[2],
              prop-> maxSurface2DLayered[3],
              prop-> maxSurfaceCubemap,
              prop-> maxSurfaceCubemapLayered[2],
              prop-> surfaceAlignment,
              prop-> concurrentKernels,
              prop-> ECCEnabled,
              prop-> pciBusID,
              prop-> pciDeviceID,
              prop-> pciDomainID,
              prop-> tccDriver,
              prop-> asyncEngineCount,
              prop->unifiedAddressing,
              prop->memoryClockRate,
              prop->memoryBusWidth,
              prop->l2CacheSize,
              prop->maxThreadsPerMultiProcessor,
              prop->streamPrioritiesSupported,
              prop->globalL1CacheSupported,
              prop-> localL1CacheSupported,
              prop-> sharedMemPerMultiprocessor,
              prop-> regsPerMultiprocessor,
              prop-> managedMemSupported,
              prop-> isMultiGpuBoard,
              prop-> multiGpuBoardGroupID,
              prop-> singleToDoublePrecisionPerfRatio,
              prop-> pageableMemoryAccess,
              prop-> concurrentManagedAccess,
              prop-> computePreemptionSupported,
              prop-> canUseHostPointerForRegisteredMem,
              prop-> cooperativeLaunch,
              prop-> cooperativeMultiDeviceLaunch);
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