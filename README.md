ListK
================

_ListK_ provides lazy lists like ones in functional programming for Swift.

```swift
let xs: List<Int> = [2, 3, 5, 7, 11]
let infinite: List<Int> = List { $0 }            // [0, 1, 2, 3, 4, ...]
let mapped: List<Int> = infinite.map { $0 * $0 } // [0, 1, 4, 9, 16, ...]
let taken: List<Int> = infinite.take(5)          // [0, 1, 2, 3, 4]
let dropped: List<Int> = infinite.drop(5)        // [5, 6, 7, 8, 9, ...]

// Pattern matching with `head` and `tail`
func sum(xs: List<Int>) -> Int {
    switch xs {
    case .None: return 0
    case let .Some(x, xs): return x + sum(xs())
    }
}

// Operators compatible with thoughtbot/Runes
let ys: List<Int> = infinite >>- { $0 % 2 == 0 ? [$0] : [] } // [0, 2, 4, 6, 8, ...]
let zs: List<Int> = curry(*) <^> [2, 3] <*> [5, 7]           // [10, 14, 15, 21]

// Fibonacci
func fibonacci() -> List<Int> {
    return List(initial: [0, 1]) { $0.reduce(0) { $0 + $1 } }
} // returns [0, 1, 1, 2, 3, 5, 8, 13, ...]
```

Features
----------------

- Lazy evaluation
- Pattern matching with `head` and `tail`
- Operators compatible with [_thoughtbot/Runes_](https://github.com/thoughtbot/runes)
- Nested `reduceRight` with lazy evaluation

### Lazy evaluation

Because `List` is evaluated lazily, operations for whole lists, `map`, `filter` and so on,  can be applied to infinite lists.

```swift
let xs: List<Int> = List { $0 }            // [0, 1, 2, 3, 4, ...]
let mapped: List<Int> = xs.map { $0 * $0 } // [0, 1, 4, 9, 16, ...]
```

### Pattern matching with head and tail

It is a typical operation to matching a list to `head` and `tail` in functional programming.

```haskell
-- Haskell
sum :: [Integer] -> Integer
sum []     = 0
sum (x:xs) = x + sum xs
```

`List` of _ListK_ can be matched `head` and `tail` because it is declared as `enum`.

```swift
enum List<Element> {
    case None
    case Some(Element, () -> List<Element>)
}
```

The following code is direct porting `sum` to Swift.

```swift
func sum(xs: List<Int>) -> Int {
    switch xs {
    case .None: return 0
    case let .Some(x, xs): return head + sum(tail())
    }
}
```

### Operators compatible with thoughtbot/Runes

Operators declared in [thoughtbot/Runes](https://github.com/thoughtbot/runes) are available.


```swift
let ys: List<Int> = infinite >>- { $0 % 2 == 0 ? [$0] : [] } // [0, 2, 4, 6, 8, ...]
let zs: List<Int> = curry(*) <^> [2, 3] <*> [5, 7]           // [10, 14, 15, 21]
```

### Nested reduceRight with lazy evaluation

Nested `reduceRight` is still lazily evaluated.

```swift
let xss: List<List<Int>> = List { List(repeatedValue: $0, count: $0) }
    // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4], ...]
let flattened: List<Int> = xss.reduceRight(List<Int>()) { xs, flattened in
    xs.reduceRight(flattened()) { x, flattened in
        List(head: x, tail: flattened())
    }
} // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, ...]
```

Installation
----------------

### Carthage

```
# Cartfile
github "koher/ListK" ~> 0.1
```

License
----------------

[The MIT License](LICENSE)
