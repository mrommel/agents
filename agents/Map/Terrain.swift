//
//  Terrain.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Terrain {
	
	case plain
	case grass
	case desert
	case tundra
	case snow
	case ocean
	
	// types for map generation
	case water
	case ground
	
	var description: String {
		switch self {
		case .plain:
			return "Plain"
		case .grass:
			return "Grass"
		case .ocean:
			return "Ocean"
		case .desert:
			return "Desert"
		case .tundra:
			return "Tundra"
		case .snow:
			return "Snow"
			
		// -------
		case .water:
			return "Water"
		case .ground:
			return "Ground"
		}
	}
	
	var textureNameHex: String {
		switch self {
		case .plain:
			return "hex_plain"
		case .grass:
			return "hex_grass"
		case .desert:
			return "hex_desert" // TODO
		case .tundra:
			return "hex_tundra" // TODO
		case .snow:
			return "hex_snow" // TODO
		case .ocean:
			return "hex_ocean"
			
		// -------
		case .water, .ground:
			return "---"
		}
	}
}
