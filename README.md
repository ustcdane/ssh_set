ssh_set
=======

集群环境下SSH key-gen无密码登陆认证脚本 

功能为让linux之间使用ssh免密码登陆。主要使用ssh-key-gen实现。

1.通过 ssh-key-gen 来创建 public and private keys

2.使用ssh-copy-id复制public key 到远程主机

3.实现了无密码登陆远程主机


把所有文件拷贝到主节点上，设置hosts.conf和slaves.conf，然后执行keygen_master.sh即可。
脚本使用前请确保各节点安装了 ssh,expect

声明：修改自 https://github.com/Beckham007/b_keygen
