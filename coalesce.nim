import options

template `??`*[T](left: T, right: T): T =
  if left != nil: left else: right

template `??`*[T](left: T, right: Option[T]): Option[T] =
  if left != nil: some(left) else: right

template `??`*[T](left: Option[T], right: T): T =
  if isSome(left): left.get() ?? right else: right

template `??`*[T](left: Option[T], right: Option[T]): Option[T] =
  if isSome(left): left.get() ?? right else: right


template `==`[T](left: Option[T], right: T): bool =
  if isSome(left): left.get() == right else: false

template `==`[T](left: T, right: Option[T]): bool =
  right == left


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
    test "left some nil":
      let a: Option[string] = some(string(nil))
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
    test "left some nil":
      let a: Option[string] = some(string(nil))
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

  suite "short circuit options":
    test "first some":
      proc getA(): Option[string] = return some("a")
      proc getB(): Option[string] = raise newException(ValueError, "expensive operation")
      discard getA() ?? getB()
    test "first none":
      proc getA(): Option[string] = return none(string)
      proc getB(): Option[string] = raise newException(ValueError, "expensive operation")
      expect ValueError:
        discard getA() ?? getB()

  suite "short circuit raws":
    test "first not nil":
      proc getA(): string = return "a"
      proc getB(): string = raise newException(ValueError, "expensive operation")
      discard getA() ?? getB()
    test "first nil":
      proc getA(): string = return nil
      proc getB(): string = raise newException(ValueError, "expensive operation")
      expect ValueError:
        discard getA() ?? getB()
