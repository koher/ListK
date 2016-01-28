import XCTest
@testable import ListK

class ListKTests: XCTestCase {
    func testInit() {
        let rs: List<Int> = List()
        
        XCTAssert(rs == [])
    }
    
    func testInitWithValue() {
        let rs: List<Int> = List(2)
        
        XCTAssert(rs == [2])
    }
    
    func testInitWithHeadAndTail() {
        if true {
            let rs: List<Int> = List(head: 2, tail: [3, 5, 7, 11])
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true { // Infinite list
            let rs: List<Int> = List(head: 0, tail: List { $0 + 1 })
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
        }
    }
    
    func testInitWithArrayLiteral() {
        if true {
            let rs: List<Int> = [2, 3, 5, 7, 11]
            
            XCTAssert(rs == List(head: 2, tail: List(head:3, tail: List(head: 5, tail: List(head: 7, tail: List(11))))))
        }
        
        if true {
            let rs: List<Int> = []
            
            XCTAssert(rs == List())
        }
    }
    
    func testInitWithArray() {
        let xs: [Int] = [2, 3, 5, 7, 11]
        let rs: List<Int> = List(array: xs)
        
        XCTAssert(rs == [2, 3, 5, 7, 11])
    }
    
    func testInitWithArraySlice() {
        let xs: ArraySlice<Int> = [2, 3, 5, 7, 11][1...3]
        let rs: List<Int> = List(arraySlice: xs)
        
        XCTAssert(rs == [3, 5, 7])
    }
    
    func testInitWithSequence() {
        if true {
            let xs: [Int] = [2, 3, 5, 7, 11]
            let rs: List<Int> = List(sequence: xs)
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = List(sequence: xs)
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
        }
    }
    
    func testInitWithGenerator() {
        if true {
            let xs: [Int] = [2, 3, 5, 7, 11]
            let rs: List<Int> = List(generator: xs.generate())
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = List(sequence: xs.generate())
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
        }
    }
    
    func testInitRecurrence() {
        let rs: List<Int> = List(initial: 0, next: { $0 + 1 })
        
        XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
    }
    
    func testInitRecurrenceN() {
        let rs: List<Int> = List(initial: [0, 1]) { $0.reduce(0) { $0 + $1 } }
        
        XCTAssert(rs.take(8) == [0, 1, 1, 2, 3, 5, 8, 13])
    }
    
    func testInitRepeat() {
        let rs: List<Int> = List(repeatedValue: 2)
        
        XCTAssert(rs.take(5) == [2, 2, 2, 2, 2])
    }
    
    func testInitRepeatWithCount() {
        let rs: List<Int> = List(repeatedValue: 2, count: 5)
        
        XCTAssert(rs == [2, 2, 2, 2, 2])
    }
    
    func testHead() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r: Int? = xs.head
            
            XCTAssertEqual(r!, 2)
        }
        
