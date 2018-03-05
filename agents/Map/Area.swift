//
//  Area.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

protocol AreaDelegate {
	func changed(area: Area?)
}

class Area {
	
	var onPointsChanged: ((_ points: [HexPoint])->())?
	
	var identifier: String
	var points: [HexPoint] {
		didSet {
			onPointsChanged?(points)
		}
	}
	
	init(with identifier: String) {
		self.identifier = identifier
		self.points = []
	}
	
	func add(point: HexPoint) {
		self.points.append(point)
	}
}
