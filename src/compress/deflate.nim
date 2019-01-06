# Wikipedia - ハフマン符号 https://ja.wikipedia.org/wiki/%E3%83%8F%E3%83%95%E3%83%9E%E3%83%B3%E7%AC%A6%E5%8F%B7

import tables, sequtils, strutils, strformat
from algorithm import sort

type
  Node = ref object
    value: char
    left: Node
    right: Node
    count: int
    bin: uint64
  
proc show(n: Node, depth: int = 0, prefix: string = "") =
  ## show is echo tree structure text for debugging.
  let
    value = n.value
    left = n.left
    right = n.right
    count = n.count
    bin = n.bin
    indent = "  ".repeat(depth).join
  echo &"{indent}+ [{prefix}] (value: {value}, count: {count}, bin: {bin:#b})"
  if left != nil:
    show(left, depth + 1, "L")
  if right != nil:
    show(right, depth + 1, "R")

proc toTreeNode(datas: string): Node =
  var nodes: seq[Node]

  # count chars and add nodes
  for c in datas.deduplicate:
    var node = new Node
    node.value = c
    node.count = datas.count c
    nodes.add node

  # struct tree nodes.
  while 2 <= nodes.len:
    nodes.sort(proc(x, y: Node): int = cmp(x.count, y.count))
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

  return nodes[0]

proc encode(node: Node) =
  if node.left == nil or node.right == nil:
    return
  node.left.bin = node.bin shl 1
  node.right.bin = node.bin shl 1
  node.right.bin += 0b01
  node.right.encode

proc toTable(node: Node, tbl: var Table[char, uint64]): Table[char, uint64] =
  if node.value != '\0':
    tbl[node.value] = node.bin
  if node.left == nil or node.right == nil:
    return tbl
  discard node.left.toTable tbl
  return node.right.toTable tbl

proc toTable*(node: Node): Table[char, uint64] =
  var tbl = initTable[char, uint64]()
  return node.toTable tbl

when isMainModule:
  var node = "DAEBCBACBBBC".toTreeNode
  node.encode
  node.show
  echo node.toTable