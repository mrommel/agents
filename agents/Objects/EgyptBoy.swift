//
//  EgyptBoy.swift
//  agents
//
//  Created by Michael Rommel on 16.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class EgyptBoy: GameObject {
	
	init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay) {
		super.init(with: identifier, at: point, sprite: "egyptboy0", mapDisplay: mapDisplay)
		
		self.sprite.anchorPoint = CGPoint(x: -1.0, y: -0.5)
		
		self.atlasDown = GameObjectAtlas(atlasName: "egyptboy", textures: ["egyptboy0", "egyptboy1", "egyptboy2", "egyptboy3"])
		self.atlasUp = GameObjectAtlas(atlasName: "egyptboy", textures: ["egyptboy12", "egyptboy13", "egyptboy14", "egyptboy15"])
		self.atlasLeft = GameObjectAtlas(atlasName: "egyptboy", textures: ["egyptboy4", "egyptboy5", "egyptboy6", "egyptboy7"])
		self.atlasRight = GameObjectAtlas(atlasName: "egyptboy", textures: ["egyptboy8", "egyptboy9", "egyptboy10", "egyptboy11"])
	}
	
	override func actions() -> [GameObjectAction] {
		return []
	}
}
