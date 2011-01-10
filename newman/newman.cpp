#include "tuple.h"

#include <cstdlib>
#include <cstdio>

struct chain_node {
  int id;
  chain_node* next;
  chain_node(int id): id(id), next(NULL) {}
};

struct chain {
  chain_node* root;

  chain(): root(NULL) {}
  chain(int id): root(new chain_node(-1)) {
    root->next = new chain_node(id);
  }
  ~chain() {
    chain_node* current = root;
    while (current) {
      chain_node* next = current->next;
      free(current);
      current = next;
    }
  }

  chain_node* each(chain_node* current) {
    if (current->next) return current->next;
    else return NULL;
  }

  void merge(chain* other_chain) {
    chain_node* c = root;
    while (c->next) {
      c = c->next;
    }
    c->next = other_chain->root->next;
    other_chain->root->next = NULL;
  }
};

int m(tuple** adj, int* numv, int n) {
  int i, j;
  int val = 0;
  for (i = 0; i < n; ++i) {
    for (j = i; j < numv[i]; ++j) {
      val += adj[i][j].val;
    }
  }
  return val;
}

void disp_adj(tuple** adj, int* numv, int n) {
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < numv[i]; ++j) {
      printf("%d,%d:%d ", adj[i][j].i, adj[i][j].j, adj[i][j].val);
    }
    printf("\n");
  }
}

void disp_cluster(chain** cluster, int n) {
  for (int i = 0; i < n; ++i) {
    if (cluster[i]) {
      chain_node* current = cluster[i]->root;

      do {
        printf("%d ", current->id);
      } while (current = cluster[i]->each(current));
      printf("\n");
    }
  }
  printf(" ----------\n");
}

int e(chain** cluster, int i, int j, tuple** adj, int* numv, int n) {

  chain_node* ci = cluster[i]->root->next;
  chain_node* cj = cluster[j]->root->next;
 
  int val = 0;
  if (ci && cj) {

    for (; ci != NULL; ci = ci->next) {
      int ni = ci->id;
      for (; cj != NULL; cj = cj->next) {
        int nj = cj->id;

        for (int jj = 0; jj < numv[ni]; ++jj) {
          if (adj[ni][jj].j == nj) val += adj[ni][jj].val;
        }
      }
    }
  }
  return val;
}

/*
 * @brief Delete link inside merged cluster.
 */
void reduce(chain** cluster, int i, int j, tuple** adj, int* numv, int n) {
 
  chain_node* ci = cluster[i]->root->next;
  chain_node* cj = cluster[j]->root->next;
 
  if (ci && cj) {

    for (; ci != NULL; ci = ci->next) {
      int ni = ci->id;
      
      for (; cj != NULL; cj = cj->next) {
        int nj = cj->id;
        
        for (int jj = 0; jj < numv[ni]; ++jj) {
          if (adj[ni][jj].j == nj) {
            adj[ni][jj].val = 0;
            adj[adj[ni][jj].j][ni].val = 0;
          }
        }
      }
    }
  }
}

bool check_clusteradj(chain** cluster, int m, tuple** adj, int* numv, int n) {

  int valid_cluster = 0;
  for (int i = 0; i < n; ++i) {
    chain_node* c = cluster[i]->root->next;
    
    if (c) valid_cluster += 1;
  }

  return valid_cluster > 1;
  /*
  int e = 0;
  for (int i = 0; i < m; ++i) {
    chain_node* c = cluster[i]->root->next;
    if (!c) continue;
  
    chain_node* d = cluster[i]->root->next;
    
    for (; c != NULL; c = c->next) {
      int ni = c->id;
      for (; d != NULL; d = d->next) {
        int nj = d->id;
        if (ni == nj) break;
        
        for (int jj = 0; jj < numv[ni]; ++jj) {
          if (adj[ni][jj].j == nj) e += adj[ni][jj].val;
        }
      }
    }
  }
  return e > 0;
  */
}

void newman(tuple** adj, int* numv, int n) {

  int mval = m(adj, numv, n);

  chain** cluster = (chain**)malloc(n * sizeof(chain*));
  for (int i = 0; i < n; ++i) {
    cluster[i] = new chain(i);
  }

  // Adj of cluster.
  while (true) {
    int maxe = 0, maxi = -1, maxj = -1;
    
    for (int i = 0; i < n; ++i) {
      for (int j = i; j < n; ++j) {
        if (i == j) continue;
        int e_ = e(cluster, i, j, adj, numv, n);
        if (e_ > maxe) {
          maxe = e_; maxi = i; maxj = j;
        }
      }
    }
    reduce(cluster, maxi, maxj, adj, numv, n);
    disp_adj(adj, numv, n);
    
    cluster[maxj]->merge(cluster[maxi]);
    disp_cluster(cluster, n);
    
    if (!check_clusteradj(cluster, n, adj, numv, n)) break;
  }

  for (int i = 0; i < n; ++i) {
    delete cluster[i];
  }
  free(cluster);
}

