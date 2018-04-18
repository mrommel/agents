//
//  HexPointWithCornerTests.swift
//  agentsTests
//
//  Created by Michael Rommel on 18.04.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import XCTest
@testable import agents

class HexPointWithCornerTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testAdjacentCorners() {
		
		// GIVEN
		let point = HexPoint(x: 1, y: 1)
		let hexPointWithCorner = HexPointWithCorner(with: point, andCorner: .northeast)
		
		// WHEN
		let adjacentCorners = hexPointWithCorner.adjacentCorners()
		
		// THEN
		XCTAssertEqual(adjacentCorners.count, 3)
		XCTAssertEqual(adjacentCorners[0].point, HexPoint(x: 0, y: 0))
		XCTAssertEqual(adjacentCorners[0].corner, .east)
		XCTAssertEqual(adjacentCorners[1].point, HexPoint(x: 1, y: 1))
		XCTAssertEqual(adjacentCorners[1].corner, .east)
		XCTAssertEqual(adjacentCorners[2].point, HexPoint(x: 1, y: 1))
		XCTAssertEqual(adjacentCorners[2].corner, .northwest)
	}
	
}
