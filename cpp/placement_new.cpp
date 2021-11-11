
// https://zhuanlan.zhihu.com/p/228001107

#include <iostream>
using namespace std;

class A {
public:
    A()
    {
        cout << "A's constructor" << endl;
    }

    ~A()
    {
        cout << "A's destructor" << endl;
    }

    void show()
    {
        cout << "num:" << num << endl;
    }

private:
    int num;
};

int main()
{
    /*
    char mem[100];
    mem[0] = 'A';
    mem[1] = '\0';
    mem[2] = '\0';
    mem[3] = '\0';
    cout << (void*)mem << endl;
    A* p = new (mem) A;
    cout << p << endl;
    p->show();
    p->~A();
    */
    void* mem = malloc(sizeof(A));
    A* p = new (mem) A;
    cout << p << endl;
    p->show();
    //p->~A();
    delete p; // TODO: require CXXABI_1.3.9
    //double free or corruption (fasttop)
    free(p);
    //delete mem;
    //free(A);
}
