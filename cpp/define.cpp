#include <iostream> 
#include <cmath> 

using namespace std;

#define 黄金比 ((1+sqrt(5.0))/2.0)
#define 如果 if
#define 循环 while
#define 输出 cout<<
#define 换行 <<endl
#define 主程序 main()
#define 下取整 floor
#define 否则 else
#define 最大值 max
#define 最小值 min
#define 输入 cin>>
#define 还有 >>
#define 甲 m;
#define 乙 n;
#define 等于 ==

typedef int 整型;

整型 主程序 {
	整型 m,n;
	循环(输入 m 还有 n) {
		如果 (最小值(m,n)==下取整(黄金比*((最大值(m,n)-最小值(m,n)))))
			输出 0 换行;
		否则
			输出 1 换行;
	}
}

