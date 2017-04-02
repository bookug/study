/*=============================================================================
# Filename: simple-guile.c
# Author: Bookug Lobert 
# Mail: zengli-bookug@pku.edu.cn
# Last Modified: 2016-03-31 14:10
# Description: link guile into own programs
=============================================================================*/

#include <stdlib.h>
//QUERY:how about the position of headers
/*#include <guile/2.0/libguile.h>*/
#include <libguile.h>

//to compile the program:
//gcc -o simple-guile simple-guile.c  `pkg-config --cflags --libs guile-2.0`
//all commands inn guile are supported, so does the my_hostname

static SCM

my_hostname(void)
{
	char *s = getenv("HOSTNAME");
	if (s == NULL)
	{
		return SCM_BOOL_F;
	}
	else
	{
		return scm_from_locale_string (s);
	}
}

static void
inner_main (void *data, int argc, char **argv)
{
	scm_c_define_gsubr ("my-hostname", 0, 0, 0, my_hostname);
	scm_shell (argc, argv);
}

int
main (int argc, char **argv)
{
	scm_boot_guile (argc, argv, inner_main, 0);
	return 0; //never reached
}

