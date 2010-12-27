#!/home/kamei/local/bin/ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-
=begin
int	Dm, Dn, Dc, *NumV, **MatW, *NumC, **MatC, *ID, *VecR, *VecE;
double  **MatF, *VecA, *VecB, *VecC, *VecD, *VecG;
=end
$dm=nil
$numv=nil

$vecA=nil
$vecB=nil
$vecC=nil
$vecD=nil
$vecG=nil
$vecR=nil

def readValue path
  @buf=open(path).readlines.map{|v|v.chomp}.reject{|w|w.empty?}

  $dm=@buf[0].split(" ").reject{|v|v.empty?}.first.to_i.freeze
  
  $matw=Array.new($dm)
  $matf=Array.new($dm)
  
  $numv=Array.new($dm)

  for ii in 1..@buf.size-1
    i=ii-1
    @line=@buf[ii].split(" ").reject{|v|v.empty?}
    $numv[i]=@line.shift.to_i

    $matw[i]=Array.new($numv[i],0)
    $matf[i]=Array.new($numv[i],0)

    for j in 0..$numv[i]-1
      begin
        @kv=@line[j].split(":")
        $matw[i][j]=@kv[0].to_i-1
        $matf[i][j]=@kv[1].to_f
      rescue
        p @line
        p j
        p @line[j]
        exit
      end
    end
  end
end

def E_1
  $vecA=Array.new($dm,1)
  $vecB=Array.new($dm,0)
  $vecC=Array.new($dm,1)
  $vecD=Array.new($dm+1,0)
  $vecG=Array.new($dm+1,0)
end

def E_2
  for i in 0..$dm-1
    for j in 0..$numv[i]-1
      $vecB[i]+=$matf[i][j]*$vecA[$matw[i][j]]
    end
  end

  for i in 0..$dm-1
    $vecA[i]=$vecB[i]
  end

  max=$vecA.max
  $vecA.map!{|v|v/max}
end

def E_3 eps
  h=1
  for i in 0..$dm-1
    if ($vecA[i] - $vecC[i]).abs > eps
      h=0
    end
    $vecC[i]=$vecA[i]
  end

  h
end

def F_2_1
  for i in 1..$dm-1
    $vecD[i+1]=0
  end

  for k in 1..$dm-1
    for j in 0..$dm-1
      $vecE[j]=0
    end

    for j in 0..$numv[$vecR[k]]-1
      $vecE[$matw[$vecR[k]][j]]=1
    end
    for j in 1..k
      $vecD[k+1]+=$vecE[$vecR[j]]
    end
  end
end

=begin
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
=end

def F_2_2
  for k in 1..$dm-1
    $vecG[k+1]=$vecG[k]+(($vecD[k+1]-$vecG[k])/(k+1))
  end
end

=begin
void F_2_2(){
  int k;

  for(k = 1; k < Dm; k++){
    VecG[k+1] = VecG[k] + ((VecD[k+1] - VecG[k])/(k+1));
  }
}
=end

def F_3
  @f=1
  @k=nil
  @max=0
  for i in 2..$dm
    if @f==1 || @max < $vecG[i]
      @max=$vecG[i]
      @k=i
      @f=0
    end
  end
  @k
end

=begin
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
=end

def mysort
  $vecR=Array.new($dm+1)
end

def main
  err = 1.0e-10;
  
  readValue(ARGV[0])

  E_1();

  for i in 0..1000000

    E_2();
    break if E_3(err) == 1
  end
  p $vecA
=begin
  mysort();

  F_2_1();
  F_2_2();
  N = F_3();
=end

end
=begin
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
=end

main
