/* make_grouplist.c */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
int Dm, Dn, Dc, Ds, *VecN;
int *VecA, **MatB;
int *VecC;

void    readGroup(char *fn1)
{
  FILE		*fp;
  int		i, j;
  int           N;
  if((fp = fopen(fn1, "r")) == NULL) {
    printf("Unknown File = %s\n", fn1);
    exit(1);
  }
  fscanf(fp, "%d %d %d", &Dm, &Dn, &Dc);
  VecA = (int *) malloc(sizeof(int)*Dm);
  MatB = (int **) malloc(sizeof(int *)*Dm);
  for(i = 0; i < Dm; i++){
    fscanf(fp,"%d",&VecA[i]);
    N = VecA[i]+1;
    MatB[i] = (int *) malloc(sizeof(int)*N);
    for(j = 0; j < VecA[i]; j++){
      fscanf(fp,"%d",&MatB[i][j]);
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
  int i;
  
  /*VecC = (int *) malloc(sizeof(int)*Dm);
  for(i = 0; i < Dm; i++){
    VecC[i] = 0;
  }*/
  for(i = 0; i < Ds; i++){
    MatB[VecN[i]][VecA[VecN[i]]] = Dc;
    /*VecC[VecN[i]] = Dc;*/
    VecA[VecN[i]]++;
  }
}

void printValue(char *fn1)
{
  FILE *fp;
  int i, j;

  fp = fopen(fn1,"w");
  fprintf(fp,"%d %d %d\n",Dm, Dn, Dc+1);
  for(i = 0; i < Dm; i++){
    fprintf(fp,"%d ",VecA[i]);
    for(j = 0; j < VecA[i]; j++){
      fprintf(fp,"%d ",MatB[i][j]);
    }
    fprintf(fp,"\n");
  }
  fclose(fp);
}

main(int argc, char **argv)
{
  int i;
  //printf("readGroup(argv[1])\n");
  readGroup(argv[1]);
  //printf("readNode(argv[2])\n");
  readNode(argv[2]);
  //printf("hoge()\n");
  hoge();
  //printf("printValue(argv[3])\n");
  printValue(argv[3]);
}
