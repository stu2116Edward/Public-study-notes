import services
import models
# 用于创建节点和网络实体
peer0 = models.Peer('peer0', 'localhost', 5000)
peer1 = models.Peer('peer1', 'localhost', 5001)
peer2 = models.Peer('peer2', 'localhost', 5002)
peer3 = models.Peer('peer3', 'localhost', 5003)
peer4 = models.Peer('peer4', 'localhost', 5004)
peer_list = [peer0, peer1, peer2, peer3, peer4]
network = services.generate_network('test', peer_list)