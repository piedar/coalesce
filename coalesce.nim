import options

proc `??`*[T](left: Option[T], right: Option[T]): Option[T] =
  if isSome(left): return left else: return right

proc `??`*[T](left: Option[T], right: T): T =
  if isSome(left): return left.get() else: return right

proc `??`*[T](left: T, right: Option[T]): Option[T] =
  if left != nil: return some(left) else: return right

proc `??`*[T](left: T, right: T): T =
  if left != nil: return left else: return right


proc `==`[T](left: Option[T], right: T): bool =
  if isSome(left): return left.get() == right else: return false

proc `==`[T](left: T, right: Option[T]): bool =
  return right == left


when isMainModule:
  import unittest

  suite "coalesce option and option":
    test "left some":
      let a: Option[string] = some("a")
      let b: Option[string] = none(string)
      check((a ?? b) == a)
    test "left none":
      let a: Option[string] = none(string)
      let b: Option[string] = some("b")
      check((a ?? b) == b)

  suite "coalesce option and raw":
    test "left some":
      let a: Option[string] = some("a")
      let b: string = "b"
      check((a ?? b) == a)
    test "left none":
      let a: Option[string] = none(string)
      let b: string = "b"
      check((a ?? b) == b)

  suite "coalesce raw and option":
    test "left not nil":
      let a: string = "a"
      let b: Option[string] = none(string)
      check((a ?? b) == a)
    test "left nil":
      let a: string = nil
      let b: Option[string] = some("b")
      check((a ?? b) == b)

  suite "coalesce raw and raw":
    test "left not nil":
      let a: string = "a"
      let b: string = nil
      check((a ?? b) == a)
    test "left nil":
      let a: string = nil
      let b: string = "b"
      check((a ?? b) == b)

  suite "coalesce options and raw":
    test "first some":
      let a: Option[string] = some("a")
      let b: Option[string] = some("b")
      let c: string = "c"
      check((a ?? b ?? c) == a)
    test "second some":
      let a: Option[string] = none(string)
      let b: Option[string] = some("b")
      let c: string = "c"
      check((a ?? b ?? c) == b)
    test "both none":
      let a: Option[string] = none(string)
      let b: Option[string] = none(string)
      let c: string = "c"
      check((a ?? b ?? c) == c)

  suite "coalesce option and raws":
    test "first some":
      let a: Option[string] = some("a")
      let b: string = "b"
      let c: string = "c"
      check((a ?? b ?? c) == a)
    test "first none, second not nil":
      let a: Option[string] = none(string)
      let b: string = "b"
      let c: string = "c"
      check((a ?? b ?? c) == b)
    test "first none, second nil":
      let a: Option[string] = none(string)
      let b: string = nil
      let c: string = "c"
      check((a ?? b ?? c) == c)

  suite "coalesce raw and options":
    test "first not nil":
      let a: string = "a"
      let b: Option[string] = some("b")
      let c: Option[string] = some("c")
      check((a ?? b ?? c) == a)
    test "first nil, second some":
      let a: string = nil
      let b: Option[string] = some("b")
      let c: Option[string] = some("c")
      check((a ?? b ?? c) == b)
    test "first nil, second none":
      let a: string = nil
      let b: Option[string] = none(string)
      let c: Option[string] = some("c")
      check((a ?? b ?? c) == c)

  suite "coalesce raws and option":
    test "first not nil":
      let a: string = "a"
      let b: string = "b"
      let c: Option[string] = some("c")
      check((a ?? b ?? c) == a)
    test "first nil, second not nil":
      let a: string = nil
      let b: string = "b"
      let c: Option[string] = some("c")
      check((a ?? b ?? c) == b)
    test "first nil, second nil":
      let a: string = nil
      let b: string = nil
      let c: Option[string] = some("c")
      check((a ?? b ?? c) == c)