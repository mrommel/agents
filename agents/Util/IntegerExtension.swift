//
//  IntegerExtension.swift
//  agents
//
//  Created by Michael Rommel on 25.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

extension Int {
	
	public func sign() -> Int {
		return (self < 0 ? -1 : 1)
	}
	/* or, use signature: func sign() -> Self */
}

extension Int {
	
	// Returns a random Int point number between 0 and Int.max.
	public static var random: Int {
		get {
			return Int.random(num: Int.max)
		}
	}
	
	/**
	Random integer between 0 and n-1.
	
	- parameter num: Int
	
	- returns: Int
	*/
	public static func random(num: Int) -> Int {
		return Int(arc4random_uniform(UInt32(num)))
	}
	
	/**
	Random integer between min and max
	
	- parameter min: Int
	- parameter max: Int
	
	- returns: Int
	*/
	public static func random(min: Int = 0, max: Int) -> Int {
		return Int.random(num: max - min + 1) + min
	}
}
