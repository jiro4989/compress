import unittest
from sequtils import repeat

include compress/lz77

suite "getTheLongestMatched":
  test "normal":
    check @[6'u8, 1'u8, 1'u8, 2'u8, 5'u8].getTheLongestMatched(@[1'u8, 1'u8, 2'u8, 1'u8, 3'u8], 0) == @[1'u8, 1'u8, 2'u8]