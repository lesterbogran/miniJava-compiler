set  -x
make
echo "int count;\npublic int main(int argc, int[] argv){\nint MAX;\nint[] PRIMES;\nint i;\nint j;\nMAX = 20;\nPRIMES = new int[MAX+1];\ni = 0;\nwhile(i<MAX+1){\n  PRIMES[i]=1;\n  i=i+1;\n}\nPRIMES[0] = 0;\nPRIMES[1] = 0;\ni=1;\nwhile(i<MAX+1){\n  if(PRIMES[i]==1){\n    j=i*2;\n    while(j<MAX+1){\n      PRIMES[j]=0;\n      j=j+i;\n    }\n  }else{ ; }\n  i = i + 1;\n}\ni=0;\ncount=0;\nwhile(i<MAX+1){\n  if(PRIMES[i]==1){\n    System.out.println(i);\n    count=count+1;\n  }else{;}\n  i=i+1;\n}\nreturn count;}\n\npublic int test(){\n  System.out.println(i);\n  System.out.println(count);\nreturn 42;\n}\n" > test.java
cat -n test.java
cat test.java | ./miniJava
echo "\nThe function 'test' tried to print out 'i' and 'count', \nbut 'i' is a local variable of 'main', so it failed. \nHowever, 'count' is a global variable, so it succeeded."
rm test.java

