//
//  Property.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Property {

	let name: String
	let description: String
	let category: Category
	var values: [Double] = []
	var inputs: [PropertyRelation] = []

	var stashedValue: Double = 0.0

	init(name: String, description: String, category: Category, value: Double) {
		self.name = name
		self.description = description
		self.category = category
		self.values.append(value)
	}

	func add(property: Property, formula: String = "x", delay: Int = 0) {
		self.add(propertyRelation: PropertyRelation(property: property, formula: formula, delay: delay))
	}

	func add(propertyRelation: PropertyRelation) {
		self.inputs.append(propertyRelation)
	}

	func calculate() {

		self.stashedValue = 0.0

		for relation in self.inputs {

			let expression = NSExpression(format: relation.formula)
			let dict = NSMutableDictionary()
			dict.setValue(self.value(with: 0), forKey: "v")
			dict.setValue(relation.property.value(with: relation.delay), forKey: "x")
			if let tempVal = expression.expressionValue(with: dict, context: nil) as? Double {
				self.stashedValue += tempVal
			}
		}
	}

	func push() {
		self.push(value: self.stashedValue)
	}

	func value(with delay: Int = 0) -> Double {
		if self.values.count > delay {
			return self.values[delay]
		}

		return self.values[0]
	}

	func push(value: Double) {
		self.values.insert(value, at: 0)
	}

	func valueText() -> String {
		return "\(self.value().format(with: ".2"))"
	}

	func nameOfValue(from steps: [String]) -> String {

		let stepIncrement = 1.0 / Double(steps.count)
		var stepValue = 0.0

		for step in steps {
			if self.value().between(from: stepValue, to: stepValue + stepIncrement) {
				return step
			}

			stepValue += stepIncrement
		}

		return "---"
	}
}
