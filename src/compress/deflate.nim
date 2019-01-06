# Wikipedia - ハフマン符号 https://ja.wikipedia.org/wiki/%E3%83%8F%E3%83%95%E3%83%9E%E3%83%B3%E7%AC%A6%E5%8F%B7

import tables, sequtils, strutils
from strformat import `&`
from algorithm import sort

type
  Node = ref object
    value: char
    left: Node
    right: Node
    count: int
  
proc echoTree(n: Node, depth: int, prefix: string = "") =
  let
    value = n.value
    left = n.left
    right = n.right
    count = n.count
    indent = "  ".repeat(depth).join
  echo &"{indent}+ [{prefix}] (value: {value}, count: {count})"
  if left != nil:
    echoTree(left, depth + 1, "L")
  if right != nil:
    echoTree(right, depth + 1, "R")

when isMainModule:
  var nodes: seq[Node]
  let datas = "DAEBCBACBBBC"

  # count chars and add nodes
  for c in datas.deduplicate:
    var node = new Node
    node.value = c
    node.count = datas.count c
    nodes.add node

  nodes.sort(proc(x, y: Node): int = cmp(x.count, y.count))

  while 2 <= nodes.len:
    var
      n = new Node
      tmp: seq[Node]
    for node in nodes[0..1]:
      tmp.add node
      nodes.delete 0
    n.count = tmp[0].count + tmp[1].count
    n.left  = tmp[0]
    n.right = tmp[1]
    nodes.add n
  
  for n in nodes:
    echoTree(n, 0)
    echo "----------"
