<table>
  <tr>
    <th>网络模式</th>
    <th>指定方式</th>
    <th>解释</th>
  </tr>
  <tr>
    <td>bridge</td>
    <td>--network bridge指定，默认使用docker0</td>
    <td>桥接模式链接宿主机，通过虚拟出来的docker0作为网桥链接物理网卡，也可以使用docker network create --subnet=172.18.0.0/16 docker1创建新的网桥使用。</td>
  </tr>
  <tr>
    <td>host</td>
    <td>--network host指定</td>
    <td>主机模式链接宿主机，通过和宿主机共享同一物理网卡链接，自身不在配置IP，这种模式无法做到网络端口映射。</td>
  </tr>
  <tr>
    <td>none</td>
    <td>--network none指定</td>
    <td>none模式，禁用网络功能，这个Docker容器不存在网卡，IP等信息。不能和其它容器或宿主机进行通信。</td>
  </tr>
  <tr>
    <td>container</td>
    <td>--network container:NAME或者容器ID</td>
    <td>container模式，同其它容器共享网络，MAC地址和ip一样。</td>
  </tr>
</table>