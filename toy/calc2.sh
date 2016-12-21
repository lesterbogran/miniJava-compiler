set -x
bison -d -o calc2.tab.c calc2.y
flex -o calc2.c calc2.l
g++ -o calc2 calc2.tab.c calc2.c 
./calc2
