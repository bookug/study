/*=============================================================================
# Filename: Y-combinator.c
# Author: syzz
# Mail: 1181955272@qq.com
# Last Modified: 2015-05-20 16:39
# Description: simulate Y combinator in C
=============================================================================*/

#include <stdio.h>
#include <stdlib.h>
 
//func: our one and only data type. 
//It holds either a pointer to a function call, or an integer.  
//Also carry a func pointer to a potential parameter, to simulate closure                   

typedef struct func_t *func;
typedef struct func_t
{
	func (*func) (func, func), _;
	int num;
}func_t;

func 
new(func(*f)(func, func), func _)//build a func struct: function pointer, potential parameter
{
	func x = malloc(sizeof(func_t));
	x->func = f;
	x->_ = _;		//closure, sort of
	x->num = 0;
	return x;
}

func 
call(func f, func g)		//call recursively, execute and get result
{
	return f->func(f, g);
}

func 
Y(func(*f)(func, func))		//simulate the action as Y do in ocaml
{
	func _(func x, func y)
	{
		return call(x->_, y);
	}
	func_t __ = { _ };
	func g = call(new(f, 0), &__);
	g->_ = g;
	return g;
}

func 
num(int n)					//change numeric value to func type	
{
	func x = new(0, 0);
	x->num = n;
	return x;
}

func 
fac(func f, func _null)		//simulate the fac function in recursive type
{
	func _(func self, func n)
	{
		int nn = n->num;
		return nn > 1 ?num(nn * call(self->_, num(nn - 1))->num) :num(1);
	}
	return new(_, f);
}

func 
fib(func f, func _null)		//simulate the fib function in recursive type
{
	func _(func self, func n)
	{
		int nn = n->num;
		return nn > 1
			?num(call(self->_, num(nn - 1))->num + call(self->_, num(nn - 2))->num)
			:num(1);
	}
	return new(_, f);
}

void 
show(func n)		//show the numeric value in func
{
	printf(" %d", n->num);
}

int 
main(int argc, const char* argv[])
{
	int i;
	//test the fac function
	func f = Y(fac);
	printf("fac: ");
	for(i = 0; i < 10; ++i)
	{
		show(call(f, num(i)));
	}
	printf("\n");

	//test the fib function
	f = Y(fib);
	printf("fib: ");
	for(i = 0; i < 10; ++i)
		show(call(f, num(i)));
	printf("\n");

	return 0;
}

