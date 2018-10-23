//
//  Technic.swift
//  agents
//
//  Created by Michael Rommel on 23.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Technic {

	var name: String
	var era: Era
	var propability: Double // 0..1 - 0.1 means 10%
	fileprivate var requirements: [Technic] = []
	var invented: Bool

	init(name: String, era: Era, propability: Double, invented: Bool = false) {
		self.name = name
		self.era = era
		self.propability = propability
		self.invented = invented
	}

	func add(requirement: Technic) {
		self.requirements.append(requirement)
	}

	func setup(with simulation: GlobalSimulation) {
		assertionFailure("Subclasses need to implement this method")
	}

	func evaluate() {

		if self.invented {
			return
		}

		// check if all requirements are valid
		self.requirements.forEach { if !$0.invented { return } }

		// random number
		if Double.random(minimum: 0.0, maximum: 1.0) < propability {
			self.invented = true
		}
	}
}
