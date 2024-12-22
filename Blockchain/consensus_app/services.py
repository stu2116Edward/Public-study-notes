import models
import entity
import pow
from datetime import datetime

def generate_network(network_name, peer_list):
    g_network = models.Network(network_name)
    for index, peer in enumerate(peer_list):
        g_network.add_peer(peer)
        if index == len(peer_list)-1:
            g_network.add_edge(peer.name, peer_list[0].name)
        else:
            g_network.add_edge(peer.name, peer_list[index+1].name)
    return g_network

def exe_pow(data, peer_name):
    last_block = entity.blockchain.chain[-1]
    index = last_block.index + 1
    g_block = models.Block(last_block.index + 1, last_block.prev_hash, data, datetime.now(), last_block.difficult_bits)
    c_block = pow.pow_alg(g_block)

    if len(entity.blockchain.chain) <= index:
        entity.blockchain.add_block(c_block)
        entity.blockchain.add_peer_block(peer_name, index)
    else:
        print(f'区块索引<{index}>，已存在！{peer_name}节点计算失败')
