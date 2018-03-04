//
//  ClimateZone.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum ClimateZone: Int {
	
	case polar
	case subpolar
	case temperate
	case subtropic
	case tropic
	
	var moderate: ClimateZone {
		switch self {
		case .polar:
			return .subpolar
		case .subpolar:
			return .temperate
		case .temperate:
			return .subtropic
		case .subtropic:
			return .subtropic
		case .tropic:
			return .tropic
		}
	}
}
