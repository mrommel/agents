//
//  Action.swift
//  agents
//
//  Created by Michael Rommel on 23.01.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Action: Int {
	case Idle, Move
	
	var description: String {
		switch self {
		case .Idle:
			return "Idle"
		case .Move:
			return "Move"
		}
	}
}
