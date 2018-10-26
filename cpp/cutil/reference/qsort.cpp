#include<iostream> 

//another implementations of qsort
int partition(int begin, int end, int a[])
{
	//we select the last ele as divider
	int key = a[end];
	//pos records the position of the empty place
	int pos = begin;
	//pos always <= i, and pos is the <> divider, so if a[i] < key, 
	//exchange a[i] to the space
	for(int i = begin; i < end; ++i)
	{
		if(a[i] < key)
		{
			if(pos != i)
			{
				a[pos] = a[pos]^a[i];
				a[i] = a[pos]^a[i];
				a[pos] = a[pos]^a[i];
			}
			pos++;
		}
	}
	a[end] = a[pos];
	a[pos] = key;
	return pos;
}

void qsort(int begin, int end, int a[])
{
	if(begin < end)
	{
		int p = partition(begin, end, a);
		qsort(begin, p-1, a);
		qsort(p+1, end, a);
	}
}

int main()
{
	return 0;
}

