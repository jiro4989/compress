import unittest

include compress/lz77

suite "getTheLongestMatched":
  test "normal":
    check @[6'u8, 1'u8, 1'u8, 2'u8, 5'u8].getTheLongestMatched(@[1'u8, 1'u8, 2'u8, 1'u8, 3'u8], 0) == MatchedPos(pos: 1, length: 3)
  test "スライドウインドウの長さが精査対象よりも長い":
    check @[6'u8, 1'u8, 1'u8, 2'u8, 5'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8, 9'u8].getTheLongestMatched(@[1'u8, 1'u8, 2'u8, 1'u8, 3'u8], 0) == MatchedPos(pos: 1, length: 3)
  test "1文字しかマッチしない":
    check @[1'u8, 6'u8].getTheLongestMatched(@[6'u8, 1'u8], 0) == MatchedPos(pos: 1, length: 1)
  test "最後にマッチする":
    check @[1'u8, 6'u8, 6'u8].getTheLongestMatched(@[6'u8, 6'u8, 1'u8], 0) == MatchedPos(pos: 1, length: 2)