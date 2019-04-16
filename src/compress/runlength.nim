## See also
## ========
## * `連超圧縮 (ランレングス法) - Wikipedia <https://ja.wikipedia.org/wiki/%E9%80%A3%E9%95%B7%E5%9C%A7%E7%B8%AE>`_

import unicode
from sequtils import repeat, concat
from strutils import join, parseInt

proc encode*(s: string): string =
  let runes = s.toRunes
  var continuumLen = 1
  for i, r in runes:
    let i2 = i + 1
    if runes.len <= i2:
      result.add $continuumLen & $r
      break

    let nextRune = runes[i2]
    if r == nextRune:
      inc(continuumLen)
      continue
    result.add $continuumLen & $r
    continuumLen = 1

proc encode*(bs: seq[byte]): seq[byte] =
  var continuumLen = 1
  for i, r in bs:
    let i2 = i + 1
    if bs.len <= i2:
      while 255 < continuumLen:
        result.add 255'u8
        result.add r
        continuumLen.dec 255
      result.add continuumLen.byte
      result.add r
      break 
    let nextRune = bs[i2]
    if r == nextRune:
      inc(continuumLen)
      continue

    while 255 < continuumLen:
      result.add 255'u8
      result.add r
      continuumLen.dec 255
    result.add continuumLen.byte
    result.add r
    continuumLen = 1

proc decode*(s: string): string =
  let runes = s.toRunes
  var num: string
  for i, v in runes:
    let c = $v
    if c in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
      num.add c
    else:
      let cnt = num.parseInt
      result.add c.repeat(cnt).join("")
      num = ""

proc decode*(bs: seq[byte]): seq[byte] =
  var cnt: int
  for i, v in bs:
    if i mod 2 == 0:
      # v is counter byte.
      cnt = v.int
    else:
      # v is character byte.
      result = result.concat(v.repeat(cnt))
