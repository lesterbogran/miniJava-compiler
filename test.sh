set  -x
make
echo "A=1+2*7/8-6;\nB=A-3+4;\nC=9/A[7];\nwhile(B>A){B=B-A/2;}\n" > test.java
cat test.java | ./miniJava


