set  -x
make
echo "class Prime{\n  static int count;\n  public static void main(String[] args){\n    int MAX;\n    int[] PRIMES;\n    int i;\n    int j;\n    MAX = 20;\n    PRIMES = new int[MAX+1];\n    i = 0;\n    while(i<MAX+1){\n      PRIMES[i]=1;\n      i=i+1;\n    }\n    PRIMES[0] = 0;\n    PRIMES[1] = 0;\n    i=1;\n    while(i<MAX+1){\n      if(PRIMES[i]==1){\n        j=i*2;\n        while(j<MAX+1){\n          PRIMES[j]=0;\n          j=j+i;\n        }\n      }else{ ; }\n      i = i + 1;\n    }\n    i=0;\n    count=0;\n    while(i<MAX+1){\n      if(PRIMES[i]==1){\n        System.out.println(i);\n        count=count+1;\n      }else{;}\n      i=i+1;\n    }\n  }\n\n  public int test(){\n    System.out.println(i);\n    System.out.println(count);\n    return 42;\n  }\n}\n\n" > Prime.java
cat -n Prime.java
./miniJava -r Prime.java
echo "\nThe function 'test' tried to print out 'i' and 'count', \nbut 'i' is a local variable of 'main', so it failed. \nHowever, 'count' is a global variable, so it succeeded."
#rm Prime.java

