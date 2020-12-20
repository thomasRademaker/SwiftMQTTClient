import XCTest
@testable import SwiftMQTTClient

final class SwiftMQTTClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftMQTTClient().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
