//
//  dotBrainsTests.swift
//  dotBrainsTests
//
//  Created by Atte Jokinen on 28.10.2021.
//

import XCTest
@testable import dotBrains

class dotBrainsTests: XCTestCase {

    
    func testVectorDistance() throws {
        let a = Vector(5, 10)
        let b = Vector(0, 0)
        var c: Double { return Vector.Distance(a, b) }
        XCTAssertEqual(c, 11.18)
        
        var d: Double { return Vector.Distance(a, a) }
        XCTAssertEqual(d, 0)
        
        let e = Vector(-10, -10)
        var f: Double { return Vector.Distance(b, e) }
        XCTAssertEqual(f, 14.14)
    }

}
