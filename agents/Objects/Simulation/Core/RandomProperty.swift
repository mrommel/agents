//
//  RandomProperty.swift
//  agents
//
//  Created by Michael Rommel on 12.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class RandomProperty: Property {

	var minimum: Double = 0.0
	var maximum: Double = 0.0

	init(minimum: Double, maximum: Double) {

		self.minimum = minimum
		self.maximum = maximum

		let randomValue = Double.random(in: self.minimum ..< self.maximum)

		super.init(name: "random", summary: "random description", category: .static, value: randomValue)
	}

	override func calculate() {
		self.stashedValue = Double.random(in: self.minimum ..< self.maximum)
	}
}
