
etcd：
	etcd的使用,曾经出现的少数派故障。

网络原理：
  overlay
    两个veth网卡，一个veth pair到docker bridge，另一个veth pair到overlay。走bridge，与host打通；另一个走overlay vxlan，与其他容器打通。
  flannel
    一个网卡，veth pair到docker bridge。同主机容器走bridge。其他容器数据从bridge出来之后由flanneld封包。
  calico
    一个网卡，veth pair到宿主机的虚拟网卡cali*。添加路由。
    calico路由学习：
      etcd做路由规则的数据存储,node容器的confd监听bgpPeer配置，更新bird配置，触发bird更新路由。
    calico bgpPeer配置流程：
      1. bgpConfiguration 关闭node-to-node full mesh。
      2. 搭建calico routereflector，修改bird.cfg.template，添加默认物理bird neighbor。
      3. 设置global的bgpPeer指向calico routereflector。

存储：
  glusterfs：
    存储类型：
      1. 分布式卷
      2. 复制卷
      3. 分布式复制卷

    使用场景：
      1. 4节点，两两复制

kubernetes资源概念：

kubernetes运维手册：
  1. 滚动升级
  2. 

