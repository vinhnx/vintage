import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(package_outdatedTests.allTests)
    ]
}
#endif
