import XCTest

import authzTests

var tests = [XCTestCaseEntry]()
tests += authzTests.allTests()
XCTMain(tests)
