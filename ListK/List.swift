public enum List<Element> {
    case None
    case Some(Element, () -> List<Element>)
    
    public init() {
        self = .None
    }
    
    public init(_ value: Element) {
        self.init(head: value, tail: .None)
    }
    
    public init(head: Element, @autoclosure(escaping) tail: () -> List<Element>) {
        self = .Some(head, tail)
    }
}

extension List: ArrayLiteralConvertible {
    public init(arrayLiteral elements: Element...) {
        self.init(array: elements)
    }
    
    public init(array: [Element]) {
        self.init(arraySlice: array[0..<array.count])
    }
    
    public init(arraySlice: ArraySlice<Element>) {
        if let first = arraySlice.first {
            self.init(head: first, tail: List(arraySlice: arraySlice[(arraySlice.startIndex + 1)..<arraySlice.endIndex]))
        } else {
            self.init()
        }
    }
    
    public init<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
        switch sequence {
        case let list as List<S.Generator.Element>:
            self.init(list: list)
        case _:
            self.init(generator: sequence.generate())
        }
    }
    
    public init<G: GeneratorType where G.Element == Element>(var generator: G) {
        switch generator.next() {
        case .None:
            self.init()
        case let .Some(value):
            self.init(head: value, tail: List(generator: generator))
        }
    }
    
    public init(list: List<Element>) {
        self = list
    }
}

extension List { // Initializers with higher-order functions
    public init(initial: Element, next: Element -> Element) {
        self = List(head: initial, tail: List(initial: next(initial), next: next))
    }
    
    public init(initial: List<Element>, next: List<Element> -> Element) {
        switch initial {
        case .None:
            self = List(repeatedValue: next(initial))
        case let .Some(head, tail):
            self = List(head: head, tail: List(initial: tail() + [next(initial)], next: next))
        }
    }
    
    public init(transform: Int -> Element) {
        self = List<Int>(initial: 0, next: { $0 + 1 }).map(transform)
    }
}

extension List { // Other convenience initializers
    public init(repeatedValue: Element) {
        self = List { _ in repeatedValue }
    }
    
    public init(repeatedValue: Element, count: Int) {
        self = List(repeatedValue: repeatedValue).take(count)
    }
}

extension List { // head and tail
    public var head: Element? {
        switch self {
        case .None:
            return nil
        case let .Some(head, _):
            return head
        }
    }
    
    public var tail: List<Element> {
        switch self {
        case .None:
            return self
        case let .Some(_, tail):
            return tail()
        }
    }
}

extension List: SequenceType {
    public func generate() -> AnyGenerator<Element> {
        var current = self
        return anyGenerator {
            defer {
                current = current.tail
            }
            return current.head
        }
    }
}

extension List { // subscript
    public subscript(index: Int) -> Element? {
        switch index {
        case let i where i < 0:
            return nil
        case 0:
            return head
        default:
            return tail[index - 1]
        }
    }
    
    public subscript (subRange: Range<Int>) -> List<Element> {
        return take(subRange.endIndex).drop(subRange.startIndex)
    }
}

extension List { // collection properties
    public var isEmpty: Bool {
        switch self {
        case .None:
            return true
        case .Some(_, _):
            return false
        }
    }
    
    public var count: Int {
        return reduce(0) { count, _ in count + 1 }
    }
    
    public var first: Element? {
        return head
    }
    
    public var last: Element? {
        return reduce(nil) { _, x in Optional(x) }
    }
}

extension List { // basic higher-order functions
    public func reduce<T>(initial: T, combine: (T, Element) -> T) -> T {
        switch self {
        case .None:
            return initial
        case let .Some(head, tail):
            return tail().reduce(combine(initial, head), combine: combine)
        }
    }
    
    public func reduceRight<T>(@autoclosure(escaping) initial: () -> T, combine: (Element, () -> T) -> T) -> T {
        switch self {
        case .None:
            return initial()
        case let .Some(head, tail):
            return combine(head, { tail().reduceRight(initial, combine: combine) })
        }
    }
    
    public func forEach(body: Element -> ()) {
        switch self {
        case .None:
            return
        case let .Some(head, tail):
            body(head)
            tail().forEach(body)
        }
    }
    
    public func filter(includeElement: Element -> Bool) -> List<Element> {
        return reduceRight(List()) { x, xs in includeElement(x) ? List(head: x, tail: xs()) : xs() }
    }

    public func map<T>(transform: Element -> T) -> List<T> {
        return reduceRight(List<T>()) { x, xs in List<T>(head: transform(x), tail: xs()) }
    }
    
