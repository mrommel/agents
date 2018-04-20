//
//  AreaTests.swift
//  agentsTests
//
//  Created by Michael Rommel on 20.04.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import XCTest
@testable import agents

class AreaTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testConstructor() {
		
		// GIVEN
		
		// WHEN
		let area = Area(with: "identifier")
		
		// THEN
		XCTAssertEqual(area.count, 0)
		XCTAssertEqual(area.identifier, "identifier")
	}
	
	func testAddPointsAndCallback() {
		
		// GIVEN
		var numOfPoints = 0
		let area = Area(with: "identifier")
		area.onPointsChanged = { points in
			numOfPoints = max(numOfPoints, points.count)
		}
		
		// WHEN
		area.add(point: HexPoint(x: 0, y: 0))
		area.add(point: HexPoint(x: 1, y: 0))
		
		// THEN
		XCTAssertEqual(area.count, 2)
		XCTAssertEqual(numOfPoints, 2)
	}
}
