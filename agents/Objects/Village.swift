//
//  City.swift
//  agents
//
//  Created by Michael Rommel on 16.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class Village: GameObject {
	
	static let openVillage = GameObjectAction(named: "OpenVillage")
	static let plantField = GameObjectAction(named: "PlantField")
	static let selectedField = GameObjectActionWithPoint(named: "SelectedField")
	
	var counter: Double = 0.0
	
	init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay) {
		super.init(with: identifier, at: point, sprite: "village0", mapDisplay: mapDisplay)
		
		self.sprite.zPosition = GameSceneConstants.ZLevels.staticSprite
		self.sprite.anchorPoint = CGPoint(x: -0.1, y: -0.0)
		
		self.atlasDown = GameObjectAtlas(atlasName: "village", textures: ["village0"])
		self.atlasUp = GameObjectAtlas(atlasName: "village", textures: ["village0"])
		self.atlasLeft = GameObjectAtlas(atlasName: "village", textures: ["village0"])
		self.atlasRight = GameObjectAtlas(atlasName: "village", textures: ["village0"])
	}
	
	override func actions() -> [GameObjectAction] {
		return [Village.openVillage, Village.plantField]
	}
	
	override func execute(action: GameObjectAction) {
		if action == Village.openVillage {
			self.engine?.navigate(segue: "showVillage")
		} else if action == Village.plantField {
	
			self.engine?.askNeighbor(of: self, for: Village.selectedField)
			
		} else if action == Village.selectedField {
			
			let selectedAction = action as! GameObjectActionWithPoint
			
			// spawn a field
			let field = Field(with: "field", at: selectedAction.point!, mapDisplay: self.mapDisplay)
			self.engine?.add(gameObject: field)
		}
	}
	
	override func update(with currentTime: CFTimeInterval) {
		//print("update village: \(currentTime)")
		self.counter += currentTime
	}
}
