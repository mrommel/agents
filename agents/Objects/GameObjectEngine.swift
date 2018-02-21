//
//  GameObjectEngine.swift
//  agents
//
//  Created by Michael Rommel on 14.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class GameObjectEngine {
	
	fileprivate var objects: [GameObject]
	fileprivate let layer: SKNode
	fileprivate let scene: GameScene
	var focusedObject: GameObject? = nil
	
	init(on layer: SKNode, in scene: GameScene) {
		self.objects = []
		self.layer = layer
		self.scene = scene
	}
	
	func add(gameObject: GameObject) {
		gameObject.engine = self
		self.layer.addChild(gameObject.sprite)
		self.objects.append(gameObject)
	}
	
	func update(with currentTime: CFTimeInterval) {
		
		for object in self.objects {
			
			// update each object
			object.update(with: currentTime)
			
			// remove dead objects
			if object.state == GameObjectActions.dead {
				object.clean()
				let objectIndex = self.objects.index(where: { return $0 == object })
				self.objects.remove(at: objectIndex!)
			}
		}
	}
	
	func object(at hex: HexPoint) -> GameObject? {
		return self.objects.first(where: { return $0.position == hex })
	}
	
	func navigate(segue: String) {
		self.scene.viewController?.performSegue(withIdentifier: segue, sender: nil)
	}
	
	func askNeighbor(of gameObject: GameObject, for action: GameObjectActionWithPoint) {
		
		self.scene.showNeighborPicker(of: gameObject, for: action)
	}
}
