set  -x
make
echo "A=1+2*7/8-6;\nB=A-3+4;\nA=new int[10/3+2];\nC=9/A[7];\nwhile(B>1){a=1;while(C<9){C=C+1;}b=2;}\nwhile(B>1){\n  d=1;\n  if((B/2)*2==B)\n    B=B/2;\n  else\n    B=B*3+1;\n}\n" > test.java
cat test.java
cat test.java | ./miniJava
rm test.java

