//
//  Property.swift
//  agents
//
//  Created by Michael Rommel on 09.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Simulation {

	let name: String
	let summary: String
	let category: Category
	var values: [Double] = []
	var inputs: [SimulationRelation] = []
	var techs: [TechnicRelation] = []

	var stashedValue: Double = 0.0

	init(name: String, summary: String, category: Category, value: Double) {
		self.name = name
		self.summary = summary
		self.category = category
		self.values.append(value)
	}

	func setup(with global: GlobalSimulation) {
		assertionFailure("Subclasses need to implement this method")
	}

	func add(simulation: Simulation, formula: String = "x", delay: Int = 0) {
		self.add(simulationRelation: SimulationRelation(simulation: simulation, formula: formula, delay: delay))
	}

	func add(simulationRelation: SimulationRelation) {
		self.inputs.append(simulationRelation)
	}

	func add(technic: Technic, formula: String = "x", delay: Int = 0) {
		self.add(technicRelation: TechnicRelation(technic: technic, formula: formula, delay: delay))
	}

	func add(technicRelation: TechnicRelation) {
		self.techs.append(technicRelation)
	}

	func calculate() {

		self.stashedValue = 0.0

		for relation in self.inputs {

			let expression = NSExpression(format: relation.formula)
			let dict = NSMutableDictionary()
			dict.setValue(self.value(with: 0), forKey: "v")
			dict.setValue(relation.simulation.value(with: relation.delay), forKey: "x")
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
