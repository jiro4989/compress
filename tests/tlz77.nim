import unittest
from sequtils import repeat

include compress/lz77

suite "getTheLongestMatched":
  test "normal":
    check @[6'u8, 1'u8, 1'u8, 2'u8, 5'u8].getTheLongestMatched(@[1'u8, 1'u8, 2'u8, 1'u8, 3'u8], 0) == @[1'u8, 1'u8, 2'u8]
  test "スライドウインドウの長さが精査対象よりも長い":
    check @[6'u8, 1'u8, 1'u8, 2'u8, 5'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8].getTheLongestMatched(@[1'u8, 1'u8, 2'u8, 1'u8, 3'u8], 0) == @[1'u8, 1'u8, 2'u8]
  test "1文字しかマッチしない":
    check @[1'u8, 6'u8].getTheLongestMatched(@[6'u8, 1'u8], 0) == @[6'u8]
  test "最後にマッチする":
    check @[1'u8, 6'u8, 6'u8].getTheLongestMatched(@[6'u8, 6'u8, 1'u8], 0) == @[6'u8, 6'u8]