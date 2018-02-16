//
//  Professor.swift
//  agents
//
//  Created by Michael Rommel on 12.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Professor: GameObject {
	
	static let foundVillage = GameObjectAction(named: "FoundVillage")
	
	init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay) {
		super.init(with: identifier, at: point, sprite: "professor18", mapDisplay: mapDisplay)
		
		self.atlasDown = GameObjectAtlas(atlasName: "professor", textures: ["professor18", "professor19", "professor20", "professor21", "professor22", "professor23", "professor24", "professor25", "professor26"])
		self.atlasUp = GameObjectAtlas(atlasName: "professor", textures: ["professor0", "professor1", "professor2", "professor3", "professor4", "professor5", "professor6", "professor7", "professor8"])
		self.atlasLeft = GameObjectAtlas(atlasName: "professor", textures: ["professor9", "professor10", "professor11", "professor12", "professor13", "professor14", "professor15", "professor16", "professor17"])
		self.atlasRight = GameObjectAtlas(atlasName: "professor", textures: ["professor27", "professor28", "professor29", "professor30", "professor31", "professor32", "professor33", "professor34", "professor35"])
	}
	
	override func actions() -> [GameObjectAction] {
		return [Professor.foundVillage, GameObjectActions.walk]
	}
	
	override func execute(action: GameObjectAction) {
		if action == Professor.foundVillage {
			print("...")
			
			// spawn a village
			let village = Village(with: "village", at: self.position, mapDisplay: self.mapDisplay)
			self.engine?.add(gameObject: village)
			
			// let the professor die next turn
			self.state = GameObjectActions.dead
		} else if action == GameObjectActions.walk {
			self.state = GameObjectActions.walk
		}
	}
}
