import hashlib

DIFFICULT_BITS = 0x1e11ffff

class Block(object):
    def __init__(self, index, prev_hash, data, timestamp, bits):
        self.index = index
        self.prev_hash = prev_hash
        self.data = data
        self.timestamp = timestamp
        self.difficult_bits = bits
        self.nonce = 0
        self.merkle_root = self.calc_merkle_root()
        self.block_hash = self.calc_block_hash()

    def to_json(self):
        return {
            "index": self.index,
            "prev_hash": self.prev_hash,
            "merkle_root": self.merkle_root,
            "data": self.data,
            "timestamp": self.timestamp.strftime('%Y/%m/%d %H:%M:%S'),
            'bits': hex(self.difficult_bits)[2:].rjust(8, "0"),
            'nonce': hex(self.nonce)[2:].rjust(8, "0"),
            'block_hash': self.block_hash
        }

    def calc_merkle_root(self):
        calc_txs = [tx for tx in self.data]
        if len(calc_txs) == 1:
            return calc_txs[0]
        while len(calc_txs) > 1:
            if len(calc_txs) % 2 == 1:
                calc_txs.append(calc_txs[-1])
            sub_hash_roots = []
            for i in range(0, len(calc_txs), 2):
                join_str = "".join(calc_txs[i:i + 2])
                sub_hash_roots.append(hashlib.sha256(join_str.encode()).hexdigest())
            calc_txs = sub_hash_roots
        return calc_txs[0]

    def calc_block_hash(self):
        blockheader = str(self.index) + str(self.prev_hash) \
                      + str(self.data) + str(self.timestamp) + \
                      hex(self.difficult_bits)[2:] + str(self.nonce)
        h = hashlib.sha256(blockheader.encode()).hexdigest()
        self.block_hash = h
        return h

from datetime import datetime
# 区块链对象
class Blockchain(object):
    def __init__(self):
        self.chain = []
        # 用于记录不同节点按index顺序获取区块记账权的信息
        self.peer_block = {}
        self.create_genesis_block()

    def add_block(self, block):
        self.chain.append(block)

    def add_peer_block(self, name, block_index):
        if name in self.peer_block:
            self.peer_block[name].append(block_index)
        else:
            self.peer_block[name] = [block_index]

    def query_peer_block(self,name):
        return self.peer_block[name]

    def query_block_info(self, index=0):
        """
        通过索引值查询区块链chain中的区块信息
        """
        block_json = self.chain[index].to_json()
        return block_json

    def create_genesis_block(self):
        """
        创建创世区块，在这里定义区块难度，这将被之后所有的区块引用
        """
        genesis_block = Block(0, "0" * 64, ["hello world!"], datetime.now(), DIFFICULT_BITS)
        self.add_block(genesis_block)


class Peer:
    def __init__(self, name):
        self.name = name
        self.last_block = 1


import networkx as nx
import matplotlib.pyplot as plt
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
        self.G.add_node(peer.name)

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