set  -x
make
echo "A=1+2*7/8-6;\nB=A-3+4;\nA=new int[10/3+2];\nC=9/A[7];\nwhile(B>1){if((B/2)*2==B)B=B/2;else B=B*3+1;}\n" > test.java
cat test.java
cat test.java | ./miniJava
rm test.java

