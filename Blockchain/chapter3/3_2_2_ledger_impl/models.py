# -*- coding: utf-8 -*-
import json
import hashlib
from datetime import datetime

INITIAL_BITS = 0x1e777777


# 区块对象
class Block(object):
    def __init__(self, index, prev_hash, data, timestamp, bits):
        """
        区块的初始化方法，在创建一个区块需传入包括索引号等相关信息
        :param index: 区块索引号
        :param prev_hash: 前一区块的哈希值
        :param data: 区块中需保存的记录
        :param timestamp: 区块生成的时间戳
        :param bits: 区块需传入的比特值（预留）
        """
        self.index = index
        self.prev_hash = prev_hash
        self.data = data
        self.timestamp = timestamp
        self.bits = bits
        self.nonce = 0
        self.elapsed_time = ""
        self.block_hash = self.calc_block_hash()

    def to_json(self):
        """
        将区块内容以JSON的形式输出
        :return:
        """
        return {
            "index": self.index,
            "prev_hash": self.prev_hash,
            "data": self.data,
            "timestamp": self.timestamp.strftime('%Y/%m/%d %H:%M:%S'),
            'bits': hex(self.bits)[2:].rjust(8,"0"),
            'nonce': hex(self.nonce)[2:].rjust(8,"0"),
            'block_hash': self.block_hash
        }

    def calc_block_hash(self):
        """
        生成区块对应的哈希值
        :return:
        """
        blockheader = str(self.index) + str(self.prev_hash) \
                      + str(self.data) + str(self.timestamp) + \
                      hex(self.bits)[2:] + str(self.nonce)
        h = hashlib.sha256(blockheader.encode()).hexdigest()
        self.block_hash = h
        return h

# 区块链对象，包括一个以chain为对象的数组
class Blockchain(object):
    def __init__(self):
        """
        初始化区块链对象，操作包括：
        1、定义一个以chain命名的区块链数组
        2、在链中加入创世区块(genesis block)
        """
        self.chain = []
        self.create_genesis_block()
        # self.initial_bits = initial_bits

    def add_block(self, block):
        """
        将新的区块加入区块链chain中,该方法将不被外界调用
        :param block: 新加入的区块
        :return:
        """
        self.chain.append(block)

    def query_block_info(self, index=0):
        """
        通过索引值查询区块链chain中的区块信息
        :param index: 查询区块的索引值
        :return:
        """
        return json.dumps(self.chain[index].to_json(), sort_keys=True, ensure_ascii=False, indent=2)

    def create_genesis_block(self):
        """
        创建创世区块，创世区块内容如下：
        index -> 设置为0，代表第一个区块
        prev_hash -> 设置为64个"0"作为默认参数
        data -> 存储一段字符串
        :return:
        """
        genesis_block = Block(0,
                              "0" * 64,
                              "这是第一个区块（创世区块）",
                              datetime.now(),
                              INITIAL_BITS)
        self.add_block(genesis_block)

    def add_new_block(self, data):
        """
        可供调用的方法，用于添加新的区块
        :param data:
        :return:
        """
        last_block = self.chain[-1]
        # 通过last_block获取chain中的最新区块，从而获取相应的index和prev_hash
        # 用于创建新区块时使用
        block = Block(last_block.index + 1,
                      last_block.block_hash,
                      data, datetime.now(),
                      last_block.bits)
        self.chain.append(block)
        return last_block.index + 1


"""
简单的代码验证
1. 首先创建Blockchain对象
2. 输出对象的创世区块信息
3. 间隔1秒后创建一个新的区块并输出
"""
blockchain = Blockchain()
print(blockchain.query_block_info(0))
from time import sleep
sleep(1)
blockchain.add_new_block("新增的区块")
print(blockchain.query_block_info(1))
