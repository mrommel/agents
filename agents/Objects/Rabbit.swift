//
//  Rabbit.swift
//  agents
//
//  Created by Michael Rommel on 13.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SceneKit

class Rabbit: GameObject {
	
	init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay) {
		super.init(with: identifier, at: point, sprite: "rabbit0", mapDisplay: mapDisplay)
		
		self.sprite.anchorPoint = CGPoint(x: -0.5, y: -0.5)
		
		self.atlasDown = GameObjectAtlas(atlasName: "rabbit", textures: ["rabbit0", "rabbit1", "rabbit2"])
		self.atlasUp = GameObjectAtlas(atlasName: "rabbit", textures: ["rabbit36", "rabbit37", "rabbit37"])
		self.atlasLeft = GameObjectAtlas(atlasName: "rabbit", textures: ["rabbit12", "rabbit13", "rabbit14"])
		self.atlasRight = GameObjectAtlas(atlasName: "rabbit", textures: ["rabbit24", "rabbit25", "rabbit26"])
	}
}
