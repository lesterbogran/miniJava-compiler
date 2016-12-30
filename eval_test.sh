set  -x
make
echo "MAX = 200;\nPRIMES = new int[MAX+1];\ni = 0;\nwhile(i<MAX+1){\n  PRIMES[i]=1;\n  i=i+1;\n}\nPRIMES[0] = 0;\nPRIMES[1] = 0;\ni=1;\nwhile(i<MAX+1){\n  if(PRIMES[i]==1){\n    j=i*2;\n    while(j<MAX+1){\n      PRIMES[j]=0;\n      j=j+i;\n    }\n  }else{ ; }\n  i = i + 1;\n}\ni=0;\nwhile(i<MAX+1){\n  if(PRIMES[i]==1){\n    System.out.println(i);\n  }else{;}\n  i=i+1;\n}\n" > test.java
cat -n test.java
cat test.java | ./miniJava
rm test.java



