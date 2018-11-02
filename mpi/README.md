## 安装配置

首先要配置好多机互联，而且要配置免密码登录，省的每次都要密码验证。
比如host1, host2, host3 三台机器，应该分别设置他们的/etc/hosts，把各台机器的ip和hostname都写进去。
（各台机器也要修改hostname，不能用默认的localhost.localdomain）
另外就是配置ssh免密码登录，这里可直接参考网上教程，可以考虑用ed25519算法而不是rsa算法。

https://www.sohu.com/a/154323745_99901444

配置好免密码登录后，可用ssh host2直接登录另一台机器，默认用户名就是当前的用户名。
如果要更换用户名，可以使用ssh xxx@host2，其中xxx是想使用的用户名。
下面的命令可以拷贝文件，拷贝目录请用scp -r。
也可以指定用户名，另外host2后面的冒号不能省略，否则这会把host2视为当前机器上的一个文件。
```
scp *.c host2:~/
```

mpich uses hydra as scheduler by default, but it can also support slurm.
In the installation position of mpich, `bin/hydra*` is provided, and it will be  automatically run. 

---

## 使用报告

在官方样例中，mpiexec cpi会报错，必须是mpiexec ./cpi 才能找到这个程序。

mpiexec -f machine.conf hostname

NOTICE: machine file can be placed in other places, just use the absolute or relative path of it

-f 和 -n 可以合用，此时开的进程数就是-n指定的，但会分到-f指定的各台机器上，-f指定的配置文件中，总的进程数可能大于实际进程数。

mpi程序必须包含mpi.h头文件，但编译时不必指定这个头文件的目录，也不必将其加入环境变量。
因为我们是用mpicc编译的，mpicc会去寻找。
如果用gcc编译，则会报找不到头文件的错误。

在mpi程序中试图用getchar()使程序暂停(之后可以到各台机器上检查下状态)，结果无法奏效，这应该是有原因的。
可以考虑用sleep，或者mpi是否本身提供了类似功能的函数。

相同程序必须拷贝，所以才需要搭建nfs，把数据都放一个专门的存储节点，或者说io节点上。
集群有多个登录节点以保证负载均衡，然后又专门的配置较高的计算节点。

如果不用nfs，多台机器上的程序和数据必须位于相同的路径，如果一个程序发生变动，必须把多台机器上的代码都更新一次，并全部重新编译！
否则使用mpiexec的时候，可能会报错，整个流程非常麻烦！
使用nfs要注意网络延迟一定要低，最好集群在同一个局域网内，通过高速网线连接，另外就是磁盘IO要尽可能快。
如果各台机器环境配置完全一样，也可以把各台机器的mpi安装目录共享，这样就只需要安装一次即可。

客户端机器需要挂载这个nfs目录，但是这样重启后是会失效的，不会自动挂载。
如果要做到自动挂载，应该把挂载目录写入fstab，但这样如果网络或节点出现问题，挂载就会无法成功导致机器无法正常启动。

---

mpich is different from openmpi

默认情况下mpi会把当前节点加入任务的节点列表，如果不希望使用当前节点，可以加上-nolocal选项


---

## mpich

http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1-installguide.pdf

http://www.mpich.org/downloads/

---

## openmpi

installation is in FAQ  build

https://www.open-mpi.org/software/ompi/v3.1/


