//nvGRAPH convert topology example

#include <nvgraph.h>
#include <stdio.h>

void check(nvgraphStatus_t status) {
    if (status != NVGRAPH_STATUS_SUCCESS) {
        printf("ERROR : %d\n",status);
        exit(0);
    }
}
int main(int argc, char **argv) {
    size_t  n = 6, nnz = 10;
    // nvgraph variables
    nvgraphHandle_t handle;
    nvgraphCSCTopology32I_t CSC_input;
    nvgraphCSRTopology32I_t CSR_output;
    float *src_weights_d, *dst_weights_d;
    cudaDataType_t edge_dimT = CUDA_R_32F;
    // Allocate source data
    CSC_input = (nvgraphCSCTopology32I_t) malloc(sizeof(struct nvgraphCSCTopology32I_st));
    CSC_input->nvertices = n; CSC_input->nedges = nnz;
    cudaMalloc( (void**)&(CSC_input->destination_offsets), (n+1)*sizeof(int));
    cudaMalloc( (void**)&(CSC_input->source_indices), nnz*sizeof(int));
    cudaMalloc( (void**)&src_weights_d, nnz*sizeof(float));
    // Copy source data
    float src_weights_h[] = {0.333333f, 0.5f, 0.333333f, 0.5f, 0.5f, 1.0f, 0.333333f, 0.5f, 0.5f, 0.5f};
    int destination_offsets_h[] = {0, 1, 3, 4, 6, 8, 10};
    int source_indices_h[] = {2, 0, 2, 0, 4, 5, 2, 3, 3, 4};
    cudaMemcpy(CSC_input->destination_offsets, destination_offsets_h, (n+1)*sizeof(int), cudaMemcpyDefault);
    cudaMemcpy(CSC_input->source_indices, source_indices_h, nnz*sizeof(int), cudaMemcpyDefault);
    cudaMemcpy(src_weights_d, src_weights_h, nnz*sizeof(float), cudaMemcpyDefault);
    // Allocate destination data
    CSR_output = (nvgraphCSRTopology32I_t) malloc(sizeof(struct nvgraphCSRTopology32I_st));
    cudaMalloc( (void**)&(CSR_output->source_offsets), (n+1)*sizeof(int));
    cudaMalloc( (void**)&(CSR_output->destination_indices), nnz*sizeof(int));
    cudaMalloc( (void**)&dst_weights_d, nnz*sizeof(float));
    // Starting nvgraph and convert
    check(nvgraphCreate (&handle));
    check(nvgraphConvertTopology(handle, NVGRAPH_CSC_32, CSC_input, src_weights_d,
        &edge_dimT, NVGRAPH_CSR_32, CSR_output, dst_weights_d));
    // Free memory
    check(nvgraphDestroy(handle));
    cudaFree(CSC_input->destination_offsets);
    cudaFree(CSC_input->source_indices);
    cudaFree(CSR_output->source_offsets);
    cudaFree(CSR_output->destination_indices);
    cudaFree(src_weights_d);
    cudaFree(dst_weights_d);
    free(CSC_input);
    free(CSR_output);
    return 0;
}

