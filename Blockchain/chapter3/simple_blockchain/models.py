import json
import hashlib
from datetime import datetime

# 目标难度
INITIAL_BITS = 0x1e777777


# 区块对象
class Block(object):
    def __init__(self, index, prev_hash, data, timestamp, bits):
        self.index = index
        self.prev_hash = prev_hash
        self.data = data
        self.timestamp = timestamp
        self.bits = bits
        self.nonce = 0
        self.elapsed_time = ''
        self.block_hash = self.calc_block_hash()

    def calc_block_hash(self):
        blockheader = str(self.index) + str(self.prev_hash) + str(self.data) + str(self.timestamp) + hex(self.bits)[2:] + str(self.nonce)
        h = hashlib.sha256(blockheader.encode()).hexdigest()
        self.block_hash = h
        return h

    def to_json(self):
        return {
            "index": self.index,
            "prev_hash": self.prev_hash,
            "data": self.data,
            "timestamp": self.timestamp.strftime('%Y/%m/%d %H:%M:%S'),
            'bits': hex(self.bits)[2:].rjust(8,'0'),
            'nonce': hex(self.nonce)[2:].rjust(8,'0'),
            'block_hash': self.block_hash
        }

# 区块链对象，包括一个以chain为对象的数组
class Blockchain(object):
    def __init__(self):
        self.chain = []
        self.create_genesis_block()

    def create_genesis_block(self):
        genesis_block = Block(0, "0" * 64, "这是第一个区块（创世区块）", datetime.now(), INITIAL_BITS)
        self.add_block(genesis_block)

    def add_block(self, block):
        self.chain.append(block)

    def add_new_block(self, data):
        last_block = self.chain[-1]
        block = Block(last_block.index + 1, last_block.block_hash, data, datetime.now(), last_block.bits)
        self.chain.append(block)
        return last_block.index + 1

    def query_block_info(self, index=0):
        return json.dumps(self.chain[index].to_json(), sort_keys=True, ensure_ascii=False, indent=2)
