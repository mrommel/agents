//
//  AreaSprites.swift
//  agents
//
//  Created by Michael Rommel on 05.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class AreaSprites: SKNode {
	
	private let mapDisplay: HexMapDisplay?
	private var sprites: [SKSpriteNode]
	
	init(with mapDisplay: HexMapDisplay?) {
		
		self.mapDisplay = mapDisplay
		self.sprites = []
		
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func texture(for point: HexPoint, in points: [HexPoint]) -> String {
		
		var tex = "hex_border_"
		
		if !points.contains(where: { $0 == point.neighbor(in: .north) }) {
			tex += "n_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .northeast) }) {
			tex += "ne_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .southeast) }) {
			tex += "se_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .south) }) {
			tex += "s_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .southwest) }) {
			tex += "sw_"
		}
		
		if !points.contains(where: { $0 == point.neighbor(in: .northwest) }) {
			tex += "nw_"
		}
		
		if tex == "hex_border_" {
			return "hex_border_all"
		}
		
		tex.removeLast()
		return tex
	}
	
	func rebuild(with points: [HexPoint]) {
		
		// remove old sprites
		for sprite in self.sprites {
			sprite.removeFromParent()
		}
		self.sprites.removeAll()
		
		for point in points {
			
			if let position = self.mapDisplay?.toScreen(hex: point) {
				
				let textureName = self.texture(for: point, in: points)
				let sprite = SKSpriteNode(imageNamed: textureName)
				sprite.position = position
				sprite.zPosition = GameSceneConstants.ZLevels.area
				sprite.anchorPoint = CGPoint(x: 0, y: 0)
				self.addChild(sprite)
				
				self.sprites.append(sprite)
			}
		}
	}
}
