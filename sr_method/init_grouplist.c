/* init_grouplist.c */
#include	<stdio.h>
#include	<stdlib.h>
#include	<math.h>
#include	<unistd.h>
#include	<sys/times.h>
#include	<time.h>

int N;

void	printValue(char *fn1)
{
  FILE            *fp;
  int             i;
  
  fp = fopen(fn1, "w");

  fprintf(fp,"%d %d 1\n", N, N);
  for(i = 0; i < N; i++){
    fprintf(fp,"0\n");
  }
  fclose(fp);
}

main(int argc, char **argv)
{ 
  N = atof(argv[1]);

  printValue(argv[2]);
}
