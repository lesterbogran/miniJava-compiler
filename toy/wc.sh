set -x
flex -o wc.yy.c wc.l
g++ -o wc wc.yy.c -lfl
cat ./wc.l | ./wc
wc ./wc.l
