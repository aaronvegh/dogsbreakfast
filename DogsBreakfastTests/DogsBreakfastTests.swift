//
//  DogsBreakfastTests.swift
//  DogsBreakfastTests
//
//  Created by Aaron Vegh on 2018-08-08.
//  Copyright © 2018 Aaron Vegh. All rights reserved.
//

import XCTest
@testable import DogsBreakfast

class DogsBreakfastTests: XCTestCase {

    var jsonString: String?
    
    override func setUp() {
        super.setUp()
        let url = Bundle(for: DogsBreakfastTests.self).url(forResource: "test", withExtension: "json")!
        do {
            jsonString = try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("No json for you, daaaaawwwwg")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Bare-bones sanity test to ensure the model object parsing works as expected.
    func testParsing() {
        if let data = jsonString?.data(using: .utf8) {
            let recipeResult = try! JSONDecoder().decode(RecipeResult.self, from: data)
            if let recipes = recipeResult.results {
                XCTAssert(recipes.count == 10)
                XCTAssert(recipes.first?.title == "Amazing Taco Seasoning")
            }
        }
        
    }
}
