//
//  Tile.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

enum Terrain {
	
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

enum Feature {
	
	case forest_mixed
	case forest_pine
	
	var description: String {
		switch self {
		case .forest_mixed:
			return "Mixed Forest"
		case .forest_pine:
			return "Pine Forest"
		}
	}
	
	var textureNameHex: String {
		switch self {
		case .forest_mixed:
			return "hex_forest_mixed_summer1"
		case .forest_pine:
			return "hex_forest_pine_summer1"
		}
	}
}

class Tile {
	
	var terrain: Terrain
	var terrainSprite: SKSpriteNode?
	
	var features: [Feature]
	var featureSprites: [SKSpriteNode] = []
	
	var continent: Continent?
	var building: Building
	
	init(withTerrain terrain: Terrain) {
		self.terrain = terrain
		self.features = []
		self.building = .none
	}
	
	func set(feature: Feature) {
		if !self.has(feature: feature) {
			features.append(feature)
		}
	}
	
	func remove(feature: Feature) {
		if self.has(feature: feature) {
			if let index = self.features.index(of: feature) {
				features.remove(at: index)
			}
		}
	}
	
	func has(feature: Feature) -> Bool {
		return self.features.contains(where: { $0 == feature })
	}
}
