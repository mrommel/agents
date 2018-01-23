//
//  Tile.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Tile: Int {
	
	case Ground
	case Wall
	case Droid
	case Grass
	
	var description: String {
		switch self {
		case .Ground:
			return "Ground"
		case .Wall:
			return "Wall"
		case .Droid:
			return "Droid"
		case .Grass:
			return "Grass"
		}
	}
}
