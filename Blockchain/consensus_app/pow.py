def generate_target(difficult_bits):
    exponent = int(difficult_bits / 16 ** 6)
    coefficient = int(difficult_bits % 16 ** 6)
    print(f'exponent is {hex(exponent)}')
    print(f'coefficient is {hex(coefficient)}')
    target = coefficient * 2 ** (8 * (exponent - 0x03))
    print(f'target is {target}')
    target_hex = hex(target)[2:].zfill(64)
    print(f'target_hex is {target_hex}')
    return target

def pow_alg(block):
    difficult_bits = block.difficult_bits
    target = generate_target(difficult_bits)

    for n in range(2 ** 32):
        block.nonce = block.nonce + n
        block.calc_block_hash()
        if int(block.block_hash, 16) < target:
            print(f'{"*" * 20}完成计算！{"*" * 20}')
            print(f'总共计算了: {block.nonce} 次')
            print(f'target hex值为: {hex(target)[2:].zfill(64)}')
            print(f'区块哈希值为: {hex(int(block.block_hash, 16))[2:].zfill(64)}')

            return block
