import networkx as nx
import matplotlib.pyplot as plt
import socketio
# 区块链网络
class Network(object):
    def __init__(self, name):
        """
        初始化区块链网络
        :param name:
        """
        self.peers = []  # 网络中存在的节点
        self.name = name  # 网络名称
        self.G = nx.Graph()  # 网络中定义的networkx网络拓扑

    def add_peer(self, peer):
        """
        在网络中新增节点
        """
        self.peers.append(peer)
        self.G.add_node(peer.name, host=peer.host, port=peer.port)

    def add_edge(self, s_peer, e_peer):
        """
        在网络中新增节点间的边
        """
        e = (s_peer, e_peer)
        self.G.add_edge(*e)

    def del_peer(self, peer_name):
        """
        删除指定名称的peer节点
        """
        for i, peer in enumerate(self.peers):
            if peer_name == peer.name:
                del self.peers[i]
        self.G.remove_node(peer_name)

    def draw_network(self):
        """
        绘制网络
        """
        pos = nx.spring_layout(self.G, iterations=100)
        nx.draw(self.G, pos, with_labels=True)
        plt.show()

# 消息对象
class Message(object):
    def __init__(self, data, c_time):
        self.data = data
        self.c_time = c_time
        self.version = int(c_time.timestamp())

    def to_dict(self):
        return {
            'data': self.data,
            'c_time': self.c_time.strftime("%Y-%m-%d %H:%M:%S"),
            'version': self.version
        }

# 节点对象
class Peer(object):
    def __init__(self, name, host, port):
        self.name = name
        self.host = host
        self.port = port
        self.version = 0
        self.pool = []
        self.sio = socketio.Client()

    def add_message(self, message):
        self.pool.append(message)
