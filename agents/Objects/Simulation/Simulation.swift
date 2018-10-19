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
	func simulationTriggered(by event: Event?)
}

class Simulation {

	weak var delegate: SimulationDelegate?

	// Values / Properties
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

	var properties: [Property] = []

	// Policies
	var primarySchools: PrimarySchools
	var sewage: Sewage

	var policies: [Policy] = []

	// Events

	var earthQuakeEvent: Earthquake
	var monumentVandalizedEvent: MonumentVandalized

	var events: [Event] = []

	// Groups

	var conservatives: Conservatives

	var groups: [Group] = []

	// Situations

	var homelessness: Homelessness

	var situations: [Situation] = []

	// Effects

	var effects: [Effect] = []

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

		// policies
		self.primarySchools = PrimarySchools()
		self.sewage = Sewage()

		// events
		self.earthQuakeEvent = Earthquake()
		self.monumentVandalizedEvent = MonumentVandalized()

		// groups
		self.conservatives = Conservatives()

		// situations
		self.homelessness = Homelessness()

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

		// setup groups
		self.conservatives.setup(with: self)

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
		for property in self.properties {
			property.calculate()
		}

		for policy in self.policies {
			policy.calculate()
		}

		for event in self.events {
			event.calculate()
		}

		for group in self.groups {
			group.calculate()
		}

		// find event
		let maxScore = self.events.max(by: { $0.value() < $1.value() })?.value() ?? 0
		let allEventsWithMaxScore = self.events.filter { $0.value() == maxScore }
		print("Best score: \(maxScore) => \(allEventsWithMaxScore.count) items")

		if !allEventsWithMaxScore.isEmpty {

			let eventThatTriggered = allEventsWithMaxScore.randomItem()
			self.effects.append(contentsOf: eventThatTriggered.effects(for: self))

			DispatchQueue.main.async {
				// Update the UI
				self.delegate?.simulationTriggered(by: eventThatTriggered)
			}
		}

		for effect in self.effects {
			effect.calculate()
		}

		// then we need to push the value
		for property in self.properties {
			property.push()
		}

		for policy in self.policies {
			policy.push()
		}

		for event in self.events {
			event.push()
		}

		for group in self.groups {
			group.push()
		}

		for effect in self.effects {
			effect.push()
		}

		// filter effects that are too small
		//print("- before filtering \(self.effects) effects")
		self.effects = self.effects.filter { abs($0.value()) > 0.01 }
		//print("- after filtering \(self.effects) effects")
	}
}

extension Simulation: SituationDelegate {

	func start(situation: Situation?) {
		if let situation = situation {
			print("Situation started: \(situation.name)")
		}
	}

	func end(situation: Situation?) {
		if let situation = situation {
			print("Situation endedb: \(situation.name)")
		}
	}
}
