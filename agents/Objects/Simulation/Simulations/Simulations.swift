//
//  Simulations.swift
//  agents
//
//  Created by Michael Rommel on 24.10.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

class Simulations {

	var population: Population
	var birthRate: BirthRate
	var mortalityRate: MortalityRate
	var health: Health
	var lifeSpan: LifeSpan
	var religiosity: Religiosity
	var happiness: Happiness
	var foodPrice: FoodPrice
	var grossDomesticProduct: GrossDomesticProduct
	var crimeRate: CrimeRate
	var povertyRate: Poverty
	var unemployment: Unemployment
	var education: Education
	var transportSpeed: TransportSpeed

	var sims: [Simulation] = []

	init() {

		self.population = Population() // total number
		self.birthRate = BirthRate() // 0..1
		self.mortalityRate = MortalityRate() // 0..1
		self.health = Health()
		self.lifeSpan = LifeSpan()
		self.religiosity = Religiosity()
		self.happiness = Happiness()
		self.foodPrice = FoodPrice()
		self.grossDomesticProduct = GrossDomesticProduct()
		self.crimeRate = CrimeRate()
		self.povertyRate = Poverty()
		self.unemployment = Unemployment()
		self.education = Education()
		self.transportSpeed = TransportSpeed()
	}

	func setup(with simulation: GlobalSimulation) {

		self.population.setup(with: simulation)
		self.birthRate.setup(with: simulation)
		self.mortalityRate.setup(with: simulation)
		self.health.setup(with: simulation)
		self.lifeSpan.setup(with: simulation)
		self.religiosity.setup(with: simulation)
		self.happiness.setup(with: simulation)
		self.foodPrice.setup(with: simulation)
		self.grossDomesticProduct.setup(with: simulation)
		self.crimeRate.setup(with: simulation)
		self.povertyRate.setup(with: simulation)
		self.unemployment.setup(with: simulation)
		self.education.setup(with: simulation)
		self.transportSpeed.setup(with: simulation)
	}

	func add(simulation: Simulation) {

		self.sims.append(simulation)
	}

	func calculate() {

		self.sims.forEach { $0.calculate() }
	}

	func push() {

		self.sims.forEach { $0.push() }
	}
}

extension Simulations: Sequence {

	struct SimulationsIterator: IteratorProtocol {

		private var index = 0
		private let simulations: [Simulation]

		init(simulations: [Simulation]) {
			self.simulations = simulations
		}

		mutating func next() -> Simulation? {
			let simulation = self.simulations[index]
			index += 1
			return simulation
		}
	}

	func makeIterator() -> SimulationsIterator {
		return SimulationsIterator(simulations: self.sims)
	}
}
