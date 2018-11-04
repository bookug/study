简单好用的标记语言，但不同编辑器对其支持的程度不一样，比如markdownpad2不支持
```
test
```
这种用法，github markdown 不支持 [TOC] 这种用法。

比较推荐使用 typora 编辑器，可以即时预览，也可以导出pdf或html。
最重要的是它是跨平台的！
typora不采用双栏的形式(一边是md源码，一边是预览)，而是直接在一个文件中，直接预览和编辑。
这跟texmacs和texstudio等latex编辑器的不同是一样的。

---

原生支持 html语言，更多的功能可以直接用html语法，不同编辑器对有些功能可能实现不同，此时也最好用html语法来代替。

比如注释功能最好用  <!-- test -->

目录功能可以用页内跳转来实现，即使用 <span id="test">xxx</span> 和 [xxx](#test) 配套。

---

git pages 可以使用jekyll 从markdown直接生成html网页，这个渲染过程是在服务器端完成的。

或者也可以考虑用hexo在本地从markdown生成网页，这在一些复杂的网站中比较常用，jekyll支持的github pages则更适合一些简单的博客网站。

