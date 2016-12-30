set  -x
make
echo "a=new int[100];\na[0]=1;\na[1]=1;\ni=2;\nSystem.out.println(1);\nSystem.out.println(1);\nwhile(i<20){\n  a[i]=a[i-1]+a[i-2];\n  System.out.println(a[i]);\n  i=i+1;\n}\n" > test.java
cat -n test.java
cat test.java | ./miniJava
rm test.java


