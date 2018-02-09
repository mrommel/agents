//
//  GameScene+Guy.swift
//  agents
//
//  Created by Michael Rommel on 04.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
	
	func placeGuy() {
		
		self.guy = SKSpriteNode(imageNamed: "professor18")
		self.guy?.position = mapDisplay.toScreen(hex: guyHex)
		self.guy?.zPosition = GameSceneConstants.ZLevels.sprite
		self.guy?.anchorPoint = CGPoint(x: -0.25, y: -0.25)
		layerHexGround.addChild(self.guy!)
	}
	
	func animateGuyDown(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		let textureAtlasWalkDown = SKTextureAtlas(named: "professor_walk_down")
		let walkDownFrames = ["professor18", "professor19", "professor20", "professor21", "professor22", "professor23", "professor24", "professor25", "professor26"].map { textureAtlasWalkDown.textureNamed($0) }
		let walkDown = SKAction.animate(with: walkDownFrames, timePerFrame: 0.2)
		
		let moveDown = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkDown.duration)
		
		let animate = SKAction.group([walkDown, moveDown])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
			block()
		})
	}
	
	func animateGuyUp(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		let textureAtlasWalkUp = SKTextureAtlas(named: "professor_walk_up")
		let walkUpFrames = ["professor0", "professor1", "professor2", "professor3", "professor4", "professor5", "professor6", "professor7", "professor8"].map { textureAtlasWalkUp.textureNamed($0) }
		let walkUp = SKAction.animate(with: walkUpFrames, timePerFrame: 0.2)
		
		let moveUp = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkUp.duration)
		
		let animate = SKAction.group([walkUp, moveUp])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
			block()
		})
	}
	
	func animateGuyLeft(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		let textureAtlasWalkLeft = SKTextureAtlas(named: "professor_walk_left")
		let walkLeftFrames = ["professor9", "professor10", "professor11", "professor12", "professor13", "professor14", "professor15", "professor16", "professor17"].map { textureAtlasWalkLeft.textureNamed($0) }
		let walkLeft = SKAction.animate(with: walkLeftFrames, timePerFrame: 0.2)
		
		let moveLeft = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkLeft.duration)
		
		let animate = SKAction.group([walkLeft, moveLeft])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
			block()
		})
	}
	
	func animateGuyRight(to hex: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		let textureAtlasWalkRight = SKTextureAtlas(named: "professor_walk_right")
		let walkRightFrames = ["professor27", "professor28", "professor29", "professor30", "professor31", "professor32", "professor33", "professor34", "professor35"].map { textureAtlasWalkRight.textureNamed($0) }
		let walkRight = SKAction.animate(with: walkRightFrames, timePerFrame: 0.2)
		
		let moveRight = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walkRight.duration)
		
		let animate = SKAction.group([walkRight, moveRight])
		self.guy?.run(animate, completion: {
			self.guyHex = hex
			block()
		})
	}
	
	func animateGuy(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {
		
		let direction = self.mapDisplay.screenDirection(from: from, towards: to)
		
		switch direction {
		case .north:
			self.animateGuyUp(to: to, completion: block)
			break
		case .northeast, .southeast:
			self.animateGuyRight(to: to, completion: block)
			break
		case .south:
			self.animateGuyDown(to: to, completion: block)
			break
		case .southwest, .northwest:
			self.animateGuyLeft(to: to, completion: block)
			break
		}
	}
	
	func animateGuy(on path: [HexPoint]) {

		guard path.count > 0 else {
			return
		}
		
		if let point = path.first {
			let pathWithoutFirst = Array(path.suffix(from: 1))
		
			self.animateGuy(from: self.guyHex, to: point, completion: {
				self.animateGuy(on: pathWithoutFirst)
			})
		}
	}
}
