#include <stdio.h>

/*
 * Refactor `loop` to be a CUDA Kernel. The new kernel should
 * only do the work of 1 iteration of the original loop.
 */

__global__ void loop(int num_threads)
{
    int i = blockIdx.x* blockDim.x+threadIdx.x;
    //int i = blockIdx.x * blockDim.x + threadIdx.x;
    printf("This is iteration number %d\n", i);

}

int main()
{
  /*
   * When refactoring `loop` to launch as a kernel, be sure
   * to use the execution configuration to control how many
   * "iterations" to perform.
   *
   * For this exercise, be sure to use more than 1 block in
   * the execution configuration.
   */
  int N=20;
  int num_blocks = 5;
  int num_threads=N/num_blocks;
  loop<<<num_blocks,num_threads>>>(num_threads);
  cudaDeviceSynchronize();
}
