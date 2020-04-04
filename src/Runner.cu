// includes, cuda
#include <cstdint>
#include <cuda_runtime.h>
#include <helper_cuda.h>

#include <cudaDefs.h>

cudaDeviceProp deviceProp = cudaDeviceProp();

int main(int argc, char* argv[])
{
	initializeCUDA(deviceProp);
}
