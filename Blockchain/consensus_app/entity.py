import models
# 用于创建节点和网络实体
peer0 = models.Peer('peer0')
peer1 = models.Peer('peer1')
peer2 = models.Peer('peer2')
peer3 = models.Peer('peer3')
peer4 = models.Peer('peer4')
peer_list = [peer0, peer1, peer2, peer3, peer4]
blockchain = models.Blockchain()