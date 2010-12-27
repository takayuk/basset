/* make_subnetwork.c */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
int Dm, Dn, Dc, Ds, *NumV, **MatW, **MatF, *NumC, **MatC, *VecN, *VecA;
int M;

/***************************
 ファイル読み込み部
****************************/
void    readValue(char *fn1)
{
	FILE		*fp;
	int		i, j, v, k;
	if((fp = fopen(fn1, "r")) == NULL) {
		printf("Unknown File = %s\n", fn1);
                exit(1);
        }
	fscanf(fp, "%d %d %d", &Dm, &Dn, &Dc); 
	NumV = (int *) malloc(sizeof(int)*Dm);            /* ノード数 */
	MatW = (int **) malloc(sizeof(int *)*Dm);         /* ノードID */
	MatF = (int **) malloc(sizeof(int *)*Dm);         /* ノードのつながり(あるときは1) */
        NumC = (int *) malloc(sizeof(int)*Dm);            /* 無関係 */
        MatC = (int **) malloc(sizeof(int *)*Dm);         /* 無関係 */
        for(i = 0; i < Dm; i++){
		fscanf(fp, "%d", &NumV[i]);
		MatW[i] = (int *) malloc(sizeof(int)*NumV[i]);
		MatF[i] = (int *) malloc(sizeof(int)*NumV[i]);
		for(j = 0; j < NumV[i]; j++){ 
			fscanf(fp, "%d:%d", &k, &v);
			MatW[i][j] = k-1;
			MatF[i][j] = v;
		}
		fscanf(fp, "%d", &NumC[i]);
                MatC[i] = (int *) malloc(sizeof(int)*NumC[i]);
                for(j = 0; j < NumC[i]; j++){
                        fscanf(fp, "%d", &k);
                        MatC[i][j] = k-1;
                }
	}
	fclose(fp);
}


void    readNode(char *fn1)
{
  FILE		*fp;
  int		i, v, m, n, c;
  if((fp = fopen(fn1, "r")) == NULL) {
    printf("Unknown File = %s\n", fn1);
    exit(1);
  }
  fscanf(fp, "%d %d %d", &m, &n, &c);
  fscanf(fp, "%d", &Ds);
  VecN = (int *) malloc(sizeof(int)*Ds);
  for(i = 0; i < Ds; i++){
    fscanf(fp,"%d",&v);
    VecN[i]  = v-1;
  }
  fclose(fp);
}

void hoge()
{
  int i,j, s = 0;
  
  VecA = (int *) malloc(sizeof(int)*Dm);

  for(i = 0; i < Dm; i++){
    VecA[i] = 0;
  }
  
  for(i = 0; i < Ds; i++){
    for(j = 0; j < Dm; j++){
      if(VecN[i] == MatC[j][0]){
        VecA[j] = 1;
      }
    }
  }

  for(i = 0; i < Dm; i++){
    if(VecA[i] > 0){
      s++;
      VecA[i] = s;
    }
  }
  M = s;
}

void printValue(char *fn1)
{
  FILE *fp;
  int i, j, N;

  fp = fopen(fn1,"w");
  fprintf(fp,"%d %d %d\n",M, M, Dc);
  for(i = 0; i < Dm; i++){
    if(VecA[i] > 0){
      N = 0;
      for(j = 0; j < NumV[i]; j++){
        if(VecA[MatW[i][j]] > 0){
          N++;
        }
      }
      fprintf(fp,"%d ",N);
      if(N > 0){
        for(j = 0; j < NumV[i]; j++){
          if(VecA[MatW[i][j]] > 0){
            fprintf(fp,"%d:1 ",VecA[MatW[i][j]]);
          }
        }
      }
      fprintf(fp,"%d %d\n",NumC[i], MatC[i][0]+1);
    }
  }
  fclose(fp);
}

main(int argc, char **argv)
{
  int i;
  
  readNode(argv[1]);

  readValue(argv[2]);

  
  
  hoge();
  printf("aa\n");
  printValue(argv[3]);
}
