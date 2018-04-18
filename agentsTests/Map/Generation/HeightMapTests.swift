//
//  HeightMapTests.swift
//  agentsTests
//
//  Created by Michael Rommel on 18.04.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import XCTest
@testable import agents

class HeightMapTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testPercentageBelow_all() {
		
		// GIVEN
		let heightMap = HeightMap(width: 2, height: 2)
		heightMap.fill(with: { x, y in
			return 0.0
		})
		
		// WHEN
		let percentageBelow = heightMap.percentage(below: 0.5)
		
		// THEN
		XCTAssertEqual(percentageBelow, 1.0)
	}
	
	func testPercentageBelow_nothing() {
		
		// GIVEN
		let heightMap = HeightMap(width: 2, height: 2)
		heightMap.fill(with: { x, y in
			return 1.0
		})
		
		// WHEN
		let percentageBelow = heightMap.percentage(below: 0.5)
		
		// THEN
		XCTAssertEqual(percentageBelow, 0.0)
	}
	
	func testPercentageBelow_some() {
		
		// GIVEN
		let heightMap = HeightMap(width: 2, height: 2)
		heightMap.fill(with: { x, y in
			return x == y ? 0.0 : 1.0
		})
		
		// WHEN
		let percentageBelow = heightMap.percentage(below: 0.5)
		
		// THEN
		XCTAssertEqual(percentageBelow, 0.5)
	}
	
	func testFindWaterLevel() {
		
		// GIVEN
		let heightMap = HeightMap(width: 2, height: 2)
		heightMap.fill(with: { x, y in
			if x == 0 && y == 0 {
				return 0.0
			} else if x == 1 && y == 0 {
				return 0.2
			} else if x == 0 && y == 1 {
				return 0.3
			} else {
				return 1.0
			}
		})
		
		// WHEN
		let waterLevel = heightMap.findWaterLevel(forWaterPercentage: 0.5)
		
		// THEN
		XCTAssertEqual(waterLevel, 0.25)
	}
}
