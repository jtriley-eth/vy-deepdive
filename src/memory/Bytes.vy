# @version 0.3.7

# memory layout:
# 0000000000000000000000000000000000000000000000000000000000000000
# 0000000000000000000000000000000000000000000000000000000000000000
# 0000000000000000000000000000000000000000000000000000000000000004
# 0001020300000000000000000000000000000000000000000000000000000000
# 0000000000000000000000000000000000000000000000000000000000000004
# 0405060700000000000000000000000000000000000000000000000000000000
# 0000000000000000000000000000000000000000000000000000000000000021
# 08090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f2021222324252627
# 2800000000000000000000000000000000000000000000000000000000000000
# 0000000000000000000000000000000000000000000000000000000000000001
# 08090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f2021222324252627
# 2800000000000000000000000000000000000000000000000000000000000000

@external
@pure
def memdump() -> uint256:
    a: DynArray[uint256, 4] = [0, 1, 2, 3]
    # a: Bytes[4] = b'\x00\x01\x02\x03'
    # b: Bytes[4] = b'\x04\x05\x06\x07'
    # c: Bytes[33] = b'\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28'
    return 1