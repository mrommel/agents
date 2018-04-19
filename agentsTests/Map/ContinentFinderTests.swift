//
//  ContinentFinderTests.swift
//  agentsTests
//
//  Created by Michael Rommel on 19.04.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import XCTest
@testable import agents

class ContinentFinderTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testExecute() {
		
		// GIVEN
		let continentFinder = ContinentFinder(width: 3, height: 3)
		let tileHexMap = TileHexMap(width: 3, height: 3)
		tileHexMap.set(terrain: .grass, at: HexPoint(x: 0, y: 0))
		tileHexMap.set(terrain: .grass, at: HexPoint(x: 2, y: 1))
		tileHexMap.set(terrain: .grass, at: HexPoint(x: 2, y: 2))
		
		// WHEN
		let continents = continentFinder.execute(on: tileHexMap)
		
		// THEN
		XCTAssertEqual(continents.count, 2)
		XCTAssertEqual(continents[0].points.count, 1)
		XCTAssertEqual(continents[1].points.count, 2)
	}
}

