//
//  Event.swift
//  agents
//
//  Created by Michael Rommel on 10.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Event: Property {

	private var enabled: Bool = false

	init(name: String, description: String, category: Category, enabled: Bool = false) {

		self.enabled = enabled

		super.init(name: name, description: description, category: category, value: self.enabled ? 1.0 : 0.0)
	}

	override func calculate() {

		self.stashedValue = self.enabled ? 1.0 : 0.0
	}

	override func add(property: Property, formula: String = "x", delay: Int = 0) {
		assert(false, "Events can't have external impact")
	}

	override func add(propertyRelation: PropertyRelation) {
		assert(false, "Events can't have external impact")
	}

	func evaluatePropability() {
		assert(false, "must be overriden by sub class")
	}
}
