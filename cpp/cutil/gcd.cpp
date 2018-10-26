/*=============================================================================
# Filename: gcd.cpp
# Author: Bookug Lobert 
# Mail: 1181955272@qq.com
# Last Modified: 2016-10-24 13:30
# Description: 
=============================================================================*/

#include <util.h>

using namespace std;

//BETTER:consider using 3 or other primes? should only use primes?
//How to avoid the cost of % ?

//THINK: the principle is to represent the divider number by remaining number, then the whole can be represent by the 
//final divider when the remaining is 0
//
//1. method of successive division: a%b is too costly (a%b = a - (a/b)*b)
//2. Decreases technique: maybe too many times (100, 1)
//3. combine the two above  and cosnider odd/even
int gcd(int a, int b)
{
	if(a < b)
	{
		//swap: the basic method is using a temporary variable
		//another method is:
		//a=a+b  b=a-b  a=a-b
		//or use bitwise operation like below: 0^x=x 1^x=~x
		b = a^b;
		a = a^b;
		b = a^b; //b^a
	}

	//require that a>=b
	if(b == 0) return a;

	bool odda = (a%2 != 0);
	bool oddb = (b%2 != 0);
	if(odda && oddb)
	{
		return gcd(a-b, b);
	}
	else if(odda && !oddb)
	{
		return gcd(a, b/2);
	}
	else if(!odda && oddb)
	{
		return gcd(a/2, b);
	}
	else //both even
	{
		return 2 * gcd(a/2, b/2);
	}
};

