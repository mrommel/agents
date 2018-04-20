//
//  HexPointTests.swift
//  agentsTests
//
//  Created by Michael Rommel on 20.04.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import XCTest
@testable import agents

class HexPointTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testHexCubeConstructor() {
		
		// GIVEN
		
		// WHEN
		let hexPoint0 = HexPoint(cube: HexCube(q: 1, s: 1))
		let hexPoint1 = HexPoint(cube: HexCube(q: 5, s: 3))
		let hexPoint2 = HexPoint(cube: HexCube(q: 2, s: 3))
		
		// THEN
		XCTAssertEqual(hexPoint0.x, 2)
		XCTAssertEqual(hexPoint0.y, 1)
		XCTAssertEqual(hexPoint1.x, 7)
		XCTAssertEqual(hexPoint1.y, 3)
		XCTAssertEqual(hexPoint2.x, 4)
		XCTAssertEqual(hexPoint2.y, 3)
	}
	
	func testHexCubeConstructor2() {
		
		// GIVEN
		
		// WHEN
		let hexPoint0 = HexPoint(cube: HexCube(q: 1, s: 1))
		let hexPoint1 = HexPoint(cube: HexCube(q: 1, r: -2, s: 1))
		
		// THEN
		XCTAssertEqual(hexPoint0, hexPoint1)
	}
	
	func testHexCubeDistance() {
		
		// GIVEN
		let cube0 = HexCube(q: 0, s: 0)
		let cube1 = HexCube(q: 3, s: 4)
		
		// WHEN
		let distance  = cube0.distance(to: cube1)
		
		// THEN
		XCTAssertEqual(distance, 7)
	}
}
