## See also
## ========
## * `連超圧縮 (ランレングス法) - Wikipedia <https://ja.wikipedia.org/wiki/%E9%80%A3%E9%95%B7%E5%9C%A7%E7%B8%AE>`_

import unicode
from sequtils import repeat, concat
from strutils import join, parseInt

proc encode*(bs: openArray[byte]): seq[byte] =
  ## 文字列を圧縮して返す。
  ## 圧縮の際の「何文字連続しているか」のカウンタが255(1byte)まで。
  ## 255文字以上連続する場合は、一旦255で文字を区切り、
  ## カウンタを初期化してカウントし直す。
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

proc decode*(bs: openArray[byte]): seq[byte] =
  ## 文字列を解凍して返す。
  ## 圧縮の際の「何文字連続しているか」のカウンタは255以下でなければならない。
  var cnt: int
  for i, v in bs:
    if i mod 2 == 0:
      # v is counter byte.
      cnt = v.int
    else:
      # v is character byte.
      result = result.concat(v.repeat(cnt))
