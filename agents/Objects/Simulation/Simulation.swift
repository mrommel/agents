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
	var religiosity: Religiosity

	var happiness: Property

	// Policies

	init() {
		self.population = Property(name: "Population", category: .core, value: 1000) // total number

		self.birthRate = BirthRate()
		self.religiosity = Religiosity()
		self.happiness = Property(name: "Happiness", category: .core, value: 0.8) // in percent

		self.birthRate.add(property: self.religiosity, formula: "0.9*x")
		self.population.add(property: self.birthRate, formula: "")
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
