//
//  NewsStreamTests.swift
//  NewsStreamTests
//
//  Created by Denis Kalashnikov on 3/10/19.
//  Copyright © 2019 Denis Kalashnikov. All rights reserved.
//

import XCTest
@testable import NewsStream

class NewsStreamTests: XCTestCase {

    var model: NewsStream?
    override func setUp() {
        if let url = Bundle.main.url(forResource: "Model", withExtension: "json"), let jsonData = try? Data(contentsOf: url){
            model = try? newJSONDecoder().decode(NewsStream.self, from: jsonData)
        }
        
    }

    override func tearDown() {
        model = nil
    }

    func testExample() {
        XCTAssert(model != nil)
    }

    func testNumbersOfNewsLoaded()  {
        XCTAssert(model?.items?.result?.count ?? -1 > 0)
    }

}
