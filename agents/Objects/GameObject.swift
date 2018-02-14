//
//  GameObject.swift
//  agents
//
//  Created by Michael Rommel on 12.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class GameObjectAtlas {
	
	let atlasName: String
	let textures: [String]
	
	init(atlasName: String, textures: [String]) {
		self.atlasName = atlasName
		self.textures = textures
	}
}

enum GameObjectState {
	
	case idle
	case walking
	case dead
}

class GameObject {
	
	let identifier: String
	var position: HexPoint
	var state: GameObjectState = .idle {
		didSet {
			print("state changed from \(oldValue) to \(state)")
		}
	}
	
	var sprite: SKSpriteNode
	let mapDisplay: HexMapDisplay
	
	var atlasDown: GameObjectAtlas?
	var atlasUp: GameObjectAtlas?
	var atlasRight: GameObjectAtlas?
	var atlasLeft: GameObjectAtlas?
	
	init(with identifier: String, at point: HexPoint, sprite: String, mapDisplay: HexMapDisplay) {
		self.identifier = identifier
		self.mapDisplay = mapDisplay
		self.position = point
		self.sprite = SKSpriteNode(imageNamed: sprite)
		self.sprite.position = mapDisplay.toScreen(hex: self.position)
		self.sprite.zPosition = GameSceneConstants.ZLevels.sprite
		self.sprite.anchorPoint = CGPoint(x: -0.25, y: -0.25)
	}
	
	func animate(to hex: HexPoint, on atlas: GameObjectAtlas?, completion block: @escaping () -> Swift.Void) {
		
		if let atlas = atlas {
			let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
			let walkFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
			let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap{$0}, timePerFrame: 2.0 / Double(walkFrames.count * 3))
			
			let move = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walk.duration)
			
			let animate = SKAction.group([walk, move])
			self.sprite.run(animate, completion: {
				self.position = hex
				block()
			})
		}
	}
	
	func animate(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		let direction = self.mapDisplay.screenDirection(from: from, towards: to)
		
		switch direction {
		case .north:
			self.animate(to: to, on: self.atlasUp, completion: block)
			break
		case .northeast, .southeast:
			self.animate(to: to, on: self.atlasRight, completion: block)
			break
		case .south:
			self.animate(to: to, on: self.atlasDown, completion: block)
			break
		case .southwest, .northwest:
			self.animate(to: to, on: self.atlasLeft, completion: block)
			break
		}
	}
	
	func animate(on path: [HexPoint]) {
		
		self.state = .walking
		
		guard path.count > 0 else {
			self.state = .idle
			return
		}
		
		if let point = path.first {
			let pathWithoutFirst = Array(path.suffix(from: 1))
			
			self.animate(from: self.position, to: point, completion: {
				self.animate(on: pathWithoutFirst)
			})
		}
	}
	
	func clean() {
		sprite.removeFromParent()
	}
}

extension GameObject: Equatable {
	
	var hashValue: Int {
		return self.identifier.hashValue
	}
}

func == (first: GameObject, second: GameObject) -> Bool {
	return first.identifier == second.identifier
}
