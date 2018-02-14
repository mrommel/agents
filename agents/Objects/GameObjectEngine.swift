//
//  GameObjectEngine.swift
//  agents
//
//  Created by Michael Rommel on 14.02.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class GameObjectEngine {
	
	var objects: [GameObject]
	
	init() {
		self.objects = []
	}
	
	func add(gameObject: GameObject) {
		self.objects.append(gameObject)
	}
	
	func update(_ currentTime: CFTimeInterval) {
		
		for object in self.objects {
			switch object.state {
			case .idle:
				if object.position == HexPoint(x: 3, y: 3) {
					object.state = .dead
				}
				break
			case .walking:
				break
			case .dead:
				object.clean()
				let objectIndex = self.objects.index(where: { return $0 == object })
				self.objects.remove(at: objectIndex!)
				break
			}
		}
	}
}
