# MiniJava

# Why Flex & Bison

c 深入学习

单可执行文件

作死 展示an容易

# 除了编译器以外的用途

# shift-reduce conflicts, and reduce-reduce
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

* 运算符的优先级用left token 以及reduce-reduce conflicts有限满足先定义的规则(正如书上提到的)


# 错误提示 (语法)
* 在flex文件中，使用line_num和column_num来记录推导过程。
* 在bison文件中，使用yyerror函数报错，输出错误信息，并使用yytext获取当前处理中的token


# 错误提示 (语义)
## 变量字典
如下的设计，可以方便的控制变量的作用域，在调用变量时，先在本地寻找，找不到时逐级访问上级字典.
```
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

# 难点
写cpp的时候容易把node的class和数据类型的class弄混
Statement ::= "{" (Statement)* "}" 无法直接在Bison中实现，因为对应到C代码时无法自动为(...)*指定数据类型3
由于C语言的灵活性，从Github上看，Bison的定义文件有很多种写法，但都非常不优雅(截图)，我试图采用OO的方法把Parser写的更加清晰

# reference

* [The MiniJava Project](http://www.cambridge.org/us/features/052182060X/)

* [flex与bison](https://book.douban.com/subject/6109479/)

* [Flex and Bison](http://aquamentus.com/flex_bison.html)

* [Building Abstract Syntax Trees ](http://web.eecs.utk.edu/~bvz/teaching/cs461Sp11/notes/parse_tree/)

# author

me@qzane.com
