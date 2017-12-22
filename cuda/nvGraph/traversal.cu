//nvGRAPH Traversal example

#include <nvgraph.h>
#include <stdio.h>

void check_status(nvgraphStatus_t status){
    if ((int)status != 0)    {
        printf("ERROR : %d\n",status);
        exit(0);
    }
}
int main(int argc, char **argv){
    //Example of graph (CSR format)
    const size_t  n = 7, nnz = 12, vertex_numsets = 2, edge_numset = 0;
    int source_offsets_h[] = {0, 1, 3, 4, 6, 8, 10, 12};
    int destination_indices_h[] = {5, 0, 2, 0, 4, 5, 2, 3, 3, 4, 1, 5};
    //where to store results (distances from source) and where to store results (predecessors in search tree) 
    int bfs_distances_h[n], bfs_predecessors_h[n];
    // nvgraph variables
    nvgraphStatus_t status;
    nvgraphHandle_t handle;
    nvgraphGraphDescr_t graph;
    nvgraphCSRTopology32I_t CSR_input;
    cudaDataType_t* vertex_dimT;
    size_t distances_index = 0;
    size_t predecessors_index = 1;
    vertex_dimT = (cudaDataType_t*)malloc(vertex_numsets*sizeof(cudaDataType_t));
    vertex_dimT[distances_index] = CUDA_R_32I;
    vertex_dimT[predecessors_index] = CUDA_R_32I;
    //Creating nvgraph objects
    check_status(nvgraphCreate (&handle));
    check_status(nvgraphCreateGraphDescr (handle, &graph));
    // Set graph connectivity and properties (tranfers)
    CSR_input = (nvgraphCSRTopology32I_t) malloc(sizeof(struct nvgraphCSCTopology32I_st));
    CSR_input->nvertices = n;
    CSR_input->nedges = nnz;
    CSR_input->source_offsets = source_offsets_h;
    CSR_input->destination_indices = destination_indices_h;
    check_status(nvgraphSetGraphStructure(handle, graph, (void*)CSR_input, NVGRAPH_CSR_32));
    check_status(nvgraphAllocateVertexData(handle, graph, vertex_numsets, vertex_dimT));
    int source_vert = 1;
    //Setting the traversal parameters  
    nvgraphTraversalParameter_t traversal_param;
    nvgraphTraversalParameterInit(&traversal_param);
    nvgraphTraversalSetDistancesIndex(&traversal_param, distances_index);
    nvgraphTraversalSetPredecessorsIndex(&traversal_param, predecessors_index);
    nvgraphTraversalSetUndirectedFlag(&traversal_param, false);
    //Computing traversal using BFS algorithm
    check_status(nvgraphTraversal(handle, graph, NVGRAPH_TRAVERSAL_BFS, &source_vert, traversal_param));
    // Get result
    check_status(nvgraphGetVertexData(handle, graph, (void*)bfs_distances_h, distances_index));
    check_status(nvgraphGetVertexData(handle, graph, (void*)bfs_predecessors_h, predecessors_index));
    // expect bfs distances_h = (1 0 1 3 3 2 2147483647)
    for (int i = 0; i<n; i++)  printf("Distance to vertex %d: %i\n",i, bfs_distances_h[i]); printf("\n");
    // expect bfs predecessors = (1 -1 1 5 5 0 -1)
    for (int i = 0; i<n; i++)  printf("Predecessor of vertex %d: %i\n",i, bfs_predecessors_h[i]); printf("\n");
    free(vertex_dimT);
    free(CSR_input);
    check_status(nvgraphDestroyGraphDescr (handle, graph));
    check_status(nvgraphDestroy (handle));
    return 0;
}

