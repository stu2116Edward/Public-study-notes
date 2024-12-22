import networkx as nx
import models
from datetime import datetime
import random
from flask import jsonify
import http_res

def generate_network(network_name, peer_list):
    """
    生成区块链网络，初始化Network实体，以及在Network实体中加入节点(node)和边(node)
    :param network_name: 网络名称
    :param peer_list: 已生成的节点列表
    :return: 生成的区块链网络实体对象
    """
    g_network = models.Network(network_name)
    for index, peer in enumerate(peer_list):
        g_network.add_peer(peer)
        if index == len(peer_list)-1:
            # 如果是最后一个节点，那就让最后一个节点和第一个节点收尾相连
            g_network.add_edge(peer.name, peer_list[0].name)
        else:
            # 否则，建立本节点与下一个节点的边
            g_network.add_edge(peer.name, peer_list[index+1].name)
    return g_network


def new_msg_service(body, c_peer):
    if 'data' not in body:
        return jsonify(http_res.empty_res)
    msg = models.Message(body['data'], datetime.now())
    c_peer.add_message(msg.to_dict())
    c_peer.version = msg.version
    return jsonify(http_res.success_res)

def send_version(peer, network):
    print('start to send version!')
    peer_name = peer.name
    neighbours = list(network.G.adj[peer_name])
    rand_index = random.randint(0, len(neighbours)-1)
    neighbour_peer_name = neighbours[rand_index]
    neighbour_peer = network.G.nodes()[neighbour_peer_name]
    req_url = f"http://{neighbour_peer['host']}:{neighbour_peer['port']}"
    res_url = f"http://{peer.host}:{peer.port}"
    print(f'connect to peer {req_url}')
    peer.sio.connect(req_url)
    send_msg = {
        'version': peer.version,
        'url': res_url
    }
    peer.sio.emit('peer-version', send_msg)
    peer.sio.disconnect()


def peer_version_services(rec_msg, c_peer, sio):
    version = rec_msg['version']
    url = rec_msg['url']
    print(f"receive message : {version}")

    res_arr = []
    send_msg = {}
    if version < c_peer.version:
        for i in range(len(c_peer.pool) - 1, -1, -1):
            get_msg = c_peer.pool[i]
            if version < get_msg['version']:
                res_arr.insert(0, get_msg)

        send_msg = {
            'code': 1,  # 1表示存在数据
            'data': res_arr
        }
    else:
        send_msg = {
            'code': 0,  # 0表示不存在新数据
            'data': 'empty'
        }

    sio.connect(url)
    sio.emit('peer-message', send_msg)
    sio.disconnect()


def peer_message_service(msg_dict, c_peer):
    if 'code' not in msg_dict or 'data' not in msg_dict:
        return
    if msg_dict['code'] == 0:
        return
    if msg_dict['code'] == 1:
        for get_msg in msg_dict['data']:
            msg = models.Message(get_msg['data'],
                                 datetime.strptime(get_msg['c_time'], "%Y-%m-%d %H:%M:%S"))
            c_peer.pool.append(msg.to_dict())

        c_peer.version = msg_dict['data'][-1]['version']



