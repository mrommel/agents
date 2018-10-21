//
//  Simulation.swift
//  agents
//
//  Created by Michael Rommel on 04.09.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

protocol GlobalSimulationDelegate: class {
	func iterationComplete()
	func simulationTriggered(by event: Event?)
}

class GlobalSimulation {

	weak var delegate: GlobalSimulationDelegate?

	// Values / Simulations
	var population: Population = Population() // total number
	var birthRate: BirthRate = BirthRate() // 0..1
	var mortalityRate: MortalityRate = MortalityRate() // 0..1
	var health: Health = Health()
	var lifeSpan: LifeSpan = LifeSpan()
	var religiosity: Religiosity = Religiosity()
	var happiness: Happiness = Happiness()
	var foodPrice: FoodPrice = FoodPrice()
	var grossDomesticProduct: GrossDomesticProduct = GrossDomesticProduct()
	var crimeRate: CrimeRate = CrimeRate()
	var povertyRate: Poverty = Poverty()
	var unemployment: Unemployment = Unemployment()
	var education: Education = Education()

	var simulations: [Simulation] = []

	// Policies
	var primarySchools: PrimarySchools = PrimarySchools()
	var sewage: Sewage = Sewage()

	var policies: [Policy] = []

	// Events

	var earthQuakeEvent: Earthquake = Earthquake()
	var monumentVandalizedEvent: MonumentVandalized = MonumentVandalized()
	var ministerialScandal: MinisterialScandal = MinisterialScandal()

	var events: [Event] = []

	// Groups

	var all: All = All()
	var conservatives: Conservatives = Conservatives()
	var poor: Poor = Poor()
	var religious: Religious = Religious()

	var groups: [Group] = []

	// Situations

	var homelessness: Homelessness = Homelessness()

	var situations: [Situation] = []

	// Effects

	var effects: [Effect] = []

	init() {

		// setup properties
		self.population.setup(with: self)
		self.birthRate.setup(with: self)
		self.mortalityRate.setup(with: self)
		self.health.setup(with: self)
		self.lifeSpan.setup(with: self)
		self.religiosity.setup(with: self)
		self.happiness.setup(with: self)
		self.foodPrice.setup(with: self)
		self.grossDomesticProduct.setup(with: self)
		self.crimeRate.setup(with: self)
		self.povertyRate.setup(with: self)
		self.unemployment.setup(with: self)
		self.education.setup(with: self)

		// setup policies
		self.primarySchools.setup(with: self)
		self.sewage.setup(with: self)

		// setup events
		self.earthQuakeEvent.setup(with: self)
		self.monumentVandalizedEvent.setup(with: self)
		self.ministerialScandal.setup(with: self)

		// setup groups
		self.all.setup(with: self)
		self.conservatives.setup(with: self)
		self.poor.setup(with: self)
		self.religious.setup(with: self)

		// setup situations
		self.homelessness.setup(with: self)
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
		self.simulations.forEach { $0.calculate() }
		self.policies.forEach { $0.calculate() }
		self.events.forEach { $0.calculate() }
		self.groups.forEach { $0.calculate() }
		self.situations.forEach { $0.calculate() }
		self.effects.forEach { $0.calculate() }

		// find event
		if let event = self.findEvent() {
			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.simulationTriggered(by: event)
			}
		}

		// then we need to push the value
		self.simulations.forEach { $0.push() }
		self.policies.forEach { $0.push() }
		self.events.forEach { $0.push() }
		self.groups.forEach { $0.push() }
		self.situations.forEach { $0.push() }
		self.effects.forEach { $0.push() }

		// filter effects that are too small
		//print("- before filtering \(self.effects) effects")
		self.effects = self.effects.filter { abs($0.value()) > 0.01 }
		//print("- after filtering \(self.effects) effects")
	}

	func findEvent() -> Event? {

		let maxScore = self.events.max(by: { $0.value() < $1.value() })?.value() ?? 0
		let allEventsWithMaxScore = self.events.filter { $0.value() == maxScore }
		//print("Best score: \(maxScore) => \(allEventsWithMaxScore.count) items")

		if !allEventsWithMaxScore.isEmpty {

			let eventThatTriggered = allEventsWithMaxScore.randomItem()
			let newEffects = eventThatTriggered.effects(for: self)
			newEffects.forEach { $0.calculate() }
			self.effects.append(contentsOf: newEffects)

			return eventThatTriggered
		}

		return nil
	}
}

extension GlobalSimulation: SituationDelegate {

	func start(situation: Situation?) {
		if let situation = situation {
			print("Situation started: \(situation.name)")
		}
	}

	func end(situation: Situation?) {
		if let situation = situation {
			print("Situation ended: \(situation.name)")
		}
	}
}
