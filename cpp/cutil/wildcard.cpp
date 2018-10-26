#include <stdio.h>
#include <stdlib.h>
#include <string.h>

using namespace std;

class Solution 
{
public:
    /**
     * @param s: A string 
     * @param p: A string includes "?" and "*"
     * @return: A boolean
     */
    bool isMatch(const char *s, const char *p) 
	{
        // write your code here
        int lens, lenp;
        for(lens = 0; s[lens] != '\0'; ++lens);
        for(lenp = 0; p[lenp] != '\0'; ++lenp);
        bool* f = (bool*)malloc(sizeof(bool) * (lenp+1) * (lens+1));
        memset(f, 0, sizeof(bool) * (lens+1) * (lenp+1));
        f[0 * lens + 0] = true;
        int i, j, k;
		int t = lens + 1;
        for(i = 0; i < lenp; ++i)
        {
            for(j = 0; j <= lens; ++j)
            {
				//printf("%d %d\n", i, j);
                if(f[i * t + j] == false)
                    continue;
                if(j < lens && (p[i] == '?' || p[i] == s[j])) //s[j] maybe '\0'
                {
                    f[(i+1) * t + (j+1)] = true;
                }
                else if(p[i] == '*')
                {  
                    for(k = j; k <= lens; ++k)
                        f[(i+1) * t + k] = true;
				    break;
                }
				for(int m = 0; m <= lenp; ++m)
				{
					for(int n = 0; n <= lens; ++n)
					{
						if(f[m * t + n])
							printf("1");
						else
							printf("0");
						printf(" ");
					}
					printf("\n");
				}
				getchar();
				printf("%d %d\n", lenp,lens);
            }
        }
        return f[lenp * t + lens];
    }
};

int 
main(int argc, const char* argv[])
{
	char s[] = "acaabbaccbbacaabbbb";
	char p[] = "a*?*b*?*a*aa*a*";
	Solution sol;
	if(sol.isMatch(s, p))
	{
		printf("matched!\n");
	}
	return 0;
}

