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
	
	static let chopForest = GameObjectAction(named: "ChopForest")
	static let selectedForest = GameObjectActionWithPoint(named: "SelectedForest")
	
	var counter: Double = 0.0
	
	init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay) {
		super.init(with: identifier, at: point, sprite: "village0", mapDisplay: mapDisplay)
		
		self.sprite.zPosition = GameSceneConstants.ZLevels.staticSprite
		self.sprite.anchorPoint = CGPoint(x: -0.0, y: -0.0)
		
		self.atlasDown = GameObjectAtlas(atlasName: "village", textures: ["village0"])
		self.atlasUp = GameObjectAtlas(atlasName: "village", textures: ["village0"])
		self.atlasLeft = GameObjectAtlas(atlasName: "village", textures: ["village0"])
		self.atlasRight = GameObjectAtlas(atlasName: "village", textures: ["village0"])
	}
	
	override func actions() -> [GameObjectAction] {
		return [Village.openVillage, Village.plantField, Village.chopForest]
	}
	
	override func execute(action: GameObjectAction) {
		
		if action == Village.openVillage {
			self.engine?.navigate(segue: "showVillage")
		} else if action == Village.plantField {
			self.engine?.askNeighbor(of: self, for: Village.selectedField)
		} else if action == Village.selectedField {
			
			let selectedAction = action as! GameObjectActionWithPoint
			
			// add to map
			self.engine?.scene.map.set(building: .wheat, at: selectedAction.point!)
			
			// spawn a field game object
			let field = Field(with: "field", at: selectedAction.point!, mapDisplay: self.mapDisplay)
			self.engine?.add(gameObject: field)
			
			// make reference to village
			// ...
		} else if action == Village.chopForest {
			self.engine?.askNeighbor(of: self, for: Village.selectedForest)
		} else if action == Village.selectedForest {
		
			let selectedAction = action as! GameObjectActionWithPoint
			
			if let tile = self.engine?.scene.map.tile(at: selectedAction.point!), let point = selectedAction.point {
				
				// remove forest
				if tile.has(feature: .forestMixed) {
					self.engine?.scene.map.remove(feature: .forestMixed, at: point)
				} else if tile.has(feature: .forestPine) {
					self.engine?.scene.map.remove(feature: .forestPine, at: point)
				}
				
				// remove sprites
				for sprite in tile.featureSprites {
					sprite.removeFromParent()
				}
				tile.featureSprites = []
				
				tile.terrainSprite?.removeFromParent()
				tile.terrainSprite = nil
				
				let screenPoint = self.mapDisplay.toScreen(hex: point)
				self.engine?.scene.placeTileHex(tile: tile, position: screenPoint)
				
				// collect wood
				// ...
			}
		}
	}
	
	override func canApply(action: GameObjectAction, on point: HexPoint) -> Bool {
		
		if action == Village.selectedField {
			if let tile = self.engine?.scene.map.tile(at: point) {
				return tile.terrain != .ocean && tile.building == .none && !(tile.has(feature: .forestMixed) || tile.has(feature: .forestPine))
			}
		} else {
			if let tile = self.engine?.scene.map.tile(at: point) {
				return tile.terrain != .ocean && (tile.has(feature: .forestMixed) || tile.has(feature: .forestPine))
			}
		}
		
		return false
	}
	
	override func update(with currentTime: CFTimeInterval) {
		//print("update village: \(currentTime)")
		self.counter += currentTime
	}
}
