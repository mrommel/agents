//
//  Direction.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Direction: Int {
	
	case N // 0
	case NE // 1
	case E
	case SE // 3
	case S // 4
	case SW // 5
	case W
	case NW // 7
	
	var description: String {
		switch self {
		case .N:
			return "North"
		case .NE:
			return "North East"
		case .E:
			return "East"
		case .SE:
			return "South East"
		case .S:
			return "South"
		case .SW:
			return "South West"
		case .W:
			return "West"
		case .NW:
			return "North West"
		}
	}
}
