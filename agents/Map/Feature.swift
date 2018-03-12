//
//  Feature.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Feature {
	
	case forest_mixed
	case forest_pine
	case forest_rain
	case oasis
	
	case hill
	case mountain
	
	var description: String {
		switch self {
		case .forest_mixed:
			return "Mixed Forest"
		case .forest_pine:
			return "Pine Forest"
		case .forest_rain:
			return "Rain Forest"
		case .oasis:
			return "Oasis"
		case .hill:
			return "Hill"
		case .mountain:
			return "Mountain"
		}
	}
	
	var textureNameHex: String {
		switch self {
		case .forest_mixed:
			return "hex_forest_mixed_summer1"
		case .forest_pine:
			return "hex_forest_pine_summer1"
		case .forest_rain:
			return "hex_forest_rain"
		case .oasis:
			return "hex_oasis"
		case .hill:
			return "hex_hill"
		case .mountain:
			return "hex_mountain"
		}
	}
}