        if true {
            let xs: List<Int> = []
            let r: Int? = xs.head
            
            XCTAssertNil(r)
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let r: Int? = xs.head
            
            XCTAssertEqual(r!, 0)
        }
    }
    
    func testTail() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.tail
            
            XCTAssert(rs == [3, 5, 7, 11])
        }
        
        if true {
            let xs: List<Int> = []
            let rs: List<Int> = xs.tail
            
            XCTAssert(rs == [])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.tail
            
            XCTAssert(rs.take(5) == [1, 2, 3, 4, 5])
        }
    }
    
    func testGenerate() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r = xs.generate()
            
            XCTAssertEqual(r.next(), 2)
            XCTAssertEqual(r.next(), 3)
            XCTAssertEqual(r.next(), 5)
            XCTAssertEqual(r.next(), 7)
            XCTAssertEqual(r.next(), 11)
            XCTAssertNil(r.next())
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let r = xs.generate()
            
            XCTAssertEqual(r.next(), 0)
            XCTAssertEqual(r.next(), 1)
            XCTAssertEqual(r.next(), 2)
            XCTAssertEqual(r.next(), 3)
            XCTAssertEqual(r.next(), 4)
        }
    }
    
    func testSubscript() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            
            XCTAssertEqual(xs[0], 2)
            XCTAssertEqual(xs[1], 3)
            XCTAssertEqual(xs[2], 5)
            XCTAssertEqual(xs[3], 7)
            XCTAssertEqual(xs[4], 11)
            
            XCTAssertNil(xs[-1])
            XCTAssertNil(xs[5])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            
            XCTAssertEqual(xs[0], 0)
            XCTAssertEqual(xs[1], 1)
            XCTAssertEqual(xs[2], 2)
            XCTAssertEqual(xs[3], 3)
            XCTAssertEqual(xs[4], 4)
            
            XCTAssertEqual(xs[999], 999)
        }
    }
    
    func testSubscriptRange() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs[1...3]
            
            XCTAssert(rs == [3, 5, 7])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs[1..<3]
            
            XCTAssert(rs == [3, 5])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs[0..<0]
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs[-10..<0]
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs[2...999]
            
            XCTAssert(rs == [5, 7, 11])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs[5...9]
            
            XCTAssert(rs == [5, 6 ,7, 8, 9])
        }
    }
    
    func testCount() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r: Int = xs.count
            
            XCTAssertEqual(r, 5)
        }
        
        if true {
            let xs: List<Int> = []
            let r: Int = xs.count
            
            XCTAssertEqual(r, 0)
        }
    }
    
    func testIsEmpty() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r: Bool = xs.isEmpty
            
            XCTAssertFalse(r)
        }
        
        if true {
            let xs: List<Int> = []
            let r: Bool = xs.isEmpty
            
            XCTAssertTrue(r)
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let r: Bool = xs.isEmpty
            
            XCTAssertFalse(r)
        }
    }
    
    func testFirst() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r: Int? = xs.first
            
            XCTAssertEqual(r!, 2)
        }
        
        if true {
            let xs: List<Int> = []
            let r: Int? = xs.first
            
            XCTAssertNil(r)
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let r: Int? = xs.first
            
            XCTAssertEqual(r!, 0)
        }
    }
    
    func testLast() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r: Int? = xs.last
            
            XCTAssertEqual(r!, 11)
        }
        
        if true {
            let xs: List<Int> = []
            let r: Int? = xs.last
            
            XCTAssertNil(r)
        }
    }
    
    func testReduce() {
        let xs: List<Int> = [2, 3, 5, 7, 11]
        let r: Int = xs.reduce(0, combine: +)
        
        XCTAssertEqual(r, 28)
    }
    
    func testLazyReduceRight() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r: Int = xs.reduceRight(0) { $0 + $1() }
            
            XCTAssertEqual(r, 28)
        }
        
        if true { // Infinite list
            let xs: List<Bool> = List { _ in false }
            let r: Bool = xs.reduceRight(true) { $0 && $1() }
            
            XCTAssertFalse(r)
        }
        
        if true { // Lazily nested
            let xss: List<List<Int>> = List { List(repeatedValue: $0, count: $0) }
            let rs: List<Int> = xss.reduceRight(List<Int>()) { xs, flattened in
                xs.reduceRight(flattened()) { x, flattened in
                    List(head: x, tail: flattened())
                }
            }
            
            XCTAssert(rs.take(10) == [1, 2, 2, 3, 3, 3, 4, 4, 4, 4])
        }
    }
    
    func testForEach() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            var r: Int = 0
            
            xs.forEach {
                r += $0
            }
            
            XCTAssertEqual(r, 28)
        }
    }
    
    func testFilter() {
        if true {
            let xs: List<Int> = [0, 1, 2, 3, 4]
            let rs: List<Int> = xs.filter { $0 % 2 == 0 }
            
            XCTAssert(rs == [0, 2, 4])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.filter { $0 % 2 == 0 }
            
            XCTAssert(rs.take(5) == [0, 2, 4, 6, 8])
        }
    }
    
    func testMap() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.map { $0 * $0 }
            
            XCTAssert(rs == [4, 9, 25, 49, 121])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.map { $0 * $0 }
            
            XCTAssert(rs.take(5) == [0, 1, 4, 9, 16])
        }
    }
    
    func testFlatMap() {
        if true {
            let xss: List<List<Int>> = [[2], [3, 5], [7, 11, 13]]
            let rs: List<Int> = xss.flatMap { $0 }
            
            XCTAssert(rs == [2, 3, 5, 7, 11, 13])
        }
        
        if true {
            let xs: List<String> = ["one", "2", "3", "four", "5", "six", "7"]
            let rs: List<Int> = xs.flatMap { Int($0).map { [$0] } ?? [] }
            
            XCTAssert(rs == [2, 3, 5, 7])
        }
        
        if true { // Infinite list
            let xss: List<List<Int>> = List { [$0] }
            let rs: List<Int> = xss.flatMap { $0 }
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
        }
    }
    
    func testApply() {
        if true {
            let xs: List<Int> = [2, 3]
            let ys: List<Int> = [5, 7, 11]
            let rs: List<Int> = ys.apply(xs.apply(pure(curry(+))))
            
            XCTAssert(rs == [7, 9, 13, 8, 10, 14])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 + 1 }
            let ys: List<Int> = [2, 3, 5]
            let rs: List<Int> = ys.apply(xs.apply(pure(curry(*))))
            
            XCTAssert(rs.take(9) == [2, 3, 5, 4, 6, 10, 6, 9, 15])
        }
    }
    
    func testTake() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.take(3)
            
            XCTAssert(rs == [2, 3, 5])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.take(0)
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.take(-1)
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.take(5)
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.take(6)
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true {
            let xs: List<Int> = []
            let rs: List<Int> = xs.take(1)
            
            XCTAssert(rs == [])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.take(5)
            
            XCTAssert(rs == [0, 1, 2, 3, 4])
        }
    }
    
    func testDrop() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.drop(3)
            
            XCTAssert(rs == [7, 11])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.drop(0)
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.drop(-1)
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.drop(5)
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.drop(6)
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = []
            let rs: List<Int> = xs.drop(1)
            
            XCTAssert(rs == [])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.drop(5)
            
            XCTAssert(rs.take(5) == [5, 6, 7, 8, 9])
        }
    }
    
    func testTakeWhile() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.takeWhile { $0 < 7 }
            
            XCTAssert(rs == [2, 3, 5])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.takeWhile { $0 < 5 }
            
            XCTAssert(rs == [0, 1, 2, 3, 4])
        }
    }
    
    func testDropWhile() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.dropWhile { $0 < 7 }
            
            XCTAssert(rs == [7, 11])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.dropWhile { $0 < 5 }
            
            XCTAssert(rs.take(5) == [5, 6, 7, 8, 9])
        }
    }
    
    func testReverse() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs.reverse
            
            XCTAssert(rs == [11, 7, 5, 3, 2])
        }
    }
    
    func testCycle() {
        if true {
            let xs: List<Int> = [2, 3, 5]
            let rs: List<Int> = xs.cycle
            
            XCTAssert(rs.take(9) == [2, 3, 5, 2, 3, 5, 2, 3, 5])
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let rs: List<Int> = xs.cycle
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
        }
    }
    
    func testDescription() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            
            XCTAssertEqual(xs.description, "[2, 3, 5, 7, 11]")
        }
        
        if true {
            let xs: List<Int> = []
            
            XCTAssertEqual(xs.description, "[]")
        }
    }
    
    func testZip() {
        if true {
            let xs: List<Int> = [2, 3, 5]
            let ys: List<String> = ["two", "three", "five"]
            let rs: List<(Int, String)> = zip(xs, ys)
            
            let g = rs.generate()
            
            XCTAssert(g.next()! == (2, "two"))
            XCTAssert(g.next()! == (3, "three"))
            XCTAssert(g.next()! == (5, "five"))
            XCTAssertNil(g.next())
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let ys: List<String> = ["two", "three", "five"]
            let rs: List<(Int, String)> = zip(xs, ys)
            
            let g = rs.generate()
            
            XCTAssert(g.next()! == (2, "two"))
            XCTAssert(g.next()! == (3, "three"))
            XCTAssert(g.next()! == (5, "five"))
            XCTAssertNil(g.next())
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5]
            let ys: List<String> = ["two", "three", "five", "seven", "eleven"]
            let rs: List<(Int, String)> = zip(xs, ys)
            
            let g = rs.generate()
            
            XCTAssert(g.next()! == (2, "two"))
            XCTAssert(g.next()! == (3, "three"))
            XCTAssert(g.next()! == (5, "five"))
            XCTAssertNil(g.next())
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5]
            let ys: List<String> = []
            let rs: List<(Int, String)> = zip(xs, ys)
            
            let g = rs.generate()
            
            XCTAssertNil(g.next())
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<String> = ["two", "three", "five"]
            let rs: List<(Int, String)> = zip(xs, ys)
            
            let g = rs.generate()
            
            XCTAssertNil(g.next())
        }
        
        if true { // Infinite list (Both)
            let xs: List<Int> = List { $0 }
            let ys: List<Int> = xs.map { $0 * $0 }
            let rs: List<(Int, Int)> = zip(xs, ys)
            
            let g = rs.take(5).generate()
            
            
            XCTAssert(g.next()! == (0, 0))
            XCTAssert(g.next()! == (1, 1))
            XCTAssert(g.next()! == (2, 4))
            XCTAssert(g.next()! == (3, 9))
            XCTAssert(g.next()! == (4, 16))
            XCTAssertNil(g.next())
        }
        
        if true { // Infinite list (xs)
            let xs: List<Int> = [2, 3, 5]
            let ys: List<Int> = List { $0 }
            let rs: List<(Int, Int)> = zip(xs, ys)
            
            let g = rs.take(5).generate()
            
            
            XCTAssert(g.next()! == (2, 0))
            XCTAssert(g.next()! == (3, 1))
            XCTAssert(g.next()! == (5, 2))
            XCTAssertNil(g.next())
        }
        
        if true { // Infinite list (ys)
            let xs: List<Int> = List { $0 }
            let ys: List<Int> = [2, 3, 5]
            let rs: List<(Int, Int)> = zip(xs, ys)
            
            let g = rs.take(5).generate()
            
            
            XCTAssert(g.next()! == (0, 2))
            XCTAssert(g.next()! == (1, 3))
            XCTAssert(g.next()! == (2, 5))
            XCTAssertNil(g.next())
        }
    }
    
    func testEqualOperator() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let ys: List<Int> = [2, 3, 5, 7, 11]
            let zs: List<Int> = [2, 3, 5]
            
            XCTAssertTrue(xs == xs)
            XCTAssertTrue(xs == ys)
            XCTAssertTrue(ys == xs)
            XCTAssertFalse(xs == zs)
            XCTAssertFalse(zs == xs)
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<Int> = []
            let zs: List<Int> = [2]
            
            XCTAssertTrue(xs == xs)
            XCTAssertTrue(xs == ys)
            XCTAssertTrue(ys == xs)
            XCTAssertFalse(xs == zs)
            XCTAssertFalse(zs == xs)
        }
    }
    
    func testNotEqualOperator() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let ys: List<Int> = [2, 3, 5, 7, 11]
            let zs: List<Int> = [2, 3, 5]
            
            XCTAssertFalse(xs != xs)
            XCTAssertFalse(xs != ys)
            XCTAssertFalse(ys != xs)
            XCTAssertTrue(xs != zs)
            XCTAssertTrue(zs != xs)
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<Int> = []
            let zs: List<Int> = [2]
            
            XCTAssertFalse(xs != xs)
            XCTAssertFalse(xs != ys)
            XCTAssertFalse(ys != xs)
            XCTAssertTrue(xs != zs)
            XCTAssertTrue(zs != xs)
        }
    }
    
    func testAddOperatior() {
        if true {
            let xs: List<Int> = [2, 3, 5]
            let ys: List<Int> = [7, 11]
            let rs: List<Int> = xs + ys
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<Int> = [2, 3, 5, 7, 11]
            let rs: List<Int> = xs + ys
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let ys: List<Int> = []
            let rs: List<Int> = xs + ys
            
            XCTAssert(rs == [2, 3, 5, 7, 11])
        }
        
        if true { // Infinite list
            let xs: List<Int> = [0, 1, 2]
            let ys: List<Int> = List { $0 + 3 }
            let rs: List<Int> = xs + ys
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
            
        }
    }
    
    func testFlatMapOperator() {
        if true {
            let xss: List<List<Int>> = [[2], [3, 5], [7, 11, 13]]
            let rs: List<Int> = xss >>- { $0 }
            
            XCTAssert(rs == [2, 3, 5, 7, 11, 13])
        }
        
        if true {
            let xs: List<String> = ["one", "2", "3", "four", "5", "six", "7"]
            let rs: List<Int> = xs >>- { Int($0).map { [$0] } ?? [] }
            
            XCTAssert(rs == [2, 3, 5, 7])
        }
        
        if true { // Infinite list
            let xss: List<List<Int>> = List { [$0] }
            let rs: List<Int> = xss >>- { $0 }
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
        }
    }
    
    func testFlippedFlatMapOperator() {
        if true {
            let xss: List<List<Int>> = [[2], [3, 5], [7, 11, 13]]
            let rs: List<Int> = { $0 } -<< xss
            
            XCTAssert(rs == [2, 3, 5, 7, 11, 13])
        }
        
        if true {
            let xs: List<String> = ["one", "2", "3", "four", "5", "six", "7"]
            let rs: List<Int> = { Int($0).map { [$0] } ?? [] } -<< xs
            
            XCTAssert(rs == [2, 3, 5, 7])
        }
        
        if true { // Infinite list
            let xss: List<List<Int>> = List { [$0] }
            let rs: List<Int> = { $0 } -<< xss
            
            XCTAssert(rs.take(5) == [0, 1, 2, 3, 4])
        }
    }
    
    func testFlippedApplyOperator() {
        if true {
            let xs: List<Int> = [2]
            let ys: List<Int> = [3]
            let rs: List<Int> = pure(curry(+)) <*> xs <*> ys
            
            XCTAssert(rs == [5])
        }
        
        if true {
            let xs: List<Int> = [2]
            let ys: List<Int> = []
            let rs: List<Int> = pure(curry(+)) <*> xs <*> ys
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<Int> = [3]
            let rs: List<Int> = pure(curry(+)) <*> xs <*> ys
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<Int> = []
            let rs: List<Int> = pure(curry(+)) <*> xs <*> ys
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = [2, 3]
            let ys: List<Int> = [5, 7]
            let rs: List<Int> = pure(curry(+)) <*> xs <*> ys
            
            XCTAssert(rs == [7, 9, 8, 10])
        }
    }
    
    func testFlippedMapOperator() {
        if true {
            let xs: List<Int> = [2]
            let ys: List<Int> = [3]
            let rs: List<Int> = curry(+) <^> xs <*> ys
            
            XCTAssert(rs == [5])
        }
        
        if true {
            let xs: List<Int> = [2]
            let ys: List<Int> = []
            let rs: List<Int> = curry(+) <^> xs <*> ys
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<Int> = [3]
            let rs: List<Int> = curry(+) <^> xs <*> ys
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = []
            let ys: List<Int> = []
            let rs: List<Int> = curry(+) <^> xs <*> ys
            
            XCTAssert(rs == [])
        }
        
        if true {
            let xs: List<Int> = [2, 3]
            let ys: List<Int> = [5, 7]
            let rs: List<Int> = curry(+) <^> xs <*> ys
            
            XCTAssert(rs == [7, 9, 8, 10])
        }
    }
    
    func testContains() {
        if true {
            let xs: List<Int> = [2, 3, 5, 7, 11]
            let r1: Bool = xs.contains(7)
            let r2: Bool = xs.contains(8)
            
            XCTAssertTrue(r1)
            XCTAssertFalse(r2)
        }
        
        if true { // Infinite list
            let xs: List<Int> = List { $0 }
            let r1: Bool = xs.contains(100)
            
            XCTAssertTrue(r1)
        }
    }
    
    func testAnd() {
        if true {
            let xs: List<Bool> = [true, true, true, true, true]
            let r: Bool = xs.and
            
            XCTAssertTrue(r)
        }
        
        if true {
            let xs: List<Bool> = [true, true, false, true, true]
            let r: Bool = xs.and
            
            XCTAssertFalse(r)
        }
        
        if true {
            let xs: List<Bool> = []
            let r: Bool = xs.and
            
            XCTAssertTrue(r)
        }
        
        if true { // Infinite list
            let xs: List<Bool> = List(repeatedValue: false)
            let r: Bool = xs.and
            
            XCTAssertFalse(r)
        }
    }
    
    func testOr() {
        if true {
            let xs: List<Bool> = [false, false, false, false, false]
            let r: Bool = xs.or
            
            XCTAssertFalse(r)
        }
        
        if true {
            let xs: List<Bool> = [false, false, true, false, false]
            let r: Bool = xs.or
            
            XCTAssertTrue(r)
        }
        
        if true {
            let xs: List<Bool> = []
            let r: Bool = xs.or
            
            XCTAssertFalse(r)
        }
        
        if true { // Infinite list
            let xs: List<Bool> = List(repeatedValue: true)
            let r: Bool = xs.or
            
            XCTAssertTrue(r)
        }
    }
    
    func testMinElement() {
        if true {
            let xs: List<Int> = [3, 2, 7, 5, 11]
            let r: Int? = xs.minElement()
            
            XCTAssert(r! == 2)
        }
        
        if true {
            let xs: List<Int> = []
            let r: Int? = xs.minElement()
            
            XCTAssertNil(r)
        }
    }
    
    func testMaxElement() {
        if true {
            let xs: List<Int> = [2, 5, 3, 11, 7]
            let r: Int? = xs.maxElement()
            
            XCTAssert(r! == 11)
        }
        
        if true {
            let xs: List<Int> = []
            let r: Int? = xs.maxElement()
            
            XCTAssertNil(r)
        }
    }
    
    func testReducePerformance() { // slow
        let xs: List<Int> = List { $0 }.take(256)
        let ys: List<Int> = xs.map { $0 * $0 }
        
        self.measureBlock {
            let rs: List<Int> = xs.reduce(List()) { list, element in list + [element * element] }
            XCTAssert(rs == ys)
        }
    }
    
    func testReduceRightPerformance() { // fast
        let xs: List<Int> = List { $0 }.take(256)
        let ys: List<Int> = xs.map { $0 * $0 }
        
        self.measureBlock {
            let rs: List<Int> = xs.reduceRight(List()) { element, list in List(head: element * element, tail: list()) }
            XCTAssert(rs == ys)
        }
    }
    
    func testFibonacci() {
        let rs: List<Int> = fibonacci()
        
        XCTAssert(rs.take(8) == [0, 1, 1, 2, 3, 5, 8, 13])
    }
    
    func testSum() {
        let xs: List<Int> = [2, 3, 5, 7, 11]
        let r: Int = sum(xs)
        
        XCTAssertEqual(r, 28)
    }
    
    func testSample() {
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
            return List(initial: [0, 1], next: sum)
        } // returns [0, 1, 1, 2, 3, 5, 8, 13, ...]
        
        // Nested reduceRight with lazy evaluation
        let xss: List<List<Int>> = List { List(repeatedValue: $0, count: $0) }
        // [[1], [2, 2], [3, 3, 3], [4, 4, 4, 4], ...]
        let flattened: List<Int> = xss.reduceRight(List<Int>()) { xs, flattened in
            xs.reduceRight(flattened()) { x, flattened in
                List(head: x, tail: flattened())
            }
        } // [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, ...]
        
        XCTAssert(mapped.take(5) == [0, 1, 4, 9, 16])
        XCTAssert(taken == [0, 1, 2, 3, 4])
        XCTAssert(dropped.take(5) == [5, 6, 7, 8, 9])
        XCTAssert(ys.take(5) == [0, 2, 4, 6, 8])
        XCTAssert(zs == [10, 14, 15, 21])
        XCTAssert(flattened.take(10) == [1, 2, 2, 3, 3, 3, 4, 4, 4, 4])
    }
}

private func ==<T: Equatable, U: Equatable>(lhs: (T, U), rhs: (T, U)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

private func curry<T, U, V>(f: (T, U) -> V) -> T -> U -> V {
    return { t in { u in f(t, u) } }
}

private func fibonacci() -> List<Int> {
    return List(initial: [0, 1], next: sum)
}

private func sum(xs: List<Int>) -> Int {
    switch xs {
    case .None: return 0
    case let .Some(head, tail): return head + sum(tail())
    }
}
