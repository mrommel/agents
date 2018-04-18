//
//  agentsTests.swift
//  agentsTests
//
//  Created by Michael Rommel on 18.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import XCTest
@testable import agents

class RiverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func testRiverCreationFail() {
		
		// GIVEN
		let cornerPoints: [HexPointWithCorner] = []
		
		// WHEN
		let river = River(with: "riverName", and: cornerPoints)
		
		// THEN
		XCTAssertEqual(river.name, "riverName")
		XCTAssertEqual(river.points.count, 0, "River has wrong length")
	}
    
    func testRiverCreationSuccess() {
		
		// GIVEN
		let point = HexPoint(x: 1, y: 1)
		let cornerPoints = [
			HexPointWithCorner(with: point, andCorner: .northeast),
			HexPointWithCorner(with: point, andCorner: .east),
			HexPointWithCorner(with: point, andCorner: .southeast)
		]
		
		// WHEN
		let river = River(with: "riverName", and: cornerPoints)
		
		// THEN
		XCTAssertEqual(river.name, "riverName")
		XCTAssertEqual(river.points.count, 2, "River has wrong length")
		XCTAssertEqual(river.points[0].point, point)
		XCTAssertEqual(river.points[0].flowDirection, .southEast)
		XCTAssertEqual(river.points[1].point, point)
		XCTAssertEqual(river.points[1].flowDirection, .southWest)
    }
    
}
