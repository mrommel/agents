//
//  GamesObjectState.swift
//  agents
//
//  Created by Michael Rommel on 16.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class GameObjectAction {
	
	let identifier: String
	
	init(named identifier: String) {
		self.identifier = identifier
	}
}

extension GameObjectAction: CustomDebugStringConvertible {
	var debugDescription: String {
		return "GameObjectAction - \(self.identifier)"
	}
}

extension GameObjectAction: Equatable {
	
	var hashValue: Int {
		return self.identifier.hashValue
	}
}

func == (first: GameObjectAction, second: GameObjectAction) -> Bool {
	return first.identifier == second.identifier
}

class GameObjectActionWithPoint: GameObjectAction {
	
	var point: HexPoint? = nil
	
	override init(named identifier: String) {
		super.init(named: identifier)
	}
}

struct GameObjectActions {
	
	static let idle = GameObjectAction(named: "Idle")
	static let walk = GameObjectAction(named: "Walk")
	static let dead = GameObjectAction(named: "Dead")
}
