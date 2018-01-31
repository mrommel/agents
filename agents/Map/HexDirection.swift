//
//  Direction.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum HexDirection {
	
	case north
	case northeast
	case southeast
	case south
	case southwest
	case northwest
	
	static var all: [HexDirection] {
		get {
			return [.north, .northeast, .southeast, .south, .southwest, .northwest]
		}
	}
	
	var description: String {
		switch self {
		case .north:
			return "North"
		case .northeast:
			return "North East"
		case .southeast:
			return "South East"
		case .south:
			return "South"
		case .southwest:
			return "South West"
		case .northwest:
			return "North West"
		}
	}
}
