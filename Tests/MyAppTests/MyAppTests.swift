import Testing
@testable import MyApp

// Swift Testing: `@Test` marks a test, `#expect` checks a condition. Run with scripts/test.sh
// (or `swift test --filter CounterTests`).
struct CounterTests {
    @Test("Label before any clicks")
    func zero() {
        #expect(Counter.label(for: 0) == "Not clicked yet")
    }

    @Test("Label pluralises", arguments: [(1, "Clicked once"), (2, "Clicked 2 times"), (10, "Clicked 10 times")])
    func plural(count: Int, expected: String) {
        #expect(Counter.label(for: count) == expected)
    }
}
