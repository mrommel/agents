//
//  Simulation.swift
//  agents
//
//  Created by Michael Rommel on 04.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

protocol SimulationDelegate: class {
	func iterationComplete()
}

class Simulation {

	weak var delegate: SimulationDelegate?

	// Values
	var population: Property

	var birthRate: BirthRate
	var mortalityRate: MortalityRate
	var health: Health

	var religiosity: Religiosity

	var happiness: Happiness

	var properties: [Property] = []

	// Policies

	init() {
		self.population = Property(name: "Population", description: "Population desc", category: .core, value: 1000) // total number
		self.properties.append(self.population)

		self.birthRate = BirthRate() // 0..1
		self.properties.append(self.birthRate)
		self.mortalityRate = MortalityRate() // 0..1
		self.properties.append(self.mortalityRate)
		self.health = Health()
		self.properties.append(self.health)

		self.religiosity = Religiosity()
		self.properties.append(self.religiosity)
		self.happiness = Happiness()
		self.properties.append(self.happiness)

		// connect properties
		self.population.add(property: self.population, formula: "x")
		self.population.add(property: self.birthRate, formula: "0.02*x*v")
		self.population.add(property: self.mortalityRate, formula: "-0.02*x*v")
		
		self.birthRate.add(property: self.religiosity, formula: "0.7*x")
		self.birthRate.add(property: self.health, formula: "(x-0.5)^0.7")

		self.mortalityRate.add(property: StaticProperty(value: 0.5))

		self.health.add(property: StaticProperty(value: 0.7))

		self.religiosity.add(property: StaticProperty(value: 0.8))
		self.happiness.add(property: StaticProperty(value: 0.8))
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
		for property in properties {
			property.calculate()
		}

		// then we need to push the value
		for property in properties {
			property.push()
		}
	}
}
