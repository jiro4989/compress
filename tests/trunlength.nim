import unittest
from sequtils import repeat

include compress/runlength

suite "encode string":
  test "half characters":
    check "aaaaabbbbbbbbbaaa".encode == "5a9b3a"
  test "multi-byte characters":
    check "ああいうううあいう".encode == "2あ1い3う1あ1い1う"
  test "multi-byte counter":
    check "aaaaaaaaaa".encode == "10a"

suite "encode byte":
  test "normal":
    doAssert @[0'u8].encode == @[1'u8, 0'u8]
    doAssert @[64'u8, 64'u8, 64'u8, 64'u8, 63'u8, 63'u8].encode == @[4'u8, 64'u8, 2'u8, 63'u8]
  test "character length is over 255":
    doAssert 0'u8.repeat(255).encode == @[255'u8, 0'u8]
    doAssert 0'u8.repeat(256).encode == @[255'u8, 0'u8, 1'u8, 0'u8]
    doAssert 0'u8.repeat(257).encode == @[255'u8, 0'u8, 2'u8, 0'u8]
    doAssert 0'u8.repeat(511).encode == @[255'u8, 0'u8, 255'u8, 0'u8, 1'u8, 0'u8]
    doAssert 0'u8.repeat(766).encode == @[255'u8, 0'u8, 255'u8, 0'u8, 255'u8, 0'u8, 1'u8, 0'u8]

suite "decode string":
  test "half characters":
    check "aaaaabbbbbbbbbaaa" == "5a9b3a".decode
  test "multi-byte characters":
    check "ああいうううあいう" == "2あ1い3う1あ1い1う".decode
  test "multi-byte counter":
    check "aaaaaaaaaa" == "10a".decode

suite "decode byte":
  test "normal":
    doAssert @[0'u8] == @[1'u8, 0'u8].decode
    doAssert @[64'u8, 64'u8, 64'u8, 64'u8, 63'u8, 63'u8] == @[4'u8, 64'u8, 2'u8, 63'u8].decode
  test "character length is over 255":
    doAssert 0'u8.repeat(255) == @[255'u8, 0'u8].decode
    doAssert 0'u8.repeat(256) == @[255'u8, 0'u8, 1'u8, 0'u8].decode
    doAssert 0'u8.repeat(257) == @[255'u8, 0'u8, 2'u8, 0'u8].decode
    doAssert 0'u8.repeat(511) == @[255'u8, 0'u8, 255'u8, 0'u8, 1'u8, 0'u8].decode
    doAssert 0'u8.repeat(766) == @[255'u8, 0'u8, 255'u8, 0'u8, 255'u8, 0'u8, 1'u8, 0'u8].decode