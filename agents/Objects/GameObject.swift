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

class GameObject {
	
	var sprite: SKSpriteNode
	var position: HexPoint
	let mapDisplay: HexMapDisplay
	
	var atlasDown: GameObjectAtlas?
	var atlasUp: GameObjectAtlas?
	var atlasRight: GameObjectAtlas?
	var atlasLeft: GameObjectAtlas?
	
	init(at point: HexPoint, sprite: String, mapDisplay: HexMapDisplay) {
		self.mapDisplay = mapDisplay
		self.position = point
		self.sprite = SKSpriteNode(imageNamed: sprite)
		self.sprite.position = mapDisplay.toScreen(hex: self.position)
		self.sprite.zPosition = GameSceneConstants.ZLevels.sprite
		self.sprite.anchorPoint = CGPoint(x: -0.25, y: -0.25)
	}
	
	func animateDown(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		if let atlasDown = self.atlasDown {
			let textureAtlasWalkDown = SKTextureAtlas(named: atlasDown.atlasName)
			let walkDownFrames = atlasDown.textures.map { textureAtlasWalkDown.textureNamed($0) }
			let walkDown = SKAction.animate(with: walkDownFrames, timePerFrame: 2.0 / Double(walkDownFrames.count))
			
			let moveDown = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkDown.duration)
			
			let animate = SKAction.group([walkDown, moveDown])
			self.sprite.run(animate, completion: {
				self.position = hex
				block()
			})
		}
	}
	
	func animateUp(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		if let atlasUp = self.atlasUp {
			let textureAtlasWalkUp = SKTextureAtlas(named: atlasUp.atlasName)
			let walkUpFrames = atlasUp.textures.map { textureAtlasWalkUp.textureNamed($0) }
			let walkUp = SKAction.animate(with: walkUpFrames, timePerFrame: 2.0 / Double(walkUpFrames.count))
			
			let moveUp = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkUp.duration)
			
			let animate = SKAction.group([walkUp, moveUp])
			self.sprite.run(animate, completion: {
				self.position = hex
				block()
			})
		}
	}
	
	func animateLeft(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		if let atlasLeft = self.atlasLeft {
			let textureAtlasWalkLeft = SKTextureAtlas(named: atlasLeft.atlasName)
			let walkLeftFrames = atlasLeft.textures.map { textureAtlasWalkLeft.textureNamed($0) }
			let walkLeft = SKAction.animate(with: walkLeftFrames, timePerFrame: 2.0 / Double(walkLeftFrames.count))
			
			let moveLeft = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkLeft.duration)
			
			let animate = SKAction.group([walkLeft, moveLeft])
			self.sprite.run(animate, completion: {
				self.position = hex
				block()
			})
		}
	}
	
	func animateRight(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		if let atlasRight = self.atlasRight {
			let textureAtlasWalkRight = SKTextureAtlas(named: atlasRight.atlasName)
			let walkRightFrames = atlasRight.textures.map { textureAtlasWalkRight.textureNamed($0) }
			let walkRight = SKAction.animate(with: walkRightFrames, timePerFrame: 2.0 / Double(walkRightFrames.count))
			
			let moveRight = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkRight.duration)
			
			let animate = SKAction.group([walkRight, moveRight])
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
			self.animateUp(to: to, completion: block)
			break
		case .northeast, .southeast:
			self.animateRight(to: to, completion: block)
			break
		case .south:
			self.animateDown(to: to, completion: block)
			break
		case .southwest, .northwest:
			self.animateLeft(to: to, completion: block)
			break
		}
	}
	
	func animate(on path: [HexPoint]) {
		
		guard path.count > 0 else {
			return
		}
		
		if let point = path.first {
			let pathWithoutFirst = Array(path.suffix(from: 1))
			
			self.animate(from: self.position, to: point, completion: {
				self.animate(on: pathWithoutFirst)
			})
		}
	}
}
