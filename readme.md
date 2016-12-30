# MiniJava

# Why Flex & Bison

c 深入学习

单可执行文件

作死 展示an容易

# 除了编译器以外的用途

# shift-reduce conflicts, and reduce-reduce
典型的悬挂else不在miniJava的设计中
运算符的优先级用left token 以及reduce-reduce conflicts有限满足先定义的规则(正如书上提到的)


# 错误提示 (语法)
* 在flex文件中，使用line_num和column_num来记录推导过程。
* 在bison文件中，使用yyerror函数报错，输出错误信息，并使用yytext获取当前处理中的token


# 错误提示 (语义)

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