    public func flatMap<T>(transform: Element -> List<T>) -> List<T> {
        return map(transform).flatten()
    }
    
    public func apply<T>(transform: List<Element -> T>) -> List<T> {
        return transform.flatMap { self.map($0) }
    }
}

extension List { // take, drop
    public func take(numberOfElements: Int) -> List<Element> {
        switch (numberOfElements, self) {
        case let (n, _) where n <= 0:
            return List()
        case (_, .None):
            return List()
        case let (n, .Some(head, tail)):
            return List(head: head, tail: tail().take(n - 1))
        }
    }
    
    public func drop(numberOfElements: Int) -> List<Element> {
        switch (numberOfElements, self) {
        case let (n, _) where n <= 0:
            return self
        case (_, .None):
            return List()
        case let (n, .Some(_, tail)):
            return tail().drop(n - 1)
        }
    }
    
    public func takeWhile(includeElement: Element -> Bool) -> List<Element> {
        switch self {
        case .None:
            return List()
        case let .Some(head, tail):
            return includeElement(head) ? List(head: head, tail: tail().takeWhile(includeElement)) : List()
        }
    }
    
    public func dropWhile(excludeElement: Element -> Bool) -> List<Element> {
        switch self {
        case .None:
            return List()
        case let .Some(head, tail):
            return excludeElement(head) ? tail().dropWhile(excludeElement) : self
        }
    }
}

extension List { // basic methods
    public var reverse: List<Element> {
        return reduce(List()) { xs, x in List(head: x, tail: xs) }
    }
    
    public var cycle: List<Element> {
        switch self {
        case .None:
            return List()
        case let xs:
            return xs + xs.cycle
        }
    }
}

extension List: CustomStringConvertible {
    public var description: String {
        switch self {
        case .None:
            return "[]"
        case let .Some(head, tail):
            return "[\(head)" + tail().reduce("") { $0 + ", \($1)" } + "]"
        }
    }
}

public func zip<T, U>(list1: List<T>, _ list2: List<U>) -> List<(T, U)> {
    switch (list1, list2) {
    case let (.Some(head1, tail1), .Some(head2, tail2)):
        return List(head: (head1, head2), tail: zip(tail1(), tail2()))
    case (_, _):
        return List()
    }
}

public func ==<Element: Equatable>(lhs: List<Element>, rhs: List<Element>) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None):
        return true
    case let (.Some(head1, tail1), .Some(head2, tail2)):
        return head1 == head2 && tail1() == tail2()
    case (_, _):
        return false
    }
}

public func !=<Element: Equatable>(lhs: List<Element>, rhs: List<Element>) -> Bool {
    return !(lhs == rhs)
}

public func +<Element>(lhs: List<Element>, @autoclosure(escaping) rhs: () -> List<Element>) -> List<Element> {
    return lhs.reduceRight(rhs()) { x, xs in List<Element>(head: x, tail: xs()) }
}

public func pure<Element>(value: Element) -> List<Element> {
    return List(value)
}

public func >>-<Element, T>(lhs: List<Element>, rhs: Element -> List<T>) -> List<T> {
    return lhs.flatMap(rhs)
}

public func -<<<Element, T>(lhs: Element -> List<T>, rhs: List<Element>) -> List<T> {
    return rhs.flatMap(lhs)
}

public func <*><Element, T>(lhs: List<Element -> T>, rhs: List<Element>) -> List<T> {
    return rhs.apply(lhs)
}

public func <^><Element, T>(lhs: Element -> T, rhs: List<Element>) -> List<T> {
    return rhs.map(lhs)
}

extension List where Element: Equatable {
    public func contains(element: Element) -> Bool {
        return reduceRight(false) { x, contains in x == element || contains() }
    }
}

extension List where Element: BooleanType {
    public var and: Bool {
        return reduceRight(true) { x, and in x && and() }
    }
    
    public var or: Bool {
        return reduceRight(false) { x, or in x || or() }
    }
}

extension List where Element: Comparable {
    public func minElement() -> Element? {
        return reduce(nil) { min, x in min.map { x < $0 ? x : $0 } ?? x }
    }
    
    public func maxElement() -> Element? {
        return reduce(nil) { max, x in max.map { x > $0 ? x : $0 } ?? x }
    }
}

extension List where Element: SequenceType {
    public func flatten() -> List<Element.Generator.Element> {
        return reduceRight(List<Element.Generator.Element>()) { xs, flattened in List<Element.Generator.Element>(sequence: xs) + flattened() }
    }
}