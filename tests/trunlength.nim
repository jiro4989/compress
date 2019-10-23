import unittest
from sequtils import repeat

include compress/runlength

suite "encode byte":
  test "normal":
    doAssert @[0'u8].encode == @[0'u8, 1]
    doAssert @[64'u8, 64, 64, 64, 63, 63].encode == @[64'u8, 4, 63, 2]
  test "character length is over 255":
    doAssert 0'u8.repeat(255).encode == @[0'u8, 255]
    doAssert 0'u8.repeat(256).encode == @[0'u8, 255, 0, 1]
    doAssert 0'u8.repeat(257).encode == @[0'u8, 255, 0, 2]
    doAssert 0'u8.repeat(511).encode == @[0'u8, 255, 0, 255, 0, 1]
    doAssert 0'u8.repeat(766).encode == @[0'u8, 255, 0, 255, 0, 255, 0, 1]

suite "decode byte":
  test "normal":
    doAssert @[0'u8] == @[0'u8, 1].decode
    doAssert @[64'u8, 64, 64, 64, 63, 63] == @[64'u8, 4, 63, 2].decode
  test "character length is over 255":
    doAssert 0'u8.repeat(255) == @[0'u8, 255].decode
    doAssert 0'u8.repeat(256) == @[0'u8, 255, 0, 1].decode
    doAssert 0'u8.repeat(257) == @[0'u8, 255, 0, 2].decode
    doAssert 0'u8.repeat(511) == @[0'u8, 255, 0, 255, 0, 1].decode
    doAssert 0'u8.repeat(766) == @[0'u8, 255, 0, 255, 0, 255, 0, 1].decode
