#include "tuple.h"

#include <cstdlib>

void newman(tuple**,int*,int);

main() {
  int n = 4;
  int* numv = (int*)malloc(n * sizeof(int));
  numv[0] = 2;
  numv[1] = 2;
  numv[2] = 3;
  numv[3] = 1;

  int dummy[4][3] = {
    {1, 2},
    {0, 2},
    {0, 1, 3},
    {1, 2}};

  tuple** adj = (tuple**)malloc(n * sizeof(tuple*));
  //int** adj = (int**)malloc(n * sizeof(int*));
  for (int i = 0; i < n; ++i) {
    //adj[i] = (int*)malloc(numv[i] * sizeof(int));
    adj[i] = (tuple*)malloc(numv[i] * sizeof(tuple));
    for (int j = 0; j < numv[i]; ++j) {
      //adj[i][j] = tuple(i, j, 1);
      adj[i][j] = tuple(i, dummy[i][j], 1);
    }
  }

  newman(adj, numv, n);

  free(numv);
  for (int i = 0; i < n; ++i) {
    free(adj[i]);
  }
  free(adj);
}

