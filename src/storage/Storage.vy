# @version 0.3.7

struct MyStruct:
    a: uint8
    b: uint8
    c: uint256

a: uint256
b: uint8
c: uint8
my_struct: MyStruct
my_static_uint256_list: uint256[3]
my_static_uint8_list: uint8[3]
my_static_struct_list: MyStruct[3]
my_dynamic_uint256_list: DynArray[uint256, 3]
my_dynamic_uint8_list: DynArray[uint8, 3]
my_dynamic_struct_list: DynArray[MyStruct, 3]
my_mapping: HashMap[uint256, uint256]
my_dynamic_list_mapping: HashMap[uint256, DynArray[uint256, 3]]
my_dynamic_struct_list_mapping: HashMap[uint256, DynArray[MyStruct, 3]]
my_dynamic_bytes: Bytes[2]
my_long_dynamic_bytes: Bytes[40]

@external
def __init__():
    self.a = 1
    self.b = 2
    self.c = 3
    self.my_struct = MyStruct({a: 4, b: 5, c: 6})
    self.my_static_uint256_list = [1, 2, 3]
    self.my_static_uint8_list = [4, 5, 6]
    self.my_static_struct_list = [MyStruct({a: 7, b: 8, c: 9}), MyStruct({a: 10, b: 11, c: 12}), MyStruct({a: 13, b: 14, c: 15})]
    self.my_dynamic_uint256_list = [1, 2, 3]
    self.my_dynamic_uint8_list = [4, 5, 6]
    self.my_dynamic_struct_list = [MyStruct({a: 7, b: 8, c: 9}), MyStruct({a: 10, b: 11, c: 12}), MyStruct({a: 13, b: 14, c: 15})]
    self.my_mapping[1] = 1
    self.my_mapping[2] = 2
    self.my_dynamic_list_mapping[1] = [1, 2, 3]
    self.my_dynamic_list_mapping[2] = [4, 5, 6]
    self.my_dynamic_struct_list_mapping[1] = [MyStruct({a: 7, b: 8, c: 9}), MyStruct({a: 10, b: 11, c: 12}), MyStruct({a: 13, b: 14, c: 15})]
    self.my_dynamic_struct_list_mapping[2] = [MyStruct({a: 16, b: 17, c: 18}), MyStruct({a: 19, b: 20, c: 21}), MyStruct({a: 22, b: 23, c: 24})]
    self.my_dynamic_bytes = b'\x01\x02'
    self.my_long_dynamic_bytes = b'\x01\x02\x03\x04\x05\x06\x07\x08\x09\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x30\x31'

@external
@nonreentrant('lock0')
def my_func() -> uint256:
    return 1

@external
@nonreentrant('lock1')
def my_func2() -> uint256:
    return 2
