#include <stdio.h>

__global__ void initWith(float num, float *a, int N)
{
  int i=  blockIdx.x * blockDim.x + threadIdx.x;
  if(i < N)
  {
    a[i] = num;
  }
}

__global__ void addVectorsInto(float *result, float *a, float *b, int N)
{
  int i=  blockIdx.x * blockDim.x + threadIdx.x;
  if( i < N)
  {
    result[i] = a[i] + b[i];
  }
}


void checkElementsAre(float target, float *array, int N)
{
  for(int i = 0; i < N; i++)
  {

    if(array[i] != target)
    {
      printf("FAIL: array[%d] - %0.0f does not equal %0.0f\n", i, array[i], target);
      exit(1);
    }
  }
  printf("SUCCESS! All values added correctly.\n");
}


int main()
{
  const int N = 2<<20;
  size_t size = N * sizeof(float);

  float *a;
  float *b;
  float *c;

  // a = (float *)malloc(size);
  // b = (float *)malloc(size);
  // c = (float *)malloc(size);
  cudaMallocManaged(&a, size);
  cudaMallocManaged(&b, size);
  cudaMallocManaged(&c, size);
  int threads_per_block=1024;
  int number_of_blocks= (N + threads_per_block - 1) / threads_per_block;
  
  initWith<<<number_of_blocks,threads_per_block>>>(3, a, N);
  initWith<<<number_of_blocks,threads_per_block>>>(4, b, N);
  initWith<<<number_of_blocks,threads_per_block>>>(0, c, N);

  addVectorsInto<<<number_of_blocks,threads_per_block>>>(c, a, b, N);

  cudaDeviceSynchronize();
  
  checkElementsAre(7, c, N);
  
  cudaFree(a);
  cudaFree(b);
  cudaFree(c);
}
