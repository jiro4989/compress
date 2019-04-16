from sequtils import delete
from algorithm import sort

proc getTheLongestMatched(window, byteSeq: openArray[byte], pos: int): seq[byte] =
  if byteSeq.len < 1:
    return

  # スライドウィンドウ内に、精査対象のシーケンスの先頭の文字が一致する位置を取得
  # 一致するものが一つも存在しないときは早期リターン
  let n = if pos+window.len < byteSeq.len: pos+window.len
          else: byteSeq.len - 1
  let byteSeqPart = byteSeq[pos..<n]
  var startPoses: seq[int]
  block:
    let headByte = byteSeqPart[0]
    for i, v in window:
      if v == headByte:
        startPoses.add i
    if startPoses.len < 1:
      return

  # matched[0] == pos
  # matched[1] == length
  var matched: seq[seq[int]]
  # 一致した位置シーケンスを回し
  # 精査対象と一致し続ける限り、カウンターを増やし続ける
  # 合わなくなったときにwhileを抜けて、次の位置シーケンスを処理
  # ここでmatchedに格納するのはwindows内の一致位置と、マッチし続けた長さである
  for pos in startPoses:
    var i: int
    while true:
      var j = pos + i
      if window.len <= j or window[j] != byteSeqPart[i]:
        matched.add @[pos, i-1]
        break
      i.inc

  # マッチした長さ順でソートし、最大長のものを取得
  matched.sort(proc (x, y: seq[int]): int = cmp(x[1], y[1]))
  let
    l = matched[matched.len-1]
    pos = l[0]
    length = l[1]
  ## TODO 一致した位置と長さを返すようにしないといけない
  result = window[pos..pos+length]

proc encode*(byteSeq: openArray[byte], windowSize: int = 8124): seq[byte] =
  ## 位置文字ずつ精査し、Windowサイズ内に同じ文字が存在したら、
  ## その参照を書く。
  var i: int
  var window: seq[byte]
  for _ in 0..<byteSeq.len:
    if byteSeq.len <= i:
      break
    if windowSize < window.len:
      window.delete(0, 1)

    let v = byteSeq[i]
    let matched = window.getTheLongestMatched(byteSeq, i)
    if matched.len < 1:
      # マッチするものが存在しなかった場合
      result.add v
      i.inc
    else:
      result.add matched
      i.inc matched.len
    window.add v