/*=============================================================================
# Filename: extension.c
# Author: Bookug Lobert 
# Mail: zengli-bookug@pku.edu.cn
# Last Modified: 2016-03-31 14:10
# Description: a simple extension for Guile
=============================================================================*/

//to compile the program:
//This C source file needs to be compiled into a shared library. Here is how to do it on GNU/Linux:
//gcc ‘pkg-config --cflags guile-2.0‘ -shared -o libguile-bessel.so -fPIC extension.c

#include <math.h>
#include <libguile.h>

SCM
j0_wrapper (SCM x)
{
	return scm_from_double (j0 (scm_to_double (x)));
}

void
init_bessel ()
{
	scm_c_define_gsubr ("j0", 1, 0, 0, j0_wrapper);
}

