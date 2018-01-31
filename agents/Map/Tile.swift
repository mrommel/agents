//
//  Tile.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Terrain: Int {
	
	case plain
	case grass
	case ocean
	
	var description: String {
		switch self {
		case .plain:
			return "Plain"
		case .grass:
			return "Grass"
		case .ocean:
			return "Ocean"
		}
	}
	
	var textureName: String {
		switch self {
		case .plain:
			return "plain"
		case .grass:
			return "grass"
		case .ocean:
			return "ocean"
		}
	}
	
	var textureNameHex: String {
		switch self {
		case .plain:
			return "hex_plain"
		case .grass:
			return "hex_grass"
		case .ocean:
			return "hex_ocean"
		}
	}
}

class Tile {
	var terrain: Terrain
	
	init(withTerrain terrain: Terrain) {
		self.terrain = terrain
	}
}
