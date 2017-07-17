# coalesce

The `coalesce` package implements a [null coalescing operator](https://en.wikipedia.org/wiki/Null_coalescing_operator) `??` for [Nim](https://github.com/nim-lang/Nim).

## examples

The most obvious case is choosing the first non-nil value.

    let a: string = nil
    let x = a ?? "b"
    assert x == "b"

The operator also supports `Option[T]`.

    let a: Option[string] = none(string)
    let x = a ?? "b"
    assert x == "b"

Longer chains work too, and the expression short-circuits if possible.

    let result = tryComputeFast(input) ?? tryComputeSlow(input) ?? myDefault

## todo

- support for `not nil`
