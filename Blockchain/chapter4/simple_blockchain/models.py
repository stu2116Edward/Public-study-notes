import json
import hashlib
from datetime import datetime
from crypto_util import data_sign, sha256d
import binascii

INITIAL_BITS = 0x1e777777


d_pk = """-----BEGIN EC PRIVATE KEY-----\nMHQCAQEEIClncSpsc2Fua3ljeiR2aCNydSFkbXQoQHAleGZlYiZqoAcGBSuBBAAK\noUQDQgAEyTx/sAlhdNUOwcfnCjOVp9fxMF6DUwSLkFqj2E6sDFuPVrKF9wVWH8J3\nntxWh+kR3GFKcB48v3eTfElUs5L7Zw==\n-----END EC PRIVATE KEY-----\n"""

class Transaction(object):
    def __init__(self, sender, recipient, data, timestamp, private_key):
        self.sender = sender
        self.recipient = recipient
        self.data = data
        self.timestamp = timestamp
        self.id = sha256d(self.to_string())
        self.sig = data_sign(self.id, private_key)

    def to_string(self):
        return f"{self.sender}{self.recipient}{self.data}{self.timestamp.strftime('%Y/%m/%d %H:%M:%S')}"

    def to_json(self):
        return {
            "id": self.id,
            "sender": self.sender,
            "recipient": self.recipient,
            "data": self.data,
            "timestamp": self.timestamp.strftime('%Y/%m/%d %H:%M:%S'),
            "sig": binascii.hexlify(self.sig).decode(),
        }


class Block(object):
    def __init__(self, index, prev_hash, data, timestamp, bits):
        self.index = index
        self.prev_hash = prev_hash
        self.data = data
        self.timestamp = timestamp
        self.bits = bits
        self.nonce = 0
        self.merkle_root = self.calc_merkle_root()
        self.block_hash = self.calc_block_hash()

    def to_json(self):
        tx_list = [tx.to_json() for tx in self.data]
        return {
            "index": self.index,
            "prev_hash": self.prev_hash,
            "merkle_root": self.merkle_root,
            "data": tx_list,
            "timestamp": self.timestamp.strftime('%Y/%m/%d %H:%M:%S'),
            'bits': hex(self.bits)[2:].rjust(8, "0"),
            'nonce': hex(self.nonce)[2:].rjust(8, "0"),
            'block_hash': self.block_hash
        }

    def calc_merkle_root(self):
        calc_txs = [tx.id for tx in self.data]
        if len(calc_txs) == 1:
            return calc_txs[0]
        while len(calc_txs) > 1:
            if len(calc_txs) % 2 == 1:
                calc_txs.append(calc_txs[-1])
            sub_hash_roots = []
            for i in range(0, len(calc_txs), 2):
                join_str = "".join(calc_txs[i:i+2])
                sub_hash_roots.append(hashlib.sha256(join_str.encode()).hexdigest())
            calc_txs = sub_hash_roots
        return calc_txs[0]

    def calc_block_hash(self):
        blockheader = str(self.index) + str(self.prev_hash) \
                      + str(self.data) + str(self.timestamp) + \
                      hex(self.bits)[2:] + str(self.nonce)
        h = hashlib.sha256(blockheader.encode()).hexdigest()
        self.block_hash = h
        return h


class Blockchain(object):
    def __init__(self):
        self.chain = []
        self.create_genesis_block()

    def add_block(self, block):
        self.chain.append(block)

    def query_block_info(self, index=0):
        block_json = self.chain[index].to_json()
        return block_json

    def create_genesis_block(self):
        tx = Transaction("0" * 32, "0" * 32, "第一笔交易", datetime.now(), d_pk)
        genesis_block = Block(0,
                              "0" * 64,
                              [tx],
                              datetime.now(),
                              INITIAL_BITS)
        self.add_block(genesis_block)

    def add_new_block(self, data):
        last_block = self.chain[-1]
        block = Block(last_block.index + 1,
                      last_block.block_hash,
                      data,
                      datetime.now(),
                      last_block.bits)
        self.chain.append(block)
        return last_block.index + 1


class Peer:
    def __init__(self):
        self.tx_pool = []

    def add_tx(self, tx):
        self.tx_pool.append(tx)

    def clear_pool(self):
        self.tx_pool = []
