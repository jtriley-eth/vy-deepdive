# Vyper Compiler Deep Dive

## Memory Layout

We use the [Memory Dump Script](src/memory/Memdump.s.sol) to compile the
[Memory Vyper](src/memory/Memory.vy) contract using the Vyper compiler, then inject a memory dump
just before the `return` opcode in the `memdump() -> uint256` function. The memory dump consists of
the three following opcodes (stack-state comments annotated with `;`):

```
msize       ; [memory_size]
push0       ; [memory_offset, memory_offset]
return      ; []
```

We then use log the returned memory to the console. For brevity, we omit the memory layout table,
though annotations can be found in the [Memory Vyper](src/memory/Memory.vy) contract.

### Rules

- the first two words of memory serve as scratchspace for data hashing
- each local variable is written to sequential 32-byte slots in memory
- dynamic types contain one prefix memory slot to indicate length
- elements in dynamic types follow the length slot padded to 32 bytes
  - dynamic `Bytes` arrays tightly pack the bytes and are padded with zeros to fill the last slot
- dynamic type overwrites are duplicated in memory before the final write `(x, y) = (y, x)`

## Storage Layout

We generate a [JSON Storage Layout](src/storage/Storage.layout.json) for the
[Storage Vyper](src/storage/Storage.vy) contract using the Vyper compiler, then further disassemble
the initialization code (contains all storage writes) using the
[Heimdall Decompiler](https://github.com/jon-becker/heimdall-rs) to produce a
[disassembled](src/storage/Disassembled.asm) output.

Given the aforementioned Storage Vyper contract, the storage slots are allocated as follows:

| slot   | variable                              |
| ------ | ------------------------------------- |
| `0x00` | `nonreentrant.lock0`                  |
| `0x01` | `nonreentrant.lock1`                  |
| `0x02` | `self.a`                              |
| `0x03` | `self.b`                              |
| `0x04` | `self.c`                              |
| `0x05` | `self.my_struct.a`                    |
| `0x06` | `self.my_struct.b`                    |
| `0x07` | `self.my_struct.c`                    |
| `0x08` | `self.my_static_uint256_list[0]`      |
| `0x09` | `self.my_static_uint256_list[1]`      |
| `0x0a` | `self.my_static_uint256_list[2]`      |
| `0x0b` | `self.my_static_uint8_list[0]`        |
| `0x0c` | `self.my_static_uint8_list[1]`        |
| `0x0d` | `self.my_static_uint8_list[2]`        |
| `0x0e` | `self.my_static_struct_list[0].a`     |
| `0x0f` | `self.my_static_struct_list[0].b`     |
| `0x10` | `self.my_static_struct_list[0].c`     |
| `0x11` | `self.my_static_struct_list[1].a`     |
| `0x12` | `self.my_static_struct_list[1].b`     |
| `0x13` | `self.my_static_struct_list[1].c`     |
| `0x14` | `self.my_static_struct_list[2].a`     |
| `0x15` | `self.my_static_struct_list[2].b`     |
| `0x16` | `self.my_static_struct_list[2].c`     |
| `0x17` | `len(self.my_dynamic_uint256_list)`   |
| `0x18` | `self.my_dynamic_uint256_list[0]`     |
| `0x19` | `self.my_dynamic_uint256_list[1]`     |
| `0x1a` | `self.my_dynamic_uint256_list[2]`     |
| `0x1b` | `len(self.my_dynamic_uint8_list)`     |
| `0x1c` | `self.my_dynamic_uint8_list[0]`       |
| `0x1d` | `self.my_dynamic_uint8_list[1]`       |
| `0x1e` | `self.my_dynamic_uint8_list[2]`       |
| `0x1f` | `len(self.my_dynamic_struct_list)`    |
| `0x20` | `self.my_dynamic_struct_list[0].a`    |
| `0x21` | `self.my_dynamic_struct_list[0].b`    |
| `0x22` | `self.my_dynamic_struct_list[0].c`    |
| `0x23` | `self.my_dynamic_struct_list[1].a`    |
| `0x24` | `self.my_dynamic_struct_list[1].b`    |
| `0x25` | `self.my_dynamic_struct_list[1].c`    |
| `0x26` | `self.my_dynamic_struct_list[2].a`    |
| `0x27` | `self.my_dynamic_struct_list[2].b`    |
| `0x28` | `self.my_dynamic_struct_list[2].c`    |
| `0x29` | `self.my_mapping`                     |
| `0x2a` | `self.my_dynamic_list_mapping`        |
| `0x2b` | `self.my_dynamic_struct_list_mapping` |
| `0x2c` | `self.my_dynamic_bytes`               |
| `0x2d` | `self.my_long_dynamic_bytes`          |

### Rules

- slots are allocated starting at index 0 and incremeneted for each variable
- `nonreentrant` keys occupy the first `N` slots of storage where `N` is the number of unique keys
- dynamic variables occupy one slot for length and `N` sequential slots where `N` is the maximum capacity
- primitive types are never tightly packed
- structs are never tightly packed
- mappings follow the same slot computation as solc, `keccak256(key . slot)` where `.` is concatenation

## Commands / Script Used

### Storage Layout Generation

Deps:

- Vyper

```bash
vyper src/storage/Storage.vy > src/storage/Storage.layout.json
```

### Storage Disassembly

Deps:

- [Vyper](https://github.com/vyperlang/vyper)
- [Heimdall](https://github.com/jon-becker/heimdall-rs)

```bash
heimdall disassemble $(vyper src/storage/Storage.vy) -o storage/ && rm src/storage/bytecode.evm
```

### Memory Dump Injection

Deps:

- [Vyper](https://github.com/vyperlang/vyper)
- [Foundry](https://github.com/foundry-rs/foundry)

```bash
forge script src/memory/Memdump.s.sol --ffi
```

### Bytes IR Generation

Deps:

- [Vyper](https://github.com/vyperlang/vyper)

```bash
vyper -f ir src/memory/Bytes.vy > src/memory/Bytes.ir
```

### Bytes Debugger

Deps:

- [Vyper](https://github.com/vyperlang/vyper)
- [Foundry](https://github.com/foundry-rs/foundry)

```bash
forge script src/memory/DebugBytes.s.sol --ffi --debug
```
