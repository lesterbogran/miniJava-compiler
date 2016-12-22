set  -x
make
echo "idid=1+2/3*(4-5+VAR.length)*VAR{67-8}-9//+32sdf" > test.java
cat test.java | ./miniJava


