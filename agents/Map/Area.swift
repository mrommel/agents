//
//  Area.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

protocol AreaDelegate: class {
	func changed(area: Area?)
}

/// class that holds a couple of points
class Area {

	var onPointsChanged: ((_ points: [HexPoint]) -> Void)?

	var identifier: String
	private var points: [HexPoint] {
		didSet {
			onPointsChanged?(points)
		}
	}

	var count: Int {
		return self.points.count
	}

	// MARK: constructors

	init(with identifier: String) {
		self.identifier = identifier
		self.points = []
	}

	// MARK: methods

	func add(point: HexPoint) {
		self.points.append(point)
	}
}
