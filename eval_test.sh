set  -x
make
echo "public int main(int argc, int[] argv){\nint MAX;\nint[] PRIMES;\nint i;\nint j;\nint count;\nMAX = 200;\nPRIMES = new int[MAX+1];\ni = 0;\nwhile(i<MAX+1){\n  PRIMES[i]=1;\n  i=i+1;\n}\nPRIMES[0] = 0;\nPRIMES[1] = 0;\ni=1;\nwhile(i<MAX+1){\n  if(PRIMES[i]==1){\n    j=i*2;\n    while(j<MAX+1){\n      PRIMES[j]=0;\n      j=j+i;\n    }\n  }else{ ; }\n  i = i + 1;\n}\ni=0;\ncount=0;\nwhile(i<MAX+1){\n  if(PRIMES[i]==1){\n    System.out.println(i);\n    count=count+1;\n  }else{;}\n  i=i+1;\n}\nreturn count;}public int test(){return 42;}\n" > test.java
cat -n test.java
cat test.java | ./miniJava
rm test.java

