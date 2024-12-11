import ecdsa
import random
import hashlib
import base58
from hashlib import sha256


def create_seed():
    return ''.join(random.sample('abcdefghijklmnopqrstuvwxyz!@#$%^&*()', 32)).encode()


def create_private_key(seed):
    return ecdsa.SigningKey.from_string(seed, curve=ecdsa.SECP256k1).to_pem()


def create_public_key(private_key):
    return ecdsa.SigningKey.from_pem(private_key).verifying_key.to_pem()


def create_account():
    new_seed = create_seed()
    private_key_pem = create_private_key(new_seed)
    public_key_pem = create_public_key(private_key_pem)
    in_public_key = ecdsa.VerifyingKey.from_pem(public_key_pem).to_string()
    intermediate = hashlib.sha256(in_public_key).digest()
    ripemd160 = hashlib.new('ripemd160')
    ripemd160.update(intermediate)
    hash160 = ripemd160.digest()
    double_hash = hashlib.sha256(hashlib.sha256(hash160).digest()).digest()
    checksum = double_hash[:4]
    pre_address = hash160 + checksum
    address = base58.b58encode(pre_address)
    print(f"生成地址是: {address.decode()}")
    return {
        'address': address.decode(),
        'private_key': private_key_pem.decode(),
        'public_key': public_key_pem.decode()
    }


def sha256d(string):
    if not isinstance(string, bytes):
        string = string.encode()
    return sha256(sha256(string).digest()).hexdigest()


def data_sign(data, private_key):
    if not isinstance(data, bytes):
        data = data.encode()
    sk = ecdsa.SigningKey.from_pem(private_key)
    sig = sk.sign(data)
    return sig


def data_verify(data, sig, public_key):
    if not isinstance(data, bytes):
        data = data.encode()
    vk = ecdsa.VerifyingKey.from_pem(public_key)
    try:
        if vk.verify(sig, data):
            return 0
        else:
            return 1
    except Exception as e:
        print(e)
        return 2
