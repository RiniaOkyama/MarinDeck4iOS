//
//  MarindeckTests.swift
//  MarindeckTests
//
//  Created by a on 2022/01/29.
//

import XCTest
@testable import Marindeck

class MarindeckTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testJsSwiftBindingParse() throws {
        let imageViewerJsonString = """
{
  type: 'imageViewer',
  content: {
    value: [
      {
        url: '',
        isSelected: true,
        position: {left: 1, top: 2, width: 3, height: 4}
      },
    ],
    selectIndex: 1
  }
}
"""
        let fetchImageJsonString = """
{
  type: 'fetchImage',
  content: {
    url: 'https://...'
    // ...
  }
}
"""
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(General.self, from: fetchImageJsonString.data(using: .utf8)!) else { return }
        print(decoded.content)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
