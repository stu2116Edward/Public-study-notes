import models
from time import sleep

blockchain = models.Blockchain()

print(blockchain.query_block_info(0))
sleep(1)
blockchain.add_new_block("新增的区块")
print(blockchain.query_block_info(1))