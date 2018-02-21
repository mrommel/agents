//
//  Field.swift
//  agents
//
//  Created by Michael Rommel on 21.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class Field: GameObject {

	enum FieldState: String {
		case empty = "hex_wheat_field0"
		case state1 = "hex_wheat_field1"
		case state2 = "hex_wheat_field2"
		case state3 = "hex_wheat_field3"
		case ready = "hex_wheat_field4"
	}
	
	var fieldState: FieldState = .empty
	var counter: Double = 0.0
	
	init(with identifier: String, at point: HexPoint, mapDisplay: HexMapDisplay) {
		super.init(with: identifier, at: point, sprite: fieldState.rawValue, mapDisplay: mapDisplay)
		
		self.sprite.zPosition = GameSceneConstants.ZLevels.staticSprite
		self.sprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
		
		self.atlasDown = GameObjectAtlas(atlasName: "field", textures: ["hex_wheat_field0"])
		self.atlasUp = GameObjectAtlas(atlasName: "field", textures: ["hex_wheat_field0"])
		self.atlasLeft = GameObjectAtlas(atlasName: "field", textures: ["hex_wheat_field0"])
		self.atlasRight = GameObjectAtlas(atlasName: "field", textures: ["hex_wheat_field0"])
	}
	
	func grow() {
		switch self.fieldState {
		case .empty:
			self.fieldState = .state1
			break
		case .state1:
			self.fieldState = .state2
			break
		case .state2:
			self.fieldState = .state3
			break
		case .state3:
			self.fieldState = .ready
			break
		case .ready:
			self.fieldState = .empty
			break
		}
		
		self.sprite.texture = SKTexture.init(imageNamed: self.fieldState.rawValue)
	}
	
	override func update(with currentTime: CFTimeInterval) {
		
		if self.lastTime > 0 {
			let deltaTime = currentTime - self.lastTime
			self.counter += deltaTime
			
			if self.counter > 10 {
				self.grow()
				self.counter = 0.0
			}
		}
		
		self.lastTime = currentTime
	}
}
