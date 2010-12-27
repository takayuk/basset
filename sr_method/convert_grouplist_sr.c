/* convert_grouplist_sr.c */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
int Dm, Dn, Dc;
int *NumV, **MatW;

/***************************
 ÉtÉ@ÉCÉãì«Ç›çûÇ›ïî
****************************/
void readValue(char *fn1)
{
  FILE *fp;
  int i, j;
  
  if((fp = fopen(fn1, "r")) == NULL){
    printf("Unknown File = %s\n", fn1);
    exit(1);
  }
  
  fscanf(fp, "%d %d %d", &Dm, &Dn, &Dc);
  NumV = (int *) malloc(sizeof(int)*Dm);
  MatW = (int **) malloc(sizeof(int *)*Dm);
  for(i = 0; i < Dm; i++){
    fscanf(fp,"%d", &NumV[i]);
    MatW[i] = (int *) malloc(sizeof(int)*NumV[i]);
    for(j = 0; j < NumV[i]; j++){
      fscanf(fp,"%d",&MatW[i][j]);
    }
  }
  fclose(fp);
}


void printValue(char *fn1)
{
  FILE *fp;
  int i, j;

  if((fp = fopen(fn1, "w")) == NULL){
    printf("Unknown File = %s\n", fn1);
    exit(1);
  }
  
  fprintf(fp,"%d %d %d\n",Dm, Dn, Dc);
  for(i = 0; i < Dm; i++){
    fprintf(fp,"%d\n",MatW[i][0]);
  }
  fclose(fp);
}

main(int argc, char **argv)
{

  readValue(argv[1]);

  printValue(argv[2]);
}
