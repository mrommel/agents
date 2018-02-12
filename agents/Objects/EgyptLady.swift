//
//  EgyptLady.swift
//  agents
//
//  Created by Michael Rommel on 12.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SceneKit

class EgyptLady: GameObject {
	
	init(at point: HexPoint, mapDisplay: HexMapDisplay) {
		super.init(at: point, sprite: "lady0", mapDisplay: mapDisplay)
		
		self.sprite.anchorPoint = CGPoint(x: -1.0, y: -0.5)
		
		self.atlasDown = GameObjectAtlas(atlasName: "egyptlady_walk_down", textures: ["lady0", "lady1", "lady2", "lady3"])
		self.atlasUp = GameObjectAtlas(atlasName: "egyptlady_walk_up", textures: ["lady12", "lady13", "lady14", "lady15"])
		self.atlasLeft = GameObjectAtlas(atlasName: "egyptlady_walk_left", textures: ["lady4", "lady5", "lady6", "lady7"])
		self.atlasRight = GameObjectAtlas(atlasName: "egyptlady_walk_right", textures: ["lady8", "lady9", "lady10", "lady11"])
	}
}
