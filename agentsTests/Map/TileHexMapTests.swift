//
//  TileHexMapTests.swift
//  agentsTests
//
//  Created by Michael Rommel on 19.04.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import XCTest
@testable import agents

class TileHexMapTests: XCTestCase {
	
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
		let tileHexMap = TileHexMap(width: 2, height: 2)
		
		// THEN
		XCTAssertEqual(tileHexMap.tile(x: 0, y: 0)?.terrain, .ocean)
		XCTAssertEqual(tileHexMap.tile(x: 0, y: 1)?.terrain, .ocean)
		XCTAssertEqual(tileHexMap.tile(x: 1, y: 0)?.terrain, .ocean)
		XCTAssertEqual(tileHexMap.tile(x: 1, y: 1)?.terrain, .ocean)
	}
}
