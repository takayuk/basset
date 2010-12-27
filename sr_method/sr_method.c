#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

int	Dm, Dn, Dc, *NumV, **MatW, *NumC, **MatC, *ID, *VecR, *VecE;
double  **MatF, *VecA, *VecB, *VecC, *VecD, *VecG;

Dm=nil

void readValue(char *fn1)
{
	FILE		*fp;
	int		i, j, k;
        double          v;
	if((fp = fopen(fn1, "r")) == NULL) {
		printf("Unknown File = %s\n", fn1);
                exit(1);
        }
	fscanf(fp, "%d %d %d", &Dm, &Dn, &Dc); 
	NumV = (int *) malloc(sizeof(int)*Dm);            /* ノード数 */
	MatW = (int **) malloc(sizeof(int *)*Dm);         /* ノードID */
	MatF = (double **) malloc(sizeof(double *)*Dm);         /* ノードのつながり(あるときは1) */
        NumC = (int *) malloc(sizeof(int)*Dm);            /* 無関係 */
        MatC = (int **) malloc(sizeof(int *)*Dm);         /* 無関係 */
        for(i = 0; i < Dm; i++){
		fscanf(fp, "%d", &NumV[i]);
		MatW[i] = (int *) malloc(sizeof(int)*NumV[i]);
		MatF[i] = (double *) malloc(sizeof(double)*NumV[i]);
		for(j = 0; j < NumV[i]; j++){ 
			fscanf(fp, "%d:%lf", &k, &v);
			MatW[i][j] = k-1;
			MatF[i][j] = v;
		}
    /*
		fscanf(fp, "%d", &NumC[i]);
                MatC[i] = (int *) malloc(sizeof(int)*NumC[i]);
                for(j = 0; j < NumC[i]; j++){
                        fscanf(fp, "%d", &k);
                        MatC[i][j] = k;
                }
                */
	}
	fclose(fp);
}
/*
def E_1
  vecA=Array.new(Dm,1)
  vecC=Array.new(Dm,1)
  vecD=Array.new(Dm+1,0)
  vecG=Array.new(Dm+1,0)
end
 */
void E_1()
{
  int i, M;

  M = Dm+1;
  
  VecA = (double *) malloc(sizeof(double)*Dm);

  for(i = 0; i < Dm; i++){
    VecA[i] = 1.0;
  }
  
  VecB = (double *) malloc(sizeof(double)*Dm);

  VecC = (double *) malloc(sizeof(double)*Dm);

  for(i = 0; i < Dm; i++){
    VecC[i] = 1.0;
  }

  VecD = (double *) malloc(sizeof(double)*M);

  for(i = 0; i <= Dm; i++){
    VecD[i] = 0.0;
  }

  VecG = (double *) malloc(sizeof(double)*M);
  for(i = 0; i <= Dm; i++){
    VecG[i] = 0.0;
  }

  VecE = (int *) malloc(sizeof(int)*Dm);
  
}

/*
def E_2
  f=1
  
  for i in 0..Dm-1
    VecB[i]=0
  end

  for i in 0..Dm-1
    for j in 0..Dm-1
      VecB[i]+=MatF[i][j]*VecA[MatW[i][j]
    end
  end

  for i in 0..Dm-1
    VecA[i]=VecB[i]
  end

  max=VecA.max
  VecA.map!{|v|v/max}
end
 */
void E_2()
{
  int i, j, f;
  double max;

  f = 1;
  
  for(i  =0; i < Dm; i++){
    VecB[i] = 0.0;
  }
  
  for(i = 0; i < Dm; i++){
    for(j = 0; j < NumV[i]; j++){
      VecB[i] += (MatF[i][j]*VecA[MatW[i][j]]);
    }
  }

  for(i = 0; i < Dm; i++){
    VecA[i] = VecB[i];
  }

  for(i = 0; i < Dm; i++){
    if(f == 1 || max < VecA[i]){
      max = VecA[i];
      f = 0;
    }
  }

  for(i = 0; i < Dm; i++){
    VecA[i] = VecA[i]/max;
  }
}

/*
def E_3
  h=1
  for i in 0..Dm-1
    if Mas.fabs(VecA[i] - VecC[i]) > EPS
      h=0
    end
    VecC[i]=VecA[i]
  end

  h
end
 */
int E_3(double eps)
{
  int i, h;

  h = 1;

  for(i = 0; i < Dm; i++){
    if(fabs(VecA[i] - VecC[i]) > eps){
      h = 0;
    }
    VecC[i] = VecA[i];
  }
  return(h);
}

typedef struct _TESTS{
	int id;
	double val;
}TESTS;


//qsort用コールバック関数
int comp(const void *_a, const void *_b)
{
  double a = ((TESTS *)_a)->val;
  double b = ((TESTS *)_b)->val;

  if (a > b) {
    return -1;
  } else if (a < b) {
    return 1;
  } else {
    return 0;
  }
  
}


void mysort()
{
  int i, M;
  TESTS test[Dm];

  M = Dm+1;
  
  VecR = (int *) malloc(sizeof(int)*M);
  
	//構造体に値の代入
  for( i = 0 ; i < Dm ; i++ ){
    test[i].id = i;
    test[i].val = VecA[i];
  }
  
  //クイックソートをする
  qsort( test , Dm , sizeof(TESTS) , comp);

  for(i = 0; i < Dm; i++){
    VecR[i+1] = test[i].id;
    VecA[i] = test[i].val;
  }
}

void free_power(){
  free(VecA);
  free(VecB);
  free(VecC);
}

void F_2_1(){
  int i, j, k;

  for(i = 1; i < Dm; i++){
    VecD[i+1] = 0;
  }
  
  for(k = 1; k < Dm; k++){
    for(j = 0; j < Dm; j++){
      VecE[j] = 0;
    }
    
    for(j = 0; j < NumV[VecR[k]]; j++){
      VecE[MatW[VecR[k]][j]] = 1;
    }
    for(j = 1; j <= k; j++){
      VecD[k+1] += VecE[VecR[j]];
    }
  }
}

void F_2_2(){
  int k;

  for(k = 1; k < Dm; k++){
    VecG[k+1] = VecG[k] + ((VecD[k+1] - VecG[k])/(k+1));
  }
}

int F_3(){
  int i, k, f;
  double max;

  f = 1;
  
  for(i = 2; i <= Dm; i++){
    if(f == 1 || max < VecG[i]){
      max = VecG[i];
      k = i;
      f = 0;
    }
  }
  return(k);
}

void   printValue(char *fn1, int N)
{
  FILE *fp;
  int i,j;
  
  fp = fopen(fn1,"w");
  fprintf(fp,"%d %d %d\n",Dm, Dn, Dc);
  fprintf(fp,"%d ",N);
  for(i = 1; i <= N; i++){
    fprintf(fp,"%d ",VecR[i]+1);
  }
  fclose(fp);
}

/**************************
  メイン関数
***************************/
main(int argc, char **argv)
{
  int i, N;
  double err;

  err = 1.0e-10;
  
  readValue(argv[1]); /* label-list */

  E_1();

  for(i = 0; i < 1000001; i++){
    printf("No.%d\n",i+1);
    E_2();
    if(E_3(err) == 1){
      break;
    }
  }
  //printf("bbbb\n");
  mysort();

  //printf("ccc\n");
  free_power();
//printf("ddd\n");
  F_2_1();
  //printf("eee\n");
  F_2_2();
//printf("fff\n");
  N = F_3();

  if(i < 1000000){
    printValue(argv[2],N);
  }
  

}

