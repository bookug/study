#include <iostream>
#include <memory>

using namespace std;

int main(int argc, char* argv[])
{
    /*
    int* p = new int[3]{ 1, 2, 3 }; // possible error, should only a int like new int(3)
    unique_ptr<int> up(p);
    int* it = up.get();
    cout << it[1] << endl; // valid
    cout << p[1] << endl;  // valid
    //up = nullptr;
    //cout << p[1] << endl;   // invalid read
    //delete[] p;
    up = make_unique<int>(3); // require C++ 14
    //cout << p[1] << endl;     // invalid read
    cout << *up << endl; // valid, up is a pointer to an int
    */

    unique_ptr<int[]> upArr(new int[2]{ 8, 9 });
    upArr[0] = 1;
    cout << upArr[0] << endl;

    return 0;
}
