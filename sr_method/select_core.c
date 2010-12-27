/* select_core.c */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
int Dm, Dn, Dc, Ds, *NumV, **MatW, **MatF, *NumC, **MatC;
int *VecN;
int *VecA;
int *NumVN, **MatWN;

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
  int i, j;
  int s;
  
  VecA = (int *) malloc(sizeof(int)*Dm);
  NumVN = (int *) malloc(sizeof(int)*Dm);
  MatWN = (int **) malloc(sizeof(int *)*Dm);
  
  for(i = 0; i < Dm; i++){
    NumVN[i] = 0;
    for(j = 0; j < Dm; j++){
      VecA[j] = 0;
    }
    for(j = 0; j < NumV[i]; j++){
      VecA[MatW[i][j]] = 1;
    }
    for(j = 0; j < Ds; j++){
      VecA[VecN[j]] = 0;
    }
    for(j = 0; j < Dm; j++){
      NumVN[i] += VecA[j];
    }
    MatWN[i] = (int *) malloc(sizeof(int)*NumVN[i]);
    for(j = 0, s = 0; j < Dm; j++){
      if(VecA[j] > 0){
        MatWN[i][s] = j;
        s++;
      }
    }
  }
}

void printValue(char *fn1)
{
  FILE *fp;
  int i, j;

  fp = fopen(fn1,"w");
  fprintf(fp,"%d %d %d\n",Dm, Dn,Dc);
  for(i = 0; i < Dm; i++){
    fprintf(fp,"%d ",NumVN[i]);
    for(j = 0; j < NumVN[i]; j++){
      fprintf(fp,"%d:1 ",MatWN[i][j]+1);
    }
    fprintf(fp,"%d %d\n",NumC[i], MatC[i][0]+1);
  }
  fclose(fp);
}

main(int argc, char **argv)
{

  readNode(argv[1]);

  readValue(argv[2]);

  hoge();

  printValue(argv[3]);
}
