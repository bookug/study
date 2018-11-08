NFS是Network File System的缩写及网络文件系统。

主要功能是通过局域网络让不同的主机系统之间可以共享文件或目录。

NFS系统和Windows网络共享、网络驱动器类似, 只不过windows用于局域网, NFS用于企业集群架构中, 如果是大型网站, 会用到更复杂的分布式文件系统FastDFS,glusterfs,HDFS

---

为什么要使用NFS服务进行数据存储

1.实现多台服务器之间数据共享

2.实现多台服务器之间数据的一致

rpc是一个远程过程调用，那么使用nfs必须有rpc服务  `rpcbind` command

---

NFS存储优点

1.NFS文件系统简单易用、方便部署、数据可靠、服务稳定、满足中小企业需求。

2.NFS文件系统内存放的数据都在文件系统之上，所有数据都是能看得见。

NFS存储局限

1.存在单点故障, 如果构建高可用维护麻烦。(web-》nfs()-》backup)

2.NFS数据明文, 并不对数据做任何校验。

3.客户端挂载无需账户密码, 安全性一般(内网使用)

生产应用建议

1.生产场景应将静态数据尽可能往前端推, 减少后端存储压力

2.必须将存储里的静态资源通过CDN缓存(jpg\png\mp4\avi\css\js)

3.如果没有缓存或架构本身历史遗留问题太大, 在多存储也无用

---

使用umount nfs-share卸载，卸载的时候如果提示”umount.nfs: /data: device is busy” 

1.切换至其他目录, 然后在进行卸载。

2.NFS宕机, 强制卸载umount -lf /data

https://www.cnblogs.com/zeq912/p/9606105.html

https://blog.csdn.net/starlh35/article/details/79064486

https://blog.csdn.net/wmj2004/article/details/53216011


---

主动分享的这台服务器可以读写这个分享目录，其他服务器只能读，不能写

软链接也可以分享，即便指向的位置不在分享目录中，其他服务器依然可以正常读取



