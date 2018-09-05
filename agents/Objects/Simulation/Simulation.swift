//
//  Simulation.swift
//  agents
//
//  Created by Michael Rommel on 04.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum Category {
	case core

	case economy
	case welfare
	case foreign
	case lawOrder
	case publicServices
}

class Property {

	let name: String
	let category: Category
	var values: [Double] = []
	var inputs: [PropertyRelation] = []

	var stashedValue: Double = 0.0

	init(name: String, category: Category, value: Double) {
		self.name = name
		self.category = category
		self.values.append(value)
	}

	func add(property: Property, formula: String, delay: Int = 0) {
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
}

class PropertyRelation {
	let property: Property
	let formula: String
	let delay: Int

	init(property: Property, formula: String, delay: Int = 0) {
		self.property = property
		self.formula = formula
		self.delay = 0
	}
}

protocol SimulationDelegate {
	func iterationComplete()
}

class Simulation {

	var delegate: SimulationDelegate?

	// Values
	var population: Property

	var birthRate: Property
	var happiness: Property

	// Policies

	init() {
		self.population = Property(name: "Population", category: .core, value: 1000) // total number

		// https://de.wikipedia.org/wiki/Zusammengefasste_Fruchtbarkeitsziffer
		self.birthRate = Property(name: "BirthRate", category: .core, value: 0.5) // 0..<10
		self.happiness = Property(name: "Happiness", category: .core, value: 0.8) // in percent

		//self.fertilityRate.add(property: happiness, formula: "0.9*x")
		self.population.add(property: fertilityRate, formula: "")
	}

	func iterate() {
		DispatchQueue.global(qos: .userInitiated).async {
			// perform expensive task
			self.doIterate()

			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.iterationComplete()
			}
		}
	}

	private func doIterate() {

		// first we need to do the calculation
		self.population.calculate()
		self.birthRate.calculate()
		self.happiness.calculate()

		// then we need to push the value
		self.population.push()
		self.birthRate.push()
		self.happiness.push()
	}
}
