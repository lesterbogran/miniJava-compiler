class Prime{
  static int count;
  public static void main(String[] args){
    int MAX;
    int[] PRIMES;
    int i;
    int j;
    MAX = 20;
    PRIMES = new int[MAX+1];
    i = 0;
    while(i<MAX+1){
      PRIMES[i]=1;
      i=i+1;
    }
    PRIMES[0] = 0;
    PRIMES[1] = 0;
    i=1;
    while(i<MAX+1){
      if(PRIMES[i]==1){
        j=i*2;
        while(j<MAX+1){
          PRIMES[j]=0;
          j=j+i;
        }
      }else{ ; }
      i = i + 1;
    }
    i=0;
    count=0;
    while(i<MAX+1){
      if(PRIMES[i]==1){
        System.out.println(i);
        count=count+1;
      }else{;}
      i=i+1;
    }
  }

  public int test(){
    System.out.println(i);
    System.out.println(count);
    return 42;
  }
}


