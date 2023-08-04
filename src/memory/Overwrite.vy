# @version 0.3.7

@external
@pure
def overwrite(gib: bool) -> uint256:
    a: uint256 = 1

    if gib:
        b: uint256 = 2

    c: uint256[2] = [3, 4]

    d: uint256 = 5

    return d
