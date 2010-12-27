/* meke_group-list.c */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
int Dm, Dn, Dc, Ds, *VecN;
char **Name;

void    readValue(char *fn1)
{
  FILE		*fp;
  int		i, v;
  if((fp = fopen(fn1, "r")) == NULL) {
    printf("Unknown File = %s\n", fn1);
    exit(1);
  }
  fscanf(fp, "%d %d %d", &Dn, &Dm, &Dc);
  fscanf(fp, "%d", &Ds);
  VecN = (int *) malloc(sizeof(int)*Ds);
  for(i = 0; i < Ds; i++){
    fscanf(fp,"%d",&v);
    VecN[i] = v-1;
  }
  fclose(fp);
}

void    readName(char *fn1)
{
  FILE		*fp;
  int		i, j, k;
  int		v,s;
  if((fp = fopen(fn1, "r")) == NULL){
    printf("Unknown File = %s\n", fn1); exit(1);
  }
  Name = (char **) malloc(sizeof(char *)*Dm);
  for(i = 0; i < Dm; i++){
    fscanf(fp, "%d", &v);
    fscanf(fp, "%d", &s);
    fscanf(fp, "\t");
    Name[i] = (char *) malloc(sizeof(char)*1023);
    for(j = 0; j < 1024; j++) 
      if((Name[i][j] = getc(fp)) == '\n') break; 
    Name[i][j] = '\0'; 
  }
  fclose(fp);
  printf("%d\n", Dm); 
}

void printValue(char *fn1)
{
  FILE *fp;
  int i;

  fp = fopen(fn1,"w");
  for(i = 0; i < Ds; i++){
    fprintf(fp,"%d %s\n", VecN[i]+1, Name[VecN[i]]);
  }
  fclose(fp);
}

main(int argc, char **argv)
{
  readValue(argv[1]);
  
  readName(argv[2]);
  printf("aaa\n");
  printValue(argv[3]);
}
