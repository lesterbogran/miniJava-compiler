# MiniJava with Flex and Bison
[MiniJava](http://www.cambridge.org/resources/052182060X/)

# Try it now!
## Windows
1. download 'miniJava.exe', 'Prime.java', 'gloabl_local_test.bat'
2. double click to to run `gloabl_local_test.bat`

## Linux
0. install gcc, flex, bison
1. git clone
2. sh gloabl_local_test.sh

## Install develop tools
### Windows
* [TDM-GCC](http://tdm-gcc.tdragon.net/download)
* [GnuWin32-Flex](http://gnuwin32.sourceforge.net/downlinks/flex.php)
* [GnuWin32-Bison](http://downloads.sourceforge.net/gnuwin32/bison-2.4.1-setup.exe)
* [GnuWin32-make](http://gnuwin32.sourceforge.net/downlinks/make.php)

### Ubuntu
* `sudo apt-get install gcc flex bison`

# 特点
* 内置简化版的解释器，可以直接解释运行部分miniJava程序。
(自带的Prime.java是一个用筛法求素数的程序，顺便演示了变量作用域检查特性)
* 提供带缩进的人性化AST输出(命令行参数-p)
* 源代码和Github上大多数Bison代码比起来结构要清晰的多得多！
(其实很大原因是我用了C++的Class而不是纯C代码)
* 独立可执行文件！独立可执行文件！独立可执行文件！

# Why Flex & Bison
* 作为一个练习C++的机会
* 跨平台，并且能生成单独的可执行文件(如你所见的`miniJava.exe`)
* 比较有成就感？其实就是作死

# 开发中的各种坑

## shift-reduce conflicts, and reduce-reduce
* 典型的悬挂else不在miniJava的设计中(它的语法要求每个if都有else), 
  这避免了一个很常见的shift-reduce conflict， 但是在我的设计中，存在另外一个这种类型的conflict：
  在函数参数的定义中，MiniJava的设计`"(" ( Type Identifier ( "," Type Identifier )* )? ")" `，
  因为','比参数少一个，导致匹配写起来很不优雅，所以在我的设计中
  ```
  vardeclare : minitype ID ';' {{ $$ = new var_declare_node($1, $2); }}
    | ',' minitype ID {{ $$ = new var_declare_node($2, $3); }}
    | minitype ID {{ $$ = new var_declare_node($1, $2); }}
  ```
  同时接受这三种参数定义方法，其中第二和第三种虽然有冲突，但是按照Bison编译器对shift处理有限的原则，
  刚好符合我们的要求，所以这里的冲突是完全安全的。算是利用了编译器这个特性使设计更加优雅了。

* 运算符的优先级用left token 以及reduce-reduce conflicts有限满足先定义的规则

## Bison 不支持直接在BNF里面使用正则表达式(因为会分不清对应的C对象类型), 所以函数的参数表，多行变量的定义都需要自己设计特殊的节点类型。

# 错误提示 (语法)
* 在flex文件中，使用line_num和column_num来记录推导过程。
* 在bison文件中，使用yyerror函数报错，输出错误信息，并使用yytext获取当前处理中的token


# 错误提示 (语义)
## 变量字典
如下的设计，可以方便的控制变量的作用域，在调用变量时，先在本地寻找，找不到时逐级访问上级字典.
``` c
class var_map{
private:
	var_map *m_higher_map;
	map<string, int> m_map;
public:
	var_map(var_map *higher_map = NULL);
	void declare(string id, int val=0);
	void set(string id, int val=0); /// will try to search upward
	int get(string id, int *val);  /// will try to search upward, return -1 if not found, 0 otherwise
};
```
## 作用域的例子
`sh gloabl_local_test.sh`
第一个函数使用晒法计算了20以内素数的个数，第二个函数试图打印第一个函数使用的两个变量。其中第一个是本地变量，所以没有打印成功。而第二个是全局变量，所以打印成功了。



## 自己的问题
写cpp的时候容易把node的class和数据类型的class弄混
Statement ::= "{" (Statement)* "}" 无法直接在Bison中实现，因为对应到C代码时无法自动为(...)*指定数据类型3
由于C语言的灵活性，从Github上看，Bison的定义文件有很多种写法，但都非常不优雅(截图)，我试图采用OO的方法把Parser写的更加清晰

# 待实现的功能
* extends
* 真正的Class实例化

# reference

* [The MiniJava Project](http://www.cambridge.org/us/features/052182060X/)

* [flex与bison](https://book.douban.com/subject/6109479/)

* [Flex and Bison](http://aquamentus.com/flex_bison.html)

* [Building Abstract Syntax Trees ](http://web.eecs.utk.edu/~bvz/teaching/cs461Sp11/notes/parse_tree/)

# author

me@qzane.com
