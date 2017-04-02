"learn vim script here
"series of essays
"http://blog.csdn.net/smstong/article/details/20475223

"WARN:not override the builtin command!
"
"NOTICE:commands defined in a buffer are not ok in another buffer
"Self-define commands can call builtin or self-defined functions
"Not only in interact mode, but also in configure file or plugins

":command for command-line mode
":map for other modes

"this is for shortcuts in insert mode
"NOTICE:not good to define command in insert mode, please use in normal mode
:imap tks thanks
"the definition is recursive and vim can detect the endless-loop
"below is not recursive
:inoremap #icd include
"below is in norma mode
:nmap <F2>ohello<Esc>
"10<F2>

"principle: command name leftmost longest
"imap a oneA
"imap aa twoA
"aa for twoA
"WARN:not good to use prefix in commands, which will slow down the speed of vim

"special keys: F1-F12 Ctrl Alt Enter
"<F1> ... <F12> <Esc> <CR> <C-x> <C-q> <tab> <s-tab> <C-Esc> <S-F1>
"<M-key> <A-key> for alt key
"<Nop> for empty operation
"use :h key-notation to see details

"see mappings: :map :map! :imap :vmap :omap :nmap
":unmap <F10>    :iunmap :nunmap
":mapclear to remove all, including the system definition
":imapclear :nmapclear
"set pastetoggle=<F9>

"NOTICE:the syntax of config files and vim scripts are just the same, divided
"into different functions
"nmap <F10> ggODate:<Esc>:read !date<CR>kJ$  

"Below are for basic idea of vim scripts, similar to PHP and Javascript, but
"only run in vim platform
"Notice that we can also use python or perl to write vim extensions
"http://blog.csdn.net/smstong/article/details/20724191
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"interact mode
:echo 'Hello, world!'
"file mode, wrote in a file i.e. hello.vim
:source hello.vim
"types
echo type(1)
echo type('hello')
echo type(function("getline"))
echo type([1,2])
echo type({})
echo type(1.1)

"variable
let age = 29
let my{age} = "hello"
"echo my2
unlet age

"examples
let n1 = 23
let n2 = -23
let n3 = 012
let n4 = 0x12
let n5 = n1 + 1
let f1 = 0.23
let f2 = 1.02E12
"support transfered meaning
let s1 = "Hello" 
"not support transfered meaning
let s2 = 'Hello' 
let s3 = s1 . s2
let list1 = [1,2,3,5]
let list2 = [1, 'hello', 34.3, [1,2]]
let dict1 = {'name':'zhangsan', 'age':18, 'sex':'male', 'score':89.2}
echo n1
echo n2
echo n3
echo n4
echo n5
echo f1
echo f2
echo s1
echo s2
echo s3
echo list1
echo list2
echo dict1

"auto type transform
let v1 = 'hello' + 23
let v2 = 'hello' . 23
let v3 = '23fs' + 2
let v4 = 'h23f' + 2
"3.4 will be transfered to number not float, use str2float("3.4") to do so
let v5 = "3.4" + 23.3
let v6 = 23.3 + 4
echo v1
echo v2
echo v3
echo v4
echo v5
echo v6
"let s = 'hello' . 23.3
"when containg both number and float, number will be transfered to float

"VimScript is not complete dynamic-typed programming language
"below are wrong because only number and string can be transfered dynamicly
"let a = 2
"let a = 'hello'
"let a = 23.3
"
"below are right, the var name is the same but not the same var
let a = 2
let a = 'hello'
unlet a
let a = 2.2

"conditional statement
let a = 2
let b = 1
if(a > b)
	echo "a>b"
else
	echo "a<=b"
endif
"""""""""""""""""""""""""""""""""""
let score = 87.2
if(score >= 60)
	echo "pass"
endif
"""""""""""""""""""""""""""""""""""
if(score > 90)
	echo "good"
elseif(score >= 60)
	echo "pass"
else 
	echo "fail"
endif
"string->int, no boolean value, here is 0
if("true")
	echo "true"
else
	echo "false"
endif
"""""""""""""""""""""""""""""""""""""""
let a = 80
let result = a > 60 ? 'pass' : 'fail'
echo result
"not support switch-case

"Loop: while and for-in. no support for do-while
let i = 100
let sum = 0
while i > 0
	let sum += i
	let i -= 1
endwhile
echo sum
"NOTICE:not support ++ and --
let sum = 0
for i in range(1,100)
	let sum += i
endfor
echo sum
"use continue and break just as in C

"FuncRef
call search("Date: ", "W")  
"if using return value
let line = getline(".")
let repl = substitute(line, '\a', "*", "g")
"pos of the cursor
call setline(".", repl)
"self-define function, the first letter must be Captical to avoid conflict
"with builtin commands
function Min(num1, num2)
	if a:num1 < a:num2
		let smaller = a:num1
	else
		let smaller = a:num2
	endif
	return smaller
endfunction
echo Min(23,24)
"a: is used to indicate that this is a parameter
"function name is in global area, which can be used in all scripts
let local = 10
function MyFunc()
	echo g:local
endfunction
"these prefix only focus on variable name, not function name
"s:name -- in this file
"b:name -- in this buffer
"w:name -- in this window
"g:name -- global area, var out of function
"v:name -- vim defined var, different with vim option var
"I:name -- local var inside function
"special namespace
"environment variable
echo $HOME
echo $VIM
echo $VIMRUNTIME
echo $notexist
echo type($HOME)
echo type($notexist)
"option variable: begin with & (global, buffer, window) set setlocal
set number
set nu
set tabstop = 4
let &number = 1
let &tabstop = 4
"register variable: begin with @ (working area)
:reg
"read and set register content
echo @"
let @/ = "hello"
echo type(@/)
echo type(@_)

"Vim API: nearly 300 functions
"do not achieve similar functions, because builtinn functions are much
"faster(written in C, compiled into binary code)
"String Operation
echo nr2char(65)
echo char2nr('ABC')
echo str2nr('0x12', 16)
echo str2nr('0x12')
echo str2float('23.212')
echo printf('%d, %s, %f', 10, 'zhangsan', 98.3)
let str = "Hello, VimScript!"
echo tolower(str)
echo toupper(str)
echo tr(str, 'eo', 'EO')
echo escape(str, 'Vim')
echo shellescape(str)
echo fnameescape('/usr/share/file name.txt')
let str = nr2char(10)
echo strtrans(str)
let pat = "V.m"
echo match(str, pat)
echo matchend(str, pat)
echo matchstr(str, pat)
echo matchlist(str, pat)
let str = "Hello, VimScript!"
echo stridx(str, 'i')
echo strridx(str, 'i')
echo strlen(str)
echo substitute(str, 'Vim', 'VIM', "")
echo strpart(str, 3, 2)
let str = "%"
echo expand(str)
let str = 'zhangsan'
echo strlen(str)
echo strlen(iconv(str, 'UTF-8', 'latin1'))
echo byteidx(str, 1)
echo repeat(str, 3)
unlet! v
let str = string([1,2,3])
let v = eval(str)
echo str
echo type(v)
unlet v
let str = string(2.338)
let v = eval(str)
echo str
echo type(v)
unlet v
let str = string('hello')
let v = eval(str)
echo str
echo type(v)
"List Operation
"http://blog.csdn.net/smstong/article/details/20831813
"
"Dictionary Operation
"http://blog.csdn.net/smstong/article/details/20835823
"
"Float Operation
"http://blog.csdn.net/smstong/article/details/20837591
"
"Variable Operation
"http://blog.csdn.net/smstong/article/details/20839991
"


